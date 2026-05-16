/*
Stored Procedure: Load Bronze Layer (Source -> Bronze)
====================================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files.
    
    It performs the following tasks:
      - Truncates bronze tables before loading.
      - Loads CSV data into bronze tables using BULK INSERT.
      - Logs execution duration for each table.
      - Handles load errors using TRY...CATCH.

Source Systems:
      CRM  -> Clicks retail/customer-facing systems
      ERP  -> Medical aid & operational systems

Usage Example:
      EXEC bronze.load_bronze;
====================================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN

    DECLARE @start_time DATETIME,
            @end_time DATETIME,
            @batch_start_time DATETIME,
            @batch_end_time DATETIME;

    BEGIN TRY

        SET @batch_start_time = GETDATE();

        PRINT '=============================================================';
        PRINT 'Loading Bronze Layer';
        PRINT '=============================================================';

        /* ============================================================
           LOAD CRM TABLES
        ============================================================ */

        PRINT '=============================================================';
        PRINT 'Loading CRM Tables';
        PRINT '=============================================================';

        /* -------------------------------
           bronze.crm_clubcard
        -------------------------------- */

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.crm_clubcard';

        TRUNCATE TABLE bronze.crm_clubcard;

        PRINT '>> Inserting Data Into: bronze.crm_clubcard';

        BULK INSERT bronze.crm_clubcard
        FROM 'C:\sql-data-warehouse-project\datasets\source_crm\CLICKS_CLUBCARD.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
              + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
              + ' seconds';

        PRINT '-----------------------------';


        /* -------------------------------
           bronze.crm_products
        -------------------------------- */

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.crm_products';

        TRUNCATE TABLE bronze.crm_products;

        PRINT '>> Inserting Data Into: bronze.crm_products';

        BULK INSERT bronze.crm_products
        FROM 'C:\sql-data-warehouse-project\datasets\source_crm\CLICKS_PRODUCTS.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
              + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
              + ' seconds';

        PRINT '-----------------------------';


        /* -------------------------------
           bronze.crm_transactions
        -------------------------------- */

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.crm_transactions';

        TRUNCATE TABLE bronze.crm_transactions;

        PRINT '>> Inserting Data Into: bronze.crm_transactions';

        BULK INSERT bronze.crm_transactions
        FROM 'C:\sql-data-warehouse-project\datasets\source_crm\CLICKS_TRANSACTIONS.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
              + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
              + ' seconds';

        PRINT '-----------------------------';


        /* ============================================================
           LOAD ERP TABLES
        ============================================================ */

        PRINT '=============================================================';
        PRINT 'Loading ERP Tables';
        PRINT '=============================================================';


        /* -------------------------------
           bronze.erp_medical_aid_claims
        -------------------------------- */

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.erp_medical_aid_claims';

        TRUNCATE TABLE bronze.erp_medical_aid_claims;

        PRINT '>> Inserting Data Into: bronze.erp_medical_aid_claims';

        BULK INSERT bronze.erp_medical_aid_claims
        FROM 'C:\sql-data-warehouse-project\datasets\source_erp\MEDICAL_AID_CLAIMS.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
              + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
              + ' seconds';

        PRINT '-----------------------------';


        /* -------------------------------
           bronze.erp_medical_scheme_members
        -------------------------------- */

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.erp_medical_scheme_members';

        TRUNCATE TABLE bronze.erp_medical_scheme_members;

        PRINT '>> Inserting Data Into: bronze.erp_medical_scheme_members';

        BULK INSERT bronze.erp_medical_scheme_members
        FROM 'C:\sql-data-warehouse-project\datasets\source_erp\MEDICAL_SCHEME_MEMBERS.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
              + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
              + ' seconds';

        PRINT '-----------------------------';


        /* -------------------------------
           bronze.erp_prescription_refills
        -------------------------------- */

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.erp_prescription_refills';

        TRUNCATE TABLE bronze.erp_prescription_refills;

        PRINT '>> Inserting Data Into: bronze.erp_prescription_refills';

        BULK INSERT bronze.erp_prescription_refills
        FROM 'C:\sql-data-warehouse-project\datasets\source_erp\CLICKS_PRESCRIPTION_REFILLS.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT '>> Load Duration: '
              + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
              + ' seconds';

        PRINT '-----------------------------';


        /* ============================================================
           FINAL LOGGING
        ============================================================ */

        SET @batch_end_time = GETDATE();

        PRINT '=============================================================';
        PRINT 'Loading Bronze Layer Completed Successfully';
        PRINT 'Total Load Duration: '
              + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR)
              + ' seconds';
        PRINT '=============================================================';

    END TRY

    BEGIN CATCH

        PRINT '=============================================================';
        PRINT 'ERROR OCCURRED DURING BRONZE LOAD';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number : ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State  : ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '=============================================================';

    END CATCH

END;
GO
