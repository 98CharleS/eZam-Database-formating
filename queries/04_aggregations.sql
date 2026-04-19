-- =============================================================================
-- AGGREGATION SCRIPT
-- Purpose: Create summary tables of tender counts by province and CPV
-- Version: 2.0 (Dynamic Calculations)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- TABLE 1. tenders_by_province
-- Total tenders per province (all years combined)
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS tenders_by_province;

CREATE TABLE tenders_by_province AS
SELECT 
    organizationProvince,
    COUNT(*) AS total_tenders
FROM raw_data
GROUP BY organizationProvince
ORDER BY total_tenders DESC;

-- -----------------------------------------------------------------------------
-- TABLE 2. tenders_by_province_year
-- Tender counts per province broken down by publication year (Pivot)
-- -----------------------------------------------------------------------------
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

-- -----------------------------------------------------------------------------
-- TABLE 3. tenders_by_cpv
-- Total tenders per primary CPV code and description
-- -----------------------------------------------------------------------------
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

-- -----------------------------------------------------------------------------
-- TABLE 4. top5_cpv_by_province_2021
-- Top 5 CPV categories per province for the year 2021
-- -----------------------------------------------------------------------------
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

-- -----------------------------------------------------------------------------
-- TABLE 5. top5_cpv_by_province_2022
-- Top 5 CPV categories per province for the year 2022
-- -----------------------------------------------------------------------------
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

-- -----------------------------------------------------------------------------
-- TABLE 6. top5_cpv_by_province_2023
-- Top 5 CPV categories per province for the year 2023
-- -----------------------------------------------------------------------------
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

-- -----------------------------------------------------------------------------
-- TABLE 7. top5_cpv_by_province_2024
-- Top 5 CPV categories per province for the year 2024
-- -----------------------------------------------------------------------------
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

-- -----------------------------------------------------------------------------
-- TABLE 8. top5_cpv_by_province_2025
-- Top 5 CPV categories per province for the year 2025
-- -----------------------------------------------------------------------------
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

-- -----------------------------------------------------------------------------
-- TABLE 9. top5_cpv_by_province
-- Top 5 CPV categories per province (All years combined)
-- -----------------------------------------------------------------------------
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

-- -----------------------------------------------------------------------------
-- TABLE 10. tenders_by_cpv_division
-- Number of tenders grouped by CPV division (first 2 digits)
-- Percentages formatted as decimal (e.g., 0.39 instead of 39.0)
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS tenders_by_cpv_division;

CREATE TABLE tenders_by_cpv_division AS
WITH raw_stats AS (
    SELECT 
        CAST(SUBSTR(cpvCode, 1, 2) AS INTEGER) AS div_id,
        COUNT(*) OVER() as total_all
    FROM raw_data
)
SELECT 
    r.div_id AS cpv_division,
    COALESCE(d.name, 'Nieznana dywizja') AS division_name,
    COUNT(*) AS tender_count,
    ROUND(COUNT(*) * 1.0 / MAX(r.total_all), 4) AS share_pct -- Wynik 0.3971 zamiast 39.71
FROM raw_stats r
LEFT JOIN cpv_dictionary d ON r.div_id = d.id
GROUP BY r.div_id, d.name
ORDER BY tender_count DESC;

-- -----------------------------------------------------------------------------
-- TABLE 11. tenders_by_province_and_division
-- Number of tenders per province × CPV division
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS tenders_by_province_and_division;

CREATE TABLE tenders_by_province_and_division AS
SELECT 
    organizationProvince AS province,
    CAST(SUBSTR(cpvCode, 1, 2) AS INTEGER) AS cpv_division,
    COALESCE(d.name, 'Nieznana dywizja') AS division_name,
    COUNT(*) AS tender_count
FROM raw_data r
LEFT JOIN cpv_dictionary d ON CAST(SUBSTR(r.cpvCode, 1, 2) AS INTEGER) = d.id
WHERE organizationProvince IS NOT NULL 
  AND organizationProvince != ''
GROUP BY organizationProvince, cpv_division, d.name
ORDER BY organizationProvince ASC, tender_count DESC;

-- -----------------------------------------------------------------------------
-- TABLE 12. top10_cpv_per_year 
-- Number of tenders per year
-- -----------------------------------------------------------------------------
CREATE TABLE top10_cpv_per_year AS
WITH cpv_extracted AS (
    SELECT
        STRFTIME('%Y', publicationDate) AS year,
        TRIM(SUBSTR(cpvCode, 1,
            CASE
                WHEN INSTR(cpvCode, ',') > 0
                THEN INSTR(cpvCode, ',') - 1
                ELSE LENGTH(cpvCode)
            END
        ))                              AS cpv_full,
        TRIM(SUBSTR(cpvCode, 1,
            CASE
                WHEN INSTR(cpvCode, ' ') > 0
                THEN INSTR(cpvCode, ' ') - 1
                ELSE LENGTH(cpvCode)
            END
        ))                              AS cpv_code
    FROM raw_data
    WHERE STRFTIME('%Y', publicationDate) IN ('2021','2022','2023','2024','2025')
),
yearly_counts AS (
    SELECT
        year,
        cpv_code,
        cpv_full,
        COUNT(*)    AS count
    FROM cpv_extracted
    GROUP BY year, cpv_code
),
ranked AS (
    SELECT
        year,
        cpv_code,
        cpv_full,
        count,
        ROW_NUMBER() OVER (
            PARTITION BY year
            ORDER BY count DESC
        ) AS rank
    FROM yearly_counts
)
SELECT
    year        AS year,
    rank        AS rank,
    cpv_full    AS cpv_code_description,
    count       AS tender_count
FROM ranked
WHERE rank <= 10
ORDER BY year, rank;