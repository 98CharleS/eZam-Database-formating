-- ---------------------------------------------------------
-- PROVINCE ENRICHMENT AGGREGATIONS
-- Purpose: Join tender counts with GDP and population data
-- ---------------------------------------------------------

-- 1. Tenders per province with GDP
DROP TABLE IF EXISTS tenders_by_gdp;

CREATE TABLE tenders_by_gdp AS
SELECT
    t.organizationProvince                          AS wojewodztwo,
    t.total_tenders,
    CAST(REPLACE(g.GDP, ' ', '') AS REAL)           AS gdp_mln_pln,
    ROUND(
        t.total_tenders * 1.0
        / CAST(REPLACE(g.GDP, ' ', '') AS REAL), 4
    )                                               AS przetargi_na_mln_gdp
FROM (
    SELECT organizationProvince, COUNT(*) AS total_tenders
    FROM raw_data
    GROUP BY organizationProvince
) t
JOIN region_GDP.raw_data g
    ON LOWER(TRIM(t.organizationProvince)) = LOWER(TRIM(g.region))
ORDER BY t.total_tenders DESC;

-- 2. Tenders per province with population
DROP TABLE IF EXISTS tenders_by_population;

CREATE TABLE tenders_by_population AS
SELECT
    t.organizationProvince                              AS wojewodztwo,
    t.total_tenders,
    CAST(REPLACE(g.population, ' ', '') AS INTEGER)    AS ludnosc,
    ROUND(
        t.total_tenders * 1.0
        / CAST(REPLACE(g.population, ' ', '') AS INTEGER) * 100000, 2
    )                                                   AS przetargi_na_100k_mieszkancow
FROM (
    SELECT organizationProvince, COUNT(*) AS total_tenders
    FROM raw_data
    GROUP BY organizationProvince
) t
JOIN region_population.raw_data g
    ON LOWER(TRIM(t.organizationProvince)) = LOWER(TRIM(g.region))
ORDER BY t.total_tenders DESC;

-- ---------------------------------------------------------
-- TENDERS WITH POPULATION (WARSAW SEPARATED FROM MASOVIAN)
-- Purpose: Join tender counts with population data,
--          treating Warsaw as a separate region
-- Requires: region_population_with_warsaw.db to be attached
-- ---------------------------------------------------------

-- 3. Tenders per province with population (Warsaw split)
DROP TABLE IF EXISTS tenders_by_population_warsaw_split;

CREATE TABLE tenders_by_population_warsaw_split AS
SELECT
    CASE
        WHEN t.province_split = 'Mazowieckie'
            THEN 'Mazowieckie bez Warszawy'
        ELSE t.province_split
    END                                                     AS wojewodztwo,
    t.total_tenders,
    CAST(REPLACE(p.population, ' ', '') AS INTEGER)        AS ludnosc,
    ROUND(
        t.total_tenders * 1.0
        / CAST(REPLACE(p.population, ' ', '') AS INTEGER) * 100000, 2
    )                                                       AS przetargi_na_100k_mieszkancow
FROM (
    SELECT
        CASE
            WHEN organizationProvince = 'Mazowieckie'
             AND UPPER(TRIM(organizationCity)) = 'WARSZAWA'
                THEN 'Warszawa'
            WHEN organizationProvince = 'Mazowieckie'
                THEN 'Mazowieckie'
            ELSE organizationProvince
        END AS province_split,
        COUNT(*) AS total_tenders
    FROM raw_data
    GROUP BY province_split
) t
JOIN region_population_with_warsaw.raw_data p
    ON LOWER(TRIM(t.province_split)) = LOWER(TRIM(p.region))
ORDER BY t.total_tenders DESC;

-- 4. Tenders per province with GDP per capita
DROP TABLE IF EXISTS tenders_by_gdp_per_capita;

CREATE TABLE tenders_by_gdp_per_capita AS
SELECT
    t.organizationProvince                                      AS wojewodztwo,
    t.total_tenders,
    CAST(REPLACE(g.GDP, ' ', '') AS REAL)                       AS gdp_mln_pln,
    CAST(REPLACE(p.population, ' ', '') AS INTEGER)             AS ludnosc,
    ROUND(
        CAST(REPLACE(g.GDP, ' ', '') AS REAL) * 1000000.0
        / CAST(REPLACE(p.population, ' ', '') AS INTEGER), 2
    )                                                           AS gdp_per_capita_pln,
    t.total_tenders                                             AS suma_przetargow
FROM (
    SELECT organizationProvince, COUNT(*) AS total_tenders
    FROM raw_data
    GROUP BY organizationProvince
) t
JOIN region_GDP.raw_data g
    ON LOWER(TRIM(t.organizationProvince)) = LOWER(TRIM(g.region))
JOIN region_population.raw_data p
    ON LOWER(TRIM(t.organizationProvince)) = LOWER(TRIM(p.region))
ORDER BY gdp_per_capita_pln DESC;