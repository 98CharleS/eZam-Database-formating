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
