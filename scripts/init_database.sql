/*
===============================================================================
Create Database and Schemas
===============================================================================
Script Purpose:
    This script creates a new database named 'ClicksPharmacyDW'.
    If the database already exists, it will be dropped and recreated.

    The script also creates the following schemas:
        - bronze  -> Raw source data
        - silver  -> Cleaned and transformed data
        - gold    -> Analytics-ready business layer

WARNING:
    Running this script will permanently delete the existing
    'ClicksPharmacyDW' database and all its data.
    Ensure proper backups before execution.
===============================================================================
*/

USE master;
GO

-- Drop existing database if it exists
IF EXISTS (
    SELECT 1
    FROM sys.databases
    WHERE name = 'ClicksPharmacyDW'
)
BEGIN
    ALTER DATABASE ClicksPharmacyDW
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

    DROP DATABASE ClicksPharmacyDW;
END;
GO

-- Create database
CREATE DATABASE ClicksPharmacyDW;
GO

USE ClicksPharmacyDW;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
CREATE SCHEMA gold;
GO
