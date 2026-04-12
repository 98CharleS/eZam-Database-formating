-- ---------------------------------------------------------
-- AGGREGATION SCRIPT
-- Purpose: Create summary tables of tender counts by province and CPV
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

-- 3. Total tenders per primary CPV code
-- Extracts only the first CPV code and its description from the cpvCode field
-- Results are ordered descending by tender count
DROP TABLE IF EXISTS tenders_by_cpv;

CREATE TABLE tenders_by_cpv AS
SELECT 
    TRIM(SUBSTR(cpvCode, 1, INSTR(cpvCode, ' ') - 1)) AS cpv_code,
    TRIM(SUBSTR(
        SUBSTR(cpvCode, INSTR(cpvCode, '(') + 1),
        1,
        INSTR(SUBSTR(cpvCode, INSTR(cpvCode, '(') + 1), ')') - 1
    )) AS cpv_description,
    COUNT(*) AS total_tenders
FROM raw_data
GROUP BY cpv_code, cpv_description
ORDER BY total_tenders DESC;

-- ---------------------------------------------------------
-- TOP 5 CPV CATEGORIES PER PROVINCE BY YEAR
-- Extracts primary CPV code and description, ranks by tender count
-- Uses ROW_NUMBER() - requires SQLite >= 3.25
-- Check your version: SELECT sqlite_version();
-- ---------------------------------------------------------

-- 4. Top 5 CPV categories per province - 2021
DROP TABLE IF EXISTS top5_cpv_by_province_2021;

CREATE TABLE top5_cpv_by_province_2021 AS
SELECT wojewodztwo, cpv_code, cpv_description, liczba_przetargow
FROM (
    SELECT
        organizationProvince AS wojewodztwo,
        TRIM(SUBSTR(cpvCode, 1, INSTR(cpvCode, ' ') - 1)) AS cpv_code,
        TRIM(SUBSTR(
            SUBSTR(cpvCode, INSTR(cpvCode, '(') + 1),
            1,
            INSTR(SUBSTR(cpvCode, INSTR(cpvCode, '(') + 1), ')') - 1
        )) AS cpv_description,
        COUNT(*) AS liczba_przetargow,
        ROW_NUMBER() OVER (
            PARTITION BY organizationProvince
            ORDER BY COUNT(*) DESC
        ) AS rn
    FROM raw_data
    WHERE STRFTIME('%Y', publicationDate) = '2021'
    GROUP BY organizationProvince, cpv_code, cpv_description
)
WHERE rn <= 5
ORDER BY wojewodztwo, liczba_przetargow DESC;

-- 5. Top 5 CPV categories per province - 2022
DROP TABLE IF EXISTS top5_cpv_by_province_2022;

CREATE TABLE top5_cpv_by_province_2022 AS
SELECT wojewodztwo, cpv_code, cpv_description, liczba_przetargow
FROM (
    SELECT
        organizationProvince AS wojewodztwo,
        TRIM(SUBSTR(cpvCode, 1, INSTR(cpvCode, ' ') - 1)) AS cpv_code,
        TRIM(SUBSTR(
            SUBSTR(cpvCode, INSTR(cpvCode, '(') + 1),
            1,
            INSTR(SUBSTR(cpvCode, INSTR(cpvCode, '(') + 1), ')') - 1
        )) AS cpv_description,
        COUNT(*) AS liczba_przetargow,
        ROW_NUMBER() OVER (
            PARTITION BY organizationProvince
            ORDER BY COUNT(*) DESC
        ) AS rn
    FROM raw_data
    WHERE STRFTIME('%Y', publicationDate) = '2022'
    GROUP BY organizationProvince, cpv_code, cpv_description
)
WHERE rn <= 5
ORDER BY wojewodztwo, liczba_przetargow DESC;

-- 6. Top 5 CPV categories per province - 2023
DROP TABLE IF EXISTS top5_cpv_by_province_2023;

