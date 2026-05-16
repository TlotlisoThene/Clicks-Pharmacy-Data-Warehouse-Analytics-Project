/*
===============================================================================
Quality Checks - Silver Layer
===============================================================================
Script Purpose:
    This script performs quality checks on the cleaned data inside the
    'silver' schema for the Clicks Pharmacy Data Warehouse project.

    The checks focus on:
        - Null or duplicate primary keys
        - Invalid or inconsistent values
        - Unwanted spaces
        - Invalid dates
        - Negative numeric values
        - Data standardization
        - Missing business-critical fields

Usage Notes:
    - Run these checks AFTER loading the Silver Layer.
    - Investigate any returned rows.
===============================================================================
*/

-- =============================================================================
-- Checking 'silver.crm_clubcard'
-- =============================================================================

-- Check for NULLs or duplicates in primary key
-- Expectation: No results
SELECT
    clubcard_id,
    COUNT(*) AS record_count
FROM silver.crm_clubcard
GROUP BY clubcard_id
HAVING COUNT(*) > 1
    OR clubcard_id IS NULL;

-- Check for unwanted spaces
-- Expectation: No results
SELECT
    clubcard_id,
    first_name,
    last_name
FROM silver.crm_clubcard
WHERE clubcard_id != TRIM(clubcard_id)
   OR first_name != TRIM(first_name)
   OR last_name != TRIM(last_name);

-- Check invalid email addresses
-- Expectation: Investigate returned rows
SELECT
    clubcard_id,
    email_address
FROM silver.crm_clubcard
WHERE email_address IS NOT NULL
  AND email_address NOT LIKE '%@%.%';

-- Check gender consistency
SELECT DISTINCT
    gender
FROM silver.crm_clubcard;

-- Check loyalty tier consistency
SELECT DISTINCT
    loyalty
FROM silver.crm_clubcard;

-- =============================================================================
-- Checking 'silver.crm_products'
-- =============================================================================

-- Check for NULLs or duplicates in product code
-- Expectation: No results
SELECT
    product_code,
    COUNT(*) AS record_count
FROM silver.crm_products
GROUP BY product_code
HAVING COUNT(*) > 1
    OR product_code IS NULL;

-- Check for unwanted spaces
-- Expectation: No results
SELECT
    product_code,
    brand_name,
    manufacturer
FROM silver.crm_products
WHERE brand_name != TRIM(brand_name)
   OR manufacturer != TRIM(manufacturer);

-- Check negative or NULL prices
-- Expectation: No results
SELECT
    product_code,
    price
FROM silver.crm_products
WHERE price < 0
   OR price IS NULL;

-- Check invalid stock quantities
SELECT
    product_code,
    qty
FROM silver.crm_products
WHERE qty < 0;

-- Check Rx standardization
SELECT DISTINCT
    rx
FROM silver.crm_products;

-- Check VAT consistency
SELECT DISTINCT
    vat
FROM silver.crm_products;

-- =============================================================================
-- Checking 'silver.crm_transactions'
-- =============================================================================

-- Check duplicate transaction IDs
-- Expectation: No results
SELECT
    txn_id,
    COUNT(*) AS record_count
FROM silver.crm_transactions
GROUP BY txn_id
HAVING COUNT(*) > 1
    OR txn_id IS NULL;

-- Check invalid quantities
SELECT
    txn_id,
    qty
FROM silver.crm_transactions
WHERE qty <= 0
   OR qty IS NULL;

-- Check negative payment values
SELECT
    txn_id,
    paid,
    co_pay,
    medical_aid_amount
FROM silver.crm_transactions
WHERE paid < 0
   OR co_pay < 0
   OR medical_aid_amount < 0;

-- Check missing store values
SELECT
    txn_id,
    store
FROM silver.crm_transactions
WHERE store IS NULL;

-- Check chronic flag consistency
SELECT DISTINCT
    chronic
FROM silver.crm_transactions;

-- =============================================================================
-- Checking 'silver.erp_medical_aid_claims'
-- =============================================================================

-- Check duplicate claim IDs
SELECT
    claim_id,
    COUNT(*) AS record_count
FROM silver.erp_medical_aid_claims
GROUP BY claim_id
HAVING COUNT(*) > 1
    OR claim_id IS NULL;

-- Check approved amount > claimed amount
-- Expectation: No results
SELECT
    claim_id,
    claimed_amount,
    approved
FROM silver.erp_medical_aid_claims
WHERE approved > claimed_amount;

-- Check missing medical schemes
SELECT
    claim_id,
    medical_scheme
FROM silver.erp_medical_aid_claims
WHERE medical_scheme IS NULL;

-- =============================================================================
-- Checking 'silver.erp_medical_scheme_members'
-- =============================================================================

-- Check duplicate member IDs
SELECT
    member_id,
    COUNT(*) AS record_count
FROM silver.erp_medical_scheme_members
GROUP BY member_id
HAVING COUNT(*) > 1
    OR member_id IS NULL;

-- Check invalid date ranges
SELECT
    *
FROM silver.erp_medical_scheme_members
WHERE end_date < eff_date;

-- Check relationship consistency
SELECT DISTINCT
    relationship
FROM silver.erp_medical_scheme_members;

-- =============================================================================
-- Checking 'silver.erp_prescription_refills'
-- =============================================================================

-- Check duplicate refill IDs
SELECT
    refill_id,
    COUNT(*) AS record_count
FROM silver.erp_prescription_refills
GROUP BY refill_id
HAVING COUNT(*) > 1
    OR refill_id IS NULL;

-- Check invalid refill usage
SELECT
    refill_id,
    total_fills,
    fills_used
FROM silver.erp_prescription_refills
WHERE fills_used > total_fills
   OR fills_used < 0;

-- Check invalid days supply
SELECT
    refill_id,
    days_supply
FROM silver.erp_prescription_refills
WHERE days_supply <= 0;

-- Check invalid next due dates
SELECT
    refill_id,
    last_fill,
    next_due
FROM silver.erp_prescription_refills
WHERE next_due < last_fill;

-- Check refill status consistency
SELECT DISTINCT
    stat
FROM silver.erp_prescription_refills;
