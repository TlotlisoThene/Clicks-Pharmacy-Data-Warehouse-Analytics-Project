/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process
    to populate the 'silver' schema tables from the 'bronze' schema.

It performs the following tasks:
    - Truncates silver tables.
    - Cleans and standardizes data.
    - Handles inconsistent formats and missing values.
    - Loads transformed data into silver tables.

Usage Example:
    EXEC silver.load_silver;
===============================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN

    DECLARE @start_time DATETIME,
            @end_time DATETIME,
            @batch_start_time DATETIME,
            @batch_end_time DATETIME;

    BEGIN TRY

        SET @batch_start_time = GETDATE();

        PRINT '=============================================================';
        PRINT 'Loading Silver Layer';
        PRINT '=============================================================';


        /* =============================================================
           LOAD CRM TABLES
        ============================================================= */

        PRINT '=============================================================';
        PRINT 'Loading CRM Tables';
        PRINT '=============================================================';


        /* -------------------------------------------------------------
           silver.crm_clubcard
        ------------------------------------------------------------- */

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: silver.crm_clubcard';

        TRUNCATE TABLE silver.crm_clubcard;

        PRINT '>> Inserting Data Into: silver.crm_clubcard';

        INSERT INTO silver.crm_clubcard (
            clubcard_id,
            first_name,
            last_name,
            id_number,
            gender,
            cell_number,
            email_address,
            city,
            postal_code,
            loyalty_tier,
            last_visit_date,
            language_pref
        )

        SELECT

            TRIM(clubcard_id),

            TRIM([first name]),

            TRIM([last name]),

            TRIM([ID Number]),

            CASE
                WHEN UPPER(TRIM(Gender)) = 'M' THEN 'Male'
                WHEN UPPER(TRIM(Gender)) = 'F' THEN 'Female'
                ELSE 'Unknown'
            END AS gender,

            REPLACE(REPLACE(TRIM(Cell), '-', ''), ' ', '') AS cell_number,

            CASE
                WHEN [email address] LIKE '%@%.%' THEN TRIM([email address])
                ELSE NULL
            END AS email_address,

            UPPER(TRIM(City)) AS city,

            TRIM(code) AS postal_code,

            CASE
                WHEN loyalty IS NULL OR TRIM(loyalty) = '' THEN 'Unknown'
                ELSE TRIM(loyalty)
            END AS loyalty_tier,

            TRY_CAST(LastVisit AS DATE) AS last_visit_date,

            UPPER(TRIM(lang)) AS language_pref

        FROM bronze.crm_clubcard;

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
              + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
              + ' seconds';

        PRINT '-----------------------------';



        /* -------------------------------------------------------------
           silver.crm_products
        ------------------------------------------------------------- */

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: silver.crm_products';

        TRUNCATE TABLE silver.crm_products;

        PRINT '>> Inserting Data Into: silver.crm_products';

        INSERT INTO silver.crm_products (

            product_code,
            brand_name,
            generic_name,
            manufacturer,
            product_price,
            schedule_level,
            category,
            prescription_flag,
            ndc_code,
            stock_quantity,
            vat_applicable

        )

        SELECT

            UPPER(TRIM([prod code])) AS product_code,

            CASE
                WHEN [Brand Name] IS NULL OR TRIM([Brand Name]) = ''
                THEN 'Unknown'
                ELSE TRIM([Brand Name])
            END AS brand_name,

            TRIM(generic) AS generic_name,

            TRIM(manufacturer) AS manufacturer,

            TRY_CAST(price AS DECIMAL(10,2)) AS product_price,

            TRY_CAST(Sched AS INT) AS schedule_level,

            TRIM(Category) AS category,

            CASE
                WHEN UPPER(TRIM(Rx)) IN ('TRUE','YES','Y') THEN 'Yes'
                WHEN UPPER(TRIM(Rx)) IN ('FALSE','NO','N') THEN 'No'
                ELSE 'Unknown'
            END AS prescription_flag,

            TRIM(Ndc) AS ndc_code,

            TRY_CAST(Qty AS INT) AS stock_quantity,

            CASE
                WHEN UPPER(TRIM(VAT)) IN ('YES','TRUE','Y')
                THEN 'Yes'
                ELSE 'No'
            END AS vat_applicable

        FROM bronze.crm_products

        WHERE [prod code] IS NOT NULL
          AND TRIM([prod code]) <> '';

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
              + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
              + ' seconds';

        PRINT '-----------------------------';



        /* -------------------------------------------------------------
           silver.crm_transactions
        ------------------------------------------------------------- */

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: silver.crm_transactions';

        TRUNCATE TABLE silver.crm_transactions;

        PRINT '>> Inserting Data Into: silver.crm_transactions';

        INSERT INTO silver.crm_transactions (

            transaction_id,
            clubcard_id,
            product_code,
            date_filled,
            quantity,
            amount_paid,
            copay_amount,
            medical_aid_amount,
            store_code,
            doctor_id,
            refill_number,
            chronic_flag

        )

        SELECT

            TRY_CAST([txn id] AS INT),

            TRIM(clubcard_id),

            UPPER(TRIM([product code])),

            TRY_CAST([date filled] AS DATE),

            CASE
                WHEN TRY_CAST(qty AS INT) < 0 THEN NULL
                ELSE TRY_CAST(qty AS INT)
            END AS quantity,

            TRY_CAST(paid AS DECIMAL(10,2)),

            TRY_CAST([co pay] AS DECIMAL(10,2)),

            TRY_CAST([medical aid $] AS DECIMAL(10,2)),

            UPPER(TRIM(store)),

            UPPER(TRIM([doc id])),

            TRY_CAST([refill#] AS INT),

            CASE
                WHEN UPPER(TRIM(chronic)) IN ('TRUE','YES','Y','1')
                THEN 'Yes'
                ELSE 'No'
            END AS chronic_flag

        FROM bronze.crm_transactions;

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
              + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
              + ' seconds';

        PRINT '-----------------------------';



        /* =============================================================
           LOAD ERP TABLES
        ============================================================= */

        PRINT '=============================================================';
        PRINT 'Loading ERP Tables';
        PRINT '=============================================================';


        /* -------------------------------------------------------------
           silver.erp_medical_aid_claims
        ------------------------------------------------------------- */

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: silver.erp_medical_aid_claims';

        TRUNCATE TABLE silver.erp_medical_aid_claims;

        PRINT '>> Inserting Data Into: silver.erp_medical_aid_claims';

        INSERT INTO silver.erp_medical_aid_claims (

            claim_id,
            clubcard_id,
            date_filled,
            product_code,
            claimed_amount,
            approved_amount,
            denial_reason,
            medical_scheme,
            plan_name,
            process_date

        )

        SELECT

            TRIM([claim id]),

            TRIM([clubcard id]),

            TRY_CAST([date filled] AS DATE),

            UPPER(TRIM([prod code])),

            TRY_CAST([claimed amount] AS DECIMAL(10,2)),

            TRY_CAST(approved AS DECIMAL(10,2)),

            TRIM([denial reason]),

            TRIM([medical scheme]),

            TRIM(plan),

            TRY_CAST([process date] AS DATE)

        FROM bronze.erp_medical_aid_claims;

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
              + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
              + ' seconds';

        PRINT '-----------------------------';



        /* -------------------------------------------------------------
           silver.erp_medical_scheme_members
        ------------------------------------------------------------- */

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: silver.erp_medical_scheme_members';

        TRUNCATE TABLE silver.erp_medical_scheme_members;

        PRINT '>> Inserting Data Into: silver.erp_medical_scheme_members';

        INSERT INTO silver.erp_medical_scheme_members (

            member_id,
            clubcard_id,
            medical_scheme,
            joined_date,
            employer_group,
            plan_name,
            relationship_type,
            effective_date,
            end_date

        )

        SELECT

            TRIM([member id]),

            TRIM([clubcard id]),

            TRIM([medical scheme]),

            TRY_CAST([joined date] AS DATE),

            TRIM([employer group]),

            TRIM([plan name]),

            CASE
                WHEN relationship IS NULL OR TRIM(relationship) = ''
                THEN 'Unknown'
                ELSE TRIM(relationship)
            END AS relationship_type,

            TRY_CAST([eff date] AS DATE),

            TRY_CAST([end date] AS DATE)

        FROM bronze.erp_medical_scheme_members;

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
              + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
              + ' seconds';

        PRINT '-----------------------------';



        /* -------------------------------------------------------------
           silver.erp_prescription_refills
        ------------------------------------------------------------- */

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: silver.erp_prescription_refills';

        TRUNCATE TABLE silver.erp_prescription_refills;

        PRINT '>> Inserting Data Into: silver.erp_prescription_refills';

        INSERT INTO silver.erp_prescription_refills (

            refill_id,
            clubcard_id,
            product_code,
            prescription_date,
            authorization_number,
            total_fills,
            fills_used,
            last_fill_date,
            days_supply,
            next_due_date,
            prescriber_id,
            refill_status

        )

        SELECT

            TRIM([refill id]),

            TRIM([clubcard id]),

            UPPER(TRIM([product code])),

            TRY_CAST([presc date] AS DATE),

            TRIM([auth number]),

            TRY_CAST([total fills] AS INT),

            TRY_CAST([fills used] AS INT),

            TRY_CAST([last fill] AS DATE),

            TRY_CAST([days supply] AS INT),

            TRY_CAST([next due] AS DATE),

            UPPER(TRIM(prescriber)),

            CASE
                WHEN UPPER(TRIM(stat)) IN ('A','ACTIVE')
                THEN 'Active'

                WHEN UPPER(TRIM(stat)) = 'COMPLETE'
                THEN 'Complete'

                WHEN UPPER(TRIM(stat)) = 'EXPIRED'
                THEN 'Expired'

                WHEN UPPER(TRIM(stat)) = 'SUSPENDED'
                THEN 'Suspended'

                ELSE 'Unknown'
            END AS refill_status

        FROM bronze.erp_prescription_refills;

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
              + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
              + ' seconds';

        PRINT '-----------------------------';



        /* =============================================================
           FINAL LOGGING
        ============================================================= */

        SET @batch_end_time = GETDATE();

        PRINT '=============================================================';
        PRINT 'Loading Silver Layer Completed Successfully';
        PRINT 'Total Load Duration: '
              + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR)
              + ' seconds';
        PRINT '=============================================================';

    END TRY

    BEGIN CATCH

        PRINT '=============================================================';
        PRINT 'ERROR OCCURRED DURING LOADING SILVER LAYER';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number : ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State  : ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '=============================================================';

    END CATCH

END;
GO