CREATE TABLE top5_cpv_by_province_2023 AS
SELECT wojewodztwo, cpv_code, cpv_description, liczba_przetargow
FROM (
    SELECT
        organizationProvince AS wojewodztwo,
        TRIM(SUBSTR(cpvCode, 1, INSTR(cpvCode, ' ') - 1)) AS cpv_code,
        TRIM(SUBSTR(
            SUBSTR(cpvCode, INSTR(cpvCode, '(') + 1),
            1,
            INSTR(SUBSTR(cpvCode, INSTR(cpvCode, '(') + 1), ')') - 1
        )) AS cpv_description,
        COUNT(*) AS liczba_przetargow,
        ROW_NUMBER() OVER (
            PARTITION BY organizationProvince
            ORDER BY COUNT(*) DESC
        ) AS rn
    FROM raw_data
    WHERE STRFTIME('%Y', publicationDate) = '2023'
    GROUP BY organizationProvince, cpv_code, cpv_description
)
WHERE rn <= 5
ORDER BY wojewodztwo, liczba_przetargow DESC;

-- 7. Top 5 CPV categories per province - 2024
DROP TABLE IF EXISTS top5_cpv_by_province_2024;

CREATE TABLE top5_cpv_by_province_2024 AS
SELECT wojewodztwo, cpv_code, cpv_description, liczba_przetargow
FROM (
    SELECT
        organizationProvince AS wojewodztwo,
        TRIM(SUBSTR(cpvCode, 1, INSTR(cpvCode, ' ') - 1)) AS cpv_code,
        TRIM(SUBSTR(
            SUBSTR(cpvCode, INSTR(cpvCode, '(') + 1),
            1,
            INSTR(SUBSTR(cpvCode, INSTR(cpvCode, '(') + 1), ')') - 1
        )) AS cpv_description,
        COUNT(*) AS liczba_przetargow,
        ROW_NUMBER() OVER (
            PARTITION BY organizationProvince
            ORDER BY COUNT(*) DESC
        ) AS rn
    FROM raw_data
    WHERE STRFTIME('%Y', publicationDate) = '2024'
    GROUP BY organizationProvince, cpv_code, cpv_description
)
WHERE rn <= 5
ORDER BY wojewodztwo, liczba_przetargow DESC;

-- 8. Top 5 CPV categories per province - 2025
DROP TABLE IF EXISTS top5_cpv_by_province_2025;

CREATE TABLE top5_cpv_by_province_2025 AS
SELECT wojewodztwo, cpv_code, cpv_description, liczba_przetargow
FROM (
    SELECT
        organizationProvince AS wojewodztwo,
        TRIM(SUBSTR(cpvCode, 1, INSTR(cpvCode, ' ') - 1)) AS cpv_code,
        TRIM(SUBSTR(
            SUBSTR(cpvCode, INSTR(cpvCode, '(') + 1),
            1,
            INSTR(SUBSTR(cpvCode, INSTR(cpvCode, '(') + 1), ')') - 1
        )) AS cpv_description,
        COUNT(*) AS liczba_przetargow,
        ROW_NUMBER() OVER (
            PARTITION BY organizationProvince
            ORDER BY COUNT(*) DESC
        ) AS rn
    FROM raw_data
    WHERE STRFTIME('%Y', publicationDate) = '2025'
    GROUP BY organizationProvince, cpv_code, cpv_description
)
WHERE rn <= 5
ORDER BY wojewodztwo, liczba_przetargow DESC;


-- ---------------------------------------------------------
-- TOP 5 CPV CATEGORIES PER PROVINCE (ALL YEARS COMBINED)
-- ---------------------------------------------------------

DROP TABLE IF EXISTS top5_cpv_by_province;

CREATE TABLE top5_cpv_by_province AS
SELECT wojewodztwo, cpv_code, cpv_description, liczba_przetargow
FROM (
    SELECT
        organizationProvince AS wojewodztwo,
        TRIM(SUBSTR(cpvCode, 1, INSTR(cpvCode, ' ') - 1)) AS cpv_code,
        TRIM(SUBSTR(
            SUBSTR(cpvCode, INSTR(cpvCode, '(') + 1),
            1,
            INSTR(SUBSTR(cpvCode, INSTR(cpvCode, '(') + 1), ')') - 1
        )) AS cpv_description,
        COUNT(*) AS liczba_przetargow,
        ROW_NUMBER() OVER (
            PARTITION BY organizationProvince
            ORDER BY COUNT(*) DESC
        ) AS rn
    FROM raw_data
    GROUP BY organizationProvince, cpv_code, cpv_description
)
WHERE rn <= 5
ORDER BY wojewodztwo, liczba_przetargow DESC;