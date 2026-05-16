/*
DDL Script: Create Bronze Tables
----------------------------------------------------------------------------------
Script Purpose:
    This script creates tables in the 'bronze' schema for the
    Clicks Pharmacy Data Warehouse Project.

    The bronze layer stores raw data imported directly from CSV files
    before cleansing and transformation.

    Existing tables are dropped before being recreated.
----------------------------------------------------------------------------------
*/

-- =========================
-- CRM TABLES
-- =========================

IF OBJECT_ID ('bronze.crm_clubcard', 'U') IS NOT NULL
    DROP TABLE bronze.crm_clubcard;
GO

CREATE TABLE bronze.crm_clubcard (

    clubcard_id        NVARCHAR(20),
    first_name         NVARCHAR(50),
    last_name          NVARCHAR(50),
    id_number          NVARCHAR(20),
    gender             NVARCHAR(10),
    cell               NVARCHAR(20),
    email_address      NVARCHAR(100),
    city               NVARCHAR(50),
    postal_code        NVARCHAR(10),
    loyalty_tier       NVARCHAR(20),
    last_visit         DATE,
    language_pref      NVARCHAR(20)

);
GO


IF OBJECT_ID ('bronze.crm_transactions', 'U') IS NOT NULL
    DROP TABLE bronze.crm_transactions;
GO

CREATE TABLE bronze.crm_transactions (

    txn_id             INT,
    clubcard_id        NVARCHAR(20),
    product_code       NVARCHAR(50),
    date_filled        NVARCHAR(50),
    quantity           NVARCHAR(50),
    amount_paid        DECIMAL(10,2),
    copay_amount       NVARCHAR(50),
    medical_aid_amt    DECIMAL(10,2),
    store_code         NVARCHAR(20),
    doctor_id          NVARCHAR(20),
    refill_number      INT,
    chronic_flag       NVARCHAR(20)

);
GO


IF OBJECT_ID ('bronze.crm_prescription_refills', 'U') IS NOT NULL
    DROP TABLE bronze.crm_prescription_refills;
GO

CREATE TABLE bronze.crm_prescription_refills (

    refill_id          NVARCHAR(20),
    clubcard_id        NVARCHAR(20),
    product_code       NVARCHAR(50),
    prescription_date  NVARCHAR(50),
    auth_number        NVARCHAR(50),
    total_fills        INT,
    fills_used         INT,
    last_fill_date     NVARCHAR(50),
    days_supply        INT,
    next_due_date      NVARCHAR(50),
    prescriber_id      NVARCHAR(20),
    refill_status      NVARCHAR(20)

);
GO


-- =========================
-- ERP TABLES
-- =========================

IF OBJECT_ID ('bronze.erp_products', 'U') IS NOT NULL
    DROP TABLE bronze.erp_products;
GO

CREATE TABLE bronze.erp_products (

    product_code           NVARCHAR(50),
    brand_name             NVARCHAR(100),
    generic_name           NVARCHAR(100),
    manufacturer           NVARCHAR(100),
    unit_price             DECIMAL(10,2),
    schedule_level         NVARCHAR(10),
    category               NVARCHAR(50),
    prescription_required  NVARCHAR(20),
    ndc_code               NVARCHAR(50),
    stock_quantity         INT,
    vat_applicable         NVARCHAR(20)

);
GO


IF OBJECT_ID ('bronze.erp_medical_aid_claims', 'U') IS NOT NULL
    DROP TABLE bronze.erp_medical_aid_claims;
GO

CREATE TABLE bronze.erp_medical_aid_claims (

    claim_id           NVARCHAR(20),
    clubcard_id        NVARCHAR(20),
    date_filled        NVARCHAR(50),
    product_code       NVARCHAR(50),
    claimed_amount     DECIMAL(10,2),
    approved_amount    DECIMAL(10,2),
    denial_reason      NVARCHAR(100),
    medical_scheme     NVARCHAR(100),
    plan_name          NVARCHAR(100),
    process_date       NVARCHAR(50)

);
GO


IF OBJECT_ID ('bronze.erp_medical_scheme_members', 'U') IS NOT NULL
    DROP TABLE bronze.erp_medical_scheme_members;
GO

CREATE TABLE bronze.erp_medical_scheme_members (

    member_id          NVARCHAR(20),
    clubcard_id        NVARCHAR(20),
    medical_scheme     NVARCHAR(100),
    joined_date        DATE,
    employer_group     NVARCHAR(50),
    plan_name          NVARCHAR(100),
    relationship_type  NVARCHAR(50),
    effective_date     DATE,
    end_date           DATE

);
GO
