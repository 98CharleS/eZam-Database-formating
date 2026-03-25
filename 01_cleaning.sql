-- ---------------------------------------------------------
-- DATA CLEANING SCRIPT
-- Purpose: Remove non-PL records and drop unnecessary columns
-- ---------------------------------------------------------

-- 1. Remove all records where organizationCountry is not Poland (PL)
-- This ensures the analysis focuses only on the Polish market
DELETE FROM raw_data 
WHERE organizationCountry != 'PL' OR organizationCountry IS NULL;

-- 2. Drop columns that contain only NULL values
-- Note: Requires SQLite version 3.35.0 or newer
ALTER TABLE raw_data DROP COLUMN TenderType;
ALTER TABLE raw_data DROP COLUMN procedureResult;

-- 3. Finalize data by trimming whitespace from key columns
UPDATE raw_data 
SET 
    organizationName = TRIM(organizationName),
    organizationCity = TRIM(organizationCity),
    organizationProvince = TRIM(organizationProvince);
