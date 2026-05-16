/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables
    if they already exist.

    The Silver Layer contains cleaned, standardized, and transformation-ready
    data loaded from the Bronze Layer.

    Run this script to re-define the DDL structure of the 'silver' tables.
===============================================================================
*/


/* ============================================================================
   CRM TABLES
============================================================================ */


/* ----------------------------------------------------------------------------
   silver.crm_clubcard
---------------------------------------------------------------------------- */

IF OBJECT_ID ('silver.crm_clubcard', 'U') IS NOT NULL
    DROP TABLE silver.crm_clubcard;
GO

CREATE TABLE silver.crm_clubcard (

    clubcard_id        NVARCHAR(50),
    first_name         NVARCHAR(50),
    last_name          NVARCHAR(50),
    id_number          NVARCHAR(20),
    gender             NVARCHAR(10),
    cell_number        NVARCHAR(20),
    email_address      NVARCHAR(100),
    city               NVARCHAR(50),
    postal_code        NVARCHAR(10),
    loyalty_tier       NVARCHAR(20),
    last_visit_date    DATE,
    language_pref      NVARCHAR(20),

    dwh_create_date    DATETIME2 DEFAULT GETDATE()

);
GO


/* ----------------------------------------------------------------------------
   silver.crm_products
---------------------------------------------------------------------------- */

IF OBJECT_ID ('silver.crm_products', 'U') IS NOT NULL
    DROP TABLE silver.crm_products;
GO

CREATE TABLE silver.crm_products (

    product_code       NVARCHAR(50),
    brand_name         NVARCHAR(100),
    generic_name       NVARCHAR(100),
    manufacturer       NVARCHAR(100),
    product_price      DECIMAL(10,2),
    schedule_level     INT,
    category           NVARCHAR(50),
    prescription_flag  NVARCHAR(10),
    ndc_code           NVARCHAR(50),
    stock_quantity     INT,
    vat_applicable     NVARCHAR(10),

    dwh_create_date    DATETIME2 DEFAULT GETDATE()

);
GO


/* ----------------------------------------------------------------------------
   silver.crm_transactions
---------------------------------------------------------------------------- */

IF OBJECT_ID ('silver.crm_transactions', 'U') IS NOT NULL
    DROP TABLE silver.crm_transactions;
GO

CREATE TABLE silver.crm_transactions (

    transaction_id         INT,
    clubcard_id            NVARCHAR(50),
    product_code           NVARCHAR(50),
    date_filled            DATE,
    quantity               INT,
    amount_paid            DECIMAL(10,2),
    copay_amount           DECIMAL(10,2),
    medical_aid_amount     DECIMAL(10,2),
    store_code             NVARCHAR(20),
    doctor_id              NVARCHAR(20),
    refill_number          INT,
    chronic_flag           NVARCHAR(10),

    dwh_create_date        DATETIME2 DEFAULT GETDATE()

);
GO



/* ============================================================================
   ERP TABLES
============================================================================ */


/* ----------------------------------------------------------------------------
   silver.erp_medical_aid_claims
---------------------------------------------------------------------------- */

IF OBJECT_ID ('silver.erp_medical_aid_claims', 'U') IS NOT NULL
    DROP TABLE silver.erp_medical_aid_claims;
GO

CREATE TABLE silver.erp_medical_aid_claims (

    claim_id               NVARCHAR(50),
    clubcard_id            NVARCHAR(50),
    date_filled            DATE,
    product_code           NVARCHAR(50),
    claimed_amount         DECIMAL(10,2),
    approved_amount        DECIMAL(10,2),
    denial_reason          NVARCHAR(100),
    medical_scheme         NVARCHAR(100),
    plan_name              NVARCHAR(100),
    process_date           DATE,

    dwh_create_date        DATETIME2 DEFAULT GETDATE()

);
GO


/* ----------------------------------------------------------------------------
   silver.erp_medical_scheme_members
---------------------------------------------------------------------------- */

IF OBJECT_ID ('silver.erp_medical_scheme_members', 'U') IS NOT NULL
    DROP TABLE silver.erp_medical_scheme_members;
GO

CREATE TABLE silver.erp_medical_scheme_members (

    member_id              NVARCHAR(50),
    clubcard_id            NVARCHAR(50),
    medical_scheme         NVARCHAR(100),
    joined_date            DATE,
    employer_group         NVARCHAR(50),
    plan_name              NVARCHAR(100),
    relationship_type      NVARCHAR(50),
    effective_date         DATE,
    end_date               DATE,

    dwh_create_date        DATETIME2 DEFAULT GETDATE()

);
GO


/* ----------------------------------------------------------------------------
   silver.erp_prescription_refills
---------------------------------------------------------------------------- */

IF OBJECT_ID ('silver.erp_prescription_refills', 'U') IS NOT NULL
    DROP TABLE silver.erp_prescription_refills;
GO

CREATE TABLE silver.erp_prescription_refills (

    refill_id              NVARCHAR(50),
    clubcard_id            NVARCHAR(50),
    product_code           NVARCHAR(50),
    prescription_date      DATE,
    authorization_number   NVARCHAR(50),
    total_fills            INT,
    fills_used             INT,
    last_fill_date         DATE,
    days_supply            INT,
    next_due_date          DATE,
    prescriber_id          NVARCHAR(20),
    refill_status          NVARCHAR(20),

    dwh_create_date        DATETIME2 DEFAULT GETDATE()

);
GO
