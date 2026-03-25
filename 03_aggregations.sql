-- ---------------------------------------------------------
-- AGGREGATION SCRIPT
-- Purpose: Create summary tables of tender counts by province
-- ---------------------------------------------------------

-- 1. Total tenders per province (all years combined)
-- Results are ordered descending by tender count
DROP TABLE IF EXISTS tenders_by_province;

CREATE TABLE tenders_by_province AS
SELECT 
    organizationProvince,
    COUNT(*) AS total_tenders
FROM raw_data
GROUP BY organizationProvince
ORDER BY total_tenders DESC;

-- 2. Tender counts per province broken down by publication year
-- Each year is represented as a separate column (pivot)
-- Rows are ordered alphabetically by province code
DROP TABLE IF EXISTS tenders_by_province_year;

CREATE TABLE tenders_by_province_year AS
SELECT 
    organizationProvince,
    SUM(CASE WHEN STRFTIME('%Y', publicationDate) = '2021' THEN 1 ELSE 0 END) AS "2021",
    SUM(CASE WHEN STRFTIME('%Y', publicationDate) = '2022' THEN 1 ELSE 0 END) AS "2022",
    SUM(CASE WHEN STRFTIME('%Y', publicationDate) = '2023' THEN 1 ELSE 0 END) AS "2023",
    SUM(CASE WHEN STRFTIME('%Y', publicationDate) = '2024' THEN 1 ELSE 0 END) AS "2024",
    SUM(CASE WHEN STRFTIME('%Y', publicationDate) = '2025' THEN 1 ELSE 0 END) AS "2025"
FROM raw_data
GROUP BY organizationProvince
ORDER BY organizationProvince;