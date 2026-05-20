/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the pharmacy data warehouse. 
    The Gold layer represents the final business-ready dimension and fact tables 
    designed using a Star Schema model.

    These views integrate, cleanse, and transform data from the Silver layer
    into analytics-ready datasets for reporting and business intelligence.

Usage:
    - Query these views directly for analytics, dashboards, and reporting.
===============================================================================
*/

-- =============================================================================
-- Create Dimension: gold.dim_patients
-- =============================================================================
IF OBJECT_ID('gold.dim_patients', 'V') IS NOT NULL
    DROP VIEW gold.dim_patients;
GO

CREATE VIEW gold.dim_patients AS
SELECT
    ROW_NUMBER() OVER (ORDER BY cc.clubcard_id) AS patient_key, -- Surrogate Key
    cc.clubcard_id,
    cc.first_name,
    cc.last_name,
    cc.gender,
    cc.cell_number,
    cc.email,
    cc.city,
    cc.postal_code,
    cc.loyalty_tier,
    mm.medical_scheme,
    mm.plan_type,
    mm.membership_status,
    mm.dependent_count,
    cc.last_visit_date,
    cc.language_preference,
    cc.registration_date
FROM silver.crm_clubcard cc
LEFT JOIN silver.erp_medical_scheme_members mm
    ON cc.clubcard_id = mm.clubcard_id;
GO


-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

CREATE VIEW gold.dim_products AS
SELECT
    ROW_NUMBER() OVER (ORDER BY pr.product_id) AS product_key, -- Surrogate Key
    pr.product_id,
    pr.product_code,
    pr.product_name,
    pr.generic_name,
    pr.category,
    pr.subcategory,
    pr.schedule_level,
    pr.brand_type,
    pr.manufacturer,
    pr.unit_price,
    pr.stock_quantity,
    pr.requires_prescription,
    pr.expiry_tracking_flag
FROM silver.crm_products pr;
GO


-- =============================================================================
-- Create Dimension: gold.dim_stores
-- =============================================================================
IF OBJECT_ID('gold.dim_stores', 'V') IS NOT NULL
    DROP VIEW gold.dim_stores;
GO

CREATE VIEW gold.dim_stores AS
SELECT DISTINCT
    ROW_NUMBER() OVER (ORDER BY tr.store_code) AS store_key,
    tr.store_code,
    tr.store_name,
    tr.city,
    tr.province,
    tr.region
FROM silver.crm_transactions tr;
GO


-- =============================================================================
-- Create Fact Table: gold.fact_dispensing
-- =============================================================================
IF OBJECT_ID('gold.fact_dispensing', 'V') IS NOT NULL
    DROP VIEW gold.fact_dispensing;
GO

CREATE VIEW gold.fact_dispensing AS
SELECT
    tr.transaction_id,
    pt.patient_key,
    pr.product_key,
    st.store_key,

    tr.transaction_date,
    tr.prescription_number,
    tr.quantity_dispensed,
    tr.unit_price,
    tr.total_amount,
    tr.payment_method,
    tr.dispensing_fee,

    CASE
        WHEN tr.chronic_flag IN ('Y', 'Yes', 'TRUE', '1')
            THEN 1
        ELSE 0
    END AS chronic_flag

FROM silver.crm_transactions tr

LEFT JOIN gold.dim_patients pt
    ON tr.clubcard_id = pt.clubcard_id

LEFT JOIN gold.dim_products pr
    ON tr.product_code = pr.product_code

LEFT JOIN gold.dim_stores st
    ON tr.store_code = st.store_code;
GO


-- =============================================================================
-- Create Fact Table: gold.fact_medical_claims
-- =============================================================================
IF OBJECT_ID('gold.fact_medical_claims', 'V') IS NOT NULL
    DROP VIEW gold.fact_medical_claims;
GO

CREATE VIEW gold.fact_medical_claims AS
SELECT
    mc.claim_id,
    pt.patient_key,
    st.store_key,

    mc.claim_date,
    mc.medical_scheme,
    mc.plan_type,
    mc.claim_amount,
    mc.approved_amount,
    mc.copay_amount,
    mc.claim_status,

    CASE
        WHEN mc.claim_status = 'Denied'
            THEN 1
        ELSE 0
    END AS denied_flag

FROM silver.erp_medical_aid_claims mc

LEFT JOIN gold.dim_patients pt
    ON mc.clubcard_id = pt.clubcard_id

LEFT JOIN gold.dim_stores st
    ON mc.store_code = st.store_code;
GO


-- =============================================================================
-- Create Fact Table: gold.fact_prescription_refills
-- =============================================================================
IF OBJECT_ID('gold.fact_prescription_refills', 'V') IS NOT NULL
    DROP VIEW gold.fact_prescription_refills;
GO

CREATE VIEW gold.fact_prescription_refills AS
SELECT
    rf.refill_id,
    pt.patient_key,
    pr.product_key,

    rf.prescription_number,
    rf.refill_date,
    rf.days_supply,
    rf.refill_status,
    rf.adherence_score,
    rf.next_refill_due_date

FROM silver.erp_prescription_refills rf

LEFT JOIN gold.dim_patients pt
    ON rf.clubcard_id = pt.clubcard_id

LEFT JOIN gold.dim_products pr
    ON rf.product_code = pr.product_code;
GO
