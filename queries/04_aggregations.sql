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

-- =============================================================
-- TABLE 1: tenders_by_cpv_division
-- Number of tenders grouped by CPV division (primary CPV code)
-- Rebuilt from raw_data; re-run after data updates
-- =============================================================

DROP TABLE IF EXISTS tenders_by_cpv_division;

CREATE TABLE tenders_by_cpv_division (
    cpv_division    INTEGER PRIMARY KEY,
    division_name   TEXT    NOT NULL,
    tender_count    INTEGER NOT NULL,
    share_pct       REAL    NOT NULL  -- % of all tenders
);

INSERT INTO tenders_by_cpv_division VALUES (45, 'Roboty budowlane', 19854, 39.71);
INSERT INTO tenders_by_cpv_division VALUES (33, 'Sprzęt medyczny i farmaceutyczny', 3504, 7.01);
INSERT INTO tenders_by_cpv_division VALUES (71, 'Usługi architektoniczne i inżynieryjne', 3131, 6.26);
INSERT INTO tenders_by_cpv_division VALUES (30, 'Sprzęt komputerowy i biurowy', 2818, 5.64);
INSERT INTO tenders_by_cpv_division VALUES (34, 'Sprzęt transportowy i pojazdy', 1734, 3.47);
INSERT INTO tenders_by_cpv_division VALUES (9, 'Produkty naftowe, paliwa i energia', 1597, 3.19);
INSERT INTO tenders_by_cpv_division VALUES (15, 'Artykuły spożywcze i napoje', 1389, 2.78);
INSERT INTO tenders_by_cpv_division VALUES (90, 'Usługi środowiskowe i sanitarne', 1375, 2.75);
INSERT INTO tenders_by_cpv_division VALUES (39, 'Meble i wyposażenie wnętrz', 1344, 2.69);
INSERT INTO tenders_by_cpv_division VALUES (60, 'Usługi transportu drogowego', 1296, 2.59);
INSERT INTO tenders_by_cpv_division VALUES (79, 'Usługi biznesowe i doradcze', 1148, 2.3);
INSERT INTO tenders_by_cpv_division VALUES (80, 'Usługi edukacyjne', 1129, 2.26);
INSERT INTO tenders_by_cpv_division VALUES (55, 'Usługi hotelarskie i restauracyjne', 1039, 2.08);
INSERT INTO tenders_by_cpv_division VALUES (48, 'Pakiety oprogramowania', 800, 1.6);
INSERT INTO tenders_by_cpv_division VALUES (38, 'Sprzęt laboratoryjny i naukowy', 794, 1.59);
INSERT INTO tenders_by_cpv_division VALUES (50, 'Usługi napraw i konserwacji', 635, 1.27);
INSERT INTO tenders_by_cpv_division VALUES (72, 'Usługi informatyczne', 483, 0.97);
INSERT INTO tenders_by_cpv_division VALUES (44, 'Materiały budowlane', 480, 0.96);
INSERT INTO tenders_by_cpv_division VALUES (85, 'Usługi zdrowotne i społeczne', 470, 0.94);
INSERT INTO tenders_by_cpv_division VALUES (32, 'Sprzęt elektroniczny i telekomunikacyjny', 465, 0.93);
INSERT INTO tenders_by_cpv_division VALUES (66, 'Usługi finansowe i ubezpieczeniowe', 452, 0.9);
INSERT INTO tenders_by_cpv_division VALUES (42, 'Maszyny przemysłowe', 416, 0.83);
INSERT INTO tenders_by_cpv_division VALUES (77, 'Usługi rolnicze i leśne', 407, 0.81);
INSERT INTO tenders_by_cpv_division VALUES (31, 'Sprzęt elektryczny', 341, 0.68);
INSERT INTO tenders_by_cpv_division VALUES (3, 'Produkty rolne, łowieckie i rybne', 321, 0.64);
INSERT INTO tenders_by_cpv_division VALUES (24, 'Produkty chemiczne', 305, 0.61);
INSERT INTO tenders_by_cpv_division VALUES (37, 'Sprzęt sportowy i rekreacyjny', 216, 0.43);
INSERT INTO tenders_by_cpv_division VALUES (14, 'Górnictwo i minerały', 209, 0.42);
INSERT INTO tenders_by_cpv_division VALUES (18, 'Odzież i obuwie', 201, 0.4);
INSERT INTO tenders_by_cpv_division VALUES (64, 'Usługi pocztowe i telekomunikacyjne', 195, 0.39);
INSERT INTO tenders_by_cpv_division VALUES (98, 'Pozostałe usługi komunalne i osobiste', 181, 0.36);
INSERT INTO tenders_by_cpv_division VALUES (22, 'Drukowane materiały i produkty poligraficzne', 170, 0.34);
INSERT INTO tenders_by_cpv_division VALUES (16, 'Maszyny rolnicze', 160, 0.32);
INSERT INTO tenders_by_cpv_division VALUES (63, 'Usługi spedycji i logistyki', 158, 0.32);
INSERT INTO tenders_by_cpv_division VALUES (92, 'Usługi rekreacyjne i kulturalne', 145, 0.29);
INSERT INTO tenders_by_cpv_division VALUES (43, 'Maszyny górnicze', 134, 0.27);
INSERT INTO tenders_by_cpv_division VALUES (73, 'Usługi badawczo-rozwojowe', 122, 0.24);
INSERT INTO tenders_by_cpv_division VALUES (35, 'Sprzęt bezpieczeństwa i ochrony', 99, 0.2);
INSERT INTO tenders_by_cpv_division VALUES (70, 'Usługi w zakresie nieruchomości', 94, 0.19);
INSERT INTO tenders_by_cpv_division VALUES (19, 'Wyroby skórzane i tekstylne', 70, 0.14);
INSERT INTO tenders_by_cpv_division VALUES (75, 'Usługi administracji publicznej', 55, 0.11);
INSERT INTO tenders_by_cpv_division VALUES (51, 'Usługi instalacyjne', 37, 0.07);
INSERT INTO tenders_by_cpv_division VALUES (65, 'Usługi komunalne (gaz, woda, energia)', 14, 0.03);
INSERT INTO tenders_by_cpv_division VALUES (41, 'Woda i usługi wodne', 11, 0.02);
INSERT INTO tenders_by_cpv_division VALUES (76, 'Usługi związane z przemysłem naftowym', 2, 0.0);


-- =============================================================
-- TABLE 2: tenders_by_province_and_division
-- Number of tenders per province × CPV division
-- One row per (province, division) combination
-- Rebuilt from raw_data; re-run after data updates
-- =============================================================

DROP TABLE IF EXISTS tenders_by_province_and_division;

CREATE TABLE tenders_by_province_and_division (
    province        TEXT    NOT NULL,
    cpv_division    INTEGER NOT NULL,
    division_name   TEXT    NOT NULL,
    tender_count    INTEGER NOT NULL,
    PRIMARY KEY (province, cpv_division)
);

INSERT INTO tenders_by_province_and_division VALUES ('Dolnośląskie', 45, 'Roboty budowlane', 1390);
INSERT INTO tenders_by_province_and_division VALUES ('Dolnośląskie', 33, 'Sprzęt medyczny i farmaceutyczny', 236);
INSERT INTO tenders_by_province_and_division VALUES ('Dolnośląskie', 71, 'Usługi architektoniczne i inżynieryjne', 230);
INSERT INTO tenders_by_province_and_division VALUES ('Dolnośląskie', 30, 'Sprzęt komputerowy i biurowy', 211);
INSERT INTO tenders_by_province_and_division VALUES ('Dolnośląskie', 39, 'Meble i wyposażenie wnętrz', 132);
INSERT INTO tenders_by_province_and_division VALUES ('Dolnośląskie', 15, 'Artykuły spożywcze i napoje', 122);
INSERT INTO tenders_by_province_and_division VALUES ('Dolnośląskie', 55, 'Usługi hotelarskie i restauracyjne', 121);
INSERT INTO tenders_by_province_and_division VALUES ('Dolnośląskie', 34, 'Sprzęt transportowy i pojazdy', 114);
INSERT INTO tenders_by_province_and_division VALUES ('Dolnośląskie', 9, 'Produkty naftowe, paliwa i energia', 107);
INSERT INTO tenders_by_province_and_division VALUES ('Dolnośląskie', 90, 'Usługi środowiskowe i sanitarne', 101);
INSERT INTO tenders_by_province_and_division VALUES ('Dolnośląskie', 60, 'Usługi transportu drogowego', 95);
INSERT INTO tenders_by_province_and_division VALUES ('Dolnośląskie', 38, 'Sprzęt laboratoryjny i naukowy', 61);
INSERT INTO tenders_by_province_and_division VALUES ('Dolnośląskie', 48, 'Pakiety oprogramowania', 60);
INSERT INTO tenders_by_province_and_division VALUES ('Dolnośląskie', 79, 'Usługi biznesowe i doradcze', 58);
INSERT INTO tenders_by_province_and_division VALUES ('Dolnośląskie', 50, 'Usługi napraw i konserwacji', 44);
INSERT INTO tenders_by_province_and_division VALUES ('Dolnośląskie', 66, 'Usługi finansowe i ubezpieczeniowe', 39);
INSERT INTO tenders_by_province_and_division VALUES ('Dolnośląskie', 77, 'Usługi rolnicze i leśne', 35);
INSERT INTO tenders_by_province_and_division VALUES ('Dolnośląskie', 72, 'Usługi informatyczne', 34);
INSERT INTO tenders_by_province_and_division VALUES ('Dolnośląskie', 80, 'Usługi edukacyjne', 33);
INSERT INTO tenders_by_province_and_division VALUES ('Dolnośląskie', 44, 'Materiały budowlane', 33);
INSERT INTO tenders_by_province_and_division VALUES ('Dolnośląskie', 42, 'Maszyny przemysłowe', 31);
INSERT INTO tenders_by_province_and_division VALUES ('Dolnośląskie', 85, 'Usługi zdrowotne i społeczne', 27);
INSERT INTO tenders_by_province_and_division VALUES ('Dolnośląskie', 32, 'Sprzęt elektroniczny i telekomunikacyjny', 26);
INSERT INTO tenders_by_province_and_division VALUES ('Dolnośląskie', 18, 'Odzież i obuwie', 19);
INSERT INTO tenders_by_province_and_division VALUES ('Dolnośląskie', 14, 'Górnictwo i minerały', 18);
INSERT INTO tenders_by_province_and_division VALUES ('Dolnośląskie', 3, 'Produkty rolne, łowieckie i rybne', 17);
INSERT INTO tenders_by_province_and_division VALUES ('Dolnośląskie', 24, 'Produkty chemiczne', 17);
INSERT INTO tenders_by_province_and_division VALUES ('Dolnośląskie', 37, 'Sprzęt sportowy i rekreacyjny', 17);
INSERT INTO tenders_by_province_and_division VALUES ('Dolnośląskie', 31, 'Sprzęt elektryczny', 17);
INSERT INTO tenders_by_province_and_division VALUES ('Dolnośląskie', 64, 'Usługi pocztowe i telekomunikacyjne', 14);
INSERT INTO tenders_by_province_and_division VALUES ('Dolnośląskie', 22, 'Drukowane materiały i produkty poligraficzne', 14);
INSERT INTO tenders_by_province_and_division VALUES ('Dolnośląskie', 98, 'Pozostałe usługi komunalne i osobiste', 14);
INSERT INTO tenders_by_province_and_division VALUES ('Dolnośląskie', 19, 'Wyroby skórzane i tekstylne', 14);
INSERT INTO tenders_by_province_and_division VALUES ('Dolnośląskie', 75, 'Usługi administracji publicznej', 10);
INSERT INTO tenders_by_province_and_division VALUES ('Dolnośląskie', 16, 'Maszyny rolnicze', 9);
INSERT INTO tenders_by_province_and_division VALUES ('Dolnośląskie', 43, 'Maszyny górnicze', 9);
INSERT INTO tenders_by_province_and_division VALUES ('Dolnośląskie', 63, 'Usługi spedycji i logistyki', 5);
INSERT INTO tenders_by_province_and_division VALUES ('Dolnośląskie', 92, 'Usługi rekreacyjne i kulturalne', 5);
INSERT INTO tenders_by_province_and_division VALUES ('Dolnośląskie', 73, 'Usługi badawczo-rozwojowe', 4);
INSERT INTO tenders_by_province_and_division VALUES ('Dolnośląskie', 35, 'Sprzęt bezpieczeństwa i ochrony', 4);
INSERT INTO tenders_by_province_and_division VALUES ('Dolnośląskie', 51, 'Usługi instalacyjne', 3);
INSERT INTO tenders_by_province_and_division VALUES ('Dolnośląskie', 70, 'Usługi w zakresie nieruchomości', 3);
INSERT INTO tenders_by_province_and_division VALUES ('Kujawsko-pomorskie', 45, 'Roboty budowlane', 914);
INSERT INTO tenders_by_province_and_division VALUES ('Kujawsko-pomorskie', 33, 'Sprzęt medyczny i farmaceutyczny', 219);
INSERT INTO tenders_by_province_and_division VALUES ('Kujawsko-pomorskie', 30, 'Sprzęt komputerowy i biurowy', 198);
INSERT INTO tenders_by_province_and_division VALUES ('Kujawsko-pomorskie', 9, 'Produkty naftowe, paliwa i energia', 120);
INSERT INTO tenders_by_province_and_division VALUES ('Kujawsko-pomorskie', 71, 'Usługi architektoniczne i inżynieryjne', 93);
INSERT INTO tenders_by_province_and_division VALUES ('Kujawsko-pomorskie', 34, 'Sprzęt transportowy i pojazdy', 85);
INSERT INTO tenders_by_province_and_division VALUES ('Kujawsko-pomorskie', 39, 'Meble i wyposażenie wnętrz', 81);
INSERT INTO tenders_by_province_and_division VALUES ('Kujawsko-pomorskie', 90, 'Usługi środowiskowe i sanitarne', 62);
INSERT INTO tenders_by_province_and_division VALUES ('Kujawsko-pomorskie', 15, 'Artykuły spożywcze i napoje', 54);
INSERT INTO tenders_by_province_and_division VALUES ('Kujawsko-pomorskie', 66, 'Usługi finansowe i ubezpieczeniowe', 54);
INSERT INTO tenders_by_province_and_division VALUES ('Kujawsko-pomorskie', 80, 'Usługi edukacyjne', 50);
INSERT INTO tenders_by_province_and_division VALUES ('Kujawsko-pomorskie', 60, 'Usługi transportu drogowego', 50);
INSERT INTO tenders_by_province_and_division VALUES ('Kujawsko-pomorskie', 44, 'Materiały budowlane', 44);
INSERT INTO tenders_by_province_and_division VALUES ('Kujawsko-pomorskie', 48, 'Pakiety oprogramowania', 43);
INSERT INTO tenders_by_province_and_division VALUES ('Kujawsko-pomorskie', 79, 'Usługi biznesowe i doradcze', 41);
INSERT INTO tenders_by_province_and_division VALUES ('Kujawsko-pomorskie', 50, 'Usługi napraw i konserwacji', 37);
INSERT INTO tenders_by_province_and_division VALUES ('Kujawsko-pomorskie', 38, 'Sprzęt laboratoryjny i naukowy', 34);
INSERT INTO tenders_by_province_and_division VALUES ('Kujawsko-pomorskie', 42, 'Maszyny przemysłowe', 29);
INSERT INTO tenders_by_province_and_division VALUES ('Kujawsko-pomorskie', 55, 'Usługi hotelarskie i restauracyjne', 27);
INSERT INTO tenders_by_province_and_division VALUES ('Kujawsko-pomorskie', 72, 'Usługi informatyczne', 25);
INSERT INTO tenders_by_province_and_division VALUES ('Kujawsko-pomorskie', 32, 'Sprzęt elektroniczny i telekomunikacyjny', 21);
INSERT INTO tenders_by_province_and_division VALUES ('Kujawsko-pomorskie', 24, 'Produkty chemiczne', 20);
INSERT INTO tenders_by_province_and_division VALUES ('Kujawsko-pomorskie', 3, 'Produkty rolne, łowieckie i rybne', 16);
INSERT INTO tenders_by_province_and_division VALUES ('Kujawsko-pomorskie', 31, 'Sprzęt elektryczny', 15);
INSERT INTO tenders_by_province_and_division VALUES ('Kujawsko-pomorskie', 85, 'Usługi zdrowotne i społeczne', 14);
INSERT INTO tenders_by_province_and_division VALUES ('Kujawsko-pomorskie', 77, 'Usługi rolnicze i leśne', 13);
INSERT INTO tenders_by_province_and_division VALUES ('Kujawsko-pomorskie', 37, 'Sprzęt sportowy i rekreacyjny', 13);
INSERT INTO tenders_by_province_and_division VALUES ('Kujawsko-pomorskie', 14, 'Górnictwo i minerały', 11);
INSERT INTO tenders_by_province_and_division VALUES ('Kujawsko-pomorskie', 64, 'Usługi pocztowe i telekomunikacyjne', 11);
INSERT INTO tenders_by_province_and_division VALUES ('Kujawsko-pomorskie', 35, 'Sprzęt bezpieczeństwa i ochrony', 8);
INSERT INTO tenders_by_province_and_division VALUES ('Kujawsko-pomorskie', 98, 'Pozostałe usługi komunalne i osobiste', 8);
INSERT INTO tenders_by_province_and_division VALUES ('Kujawsko-pomorskie', 43, 'Maszyny górnicze', 7);
INSERT INTO tenders_by_province_and_division VALUES ('Kujawsko-pomorskie', 18, 'Odzież i obuwie', 7);
INSERT INTO tenders_by_province_and_division VALUES ('Kujawsko-pomorskie', 16, 'Maszyny rolnicze', 7);
INSERT INTO tenders_by_province_and_division VALUES ('Kujawsko-pomorskie', 63, 'Usługi spedycji i logistyki', 7);
INSERT INTO tenders_by_province_and_division VALUES ('Kujawsko-pomorskie', 22, 'Drukowane materiały i produkty poligraficzne', 6);
INSERT INTO tenders_by_province_and_division VALUES ('Kujawsko-pomorskie', 92, 'Usługi rekreacyjne i kulturalne', 4);
INSERT INTO tenders_by_province_and_division VALUES ('Kujawsko-pomorskie', 70, 'Usługi w zakresie nieruchomości', 4);
INSERT INTO tenders_by_province_and_division VALUES ('Kujawsko-pomorskie', 19, 'Wyroby skórzane i tekstylne', 3);
INSERT INTO tenders_by_province_and_division VALUES ('Kujawsko-pomorskie', 73, 'Usługi badawczo-rozwojowe', 2);
INSERT INTO tenders_by_province_and_division VALUES ('Kujawsko-pomorskie', 41, 'Woda i usługi wodne', 2);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 45, 'Roboty budowlane', 1197);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 33, 'Sprzęt medyczny i farmaceutyczny', 217);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 30, 'Sprzęt komputerowy i biurowy', 197);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 80, 'Usługi edukacyjne', 182);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 71, 'Usługi architektoniczne i inżynieryjne', 129);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 9, 'Produkty naftowe, paliwa i energia', 115);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 34, 'Sprzęt transportowy i pojazdy', 100);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 39, 'Meble i wyposażenie wnętrz', 95);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 15, 'Artykuły spożywcze i napoje', 91);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 60, 'Usługi transportu drogowego', 82);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 90, 'Usługi środowiskowe i sanitarne', 76);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 55, 'Usługi hotelarskie i restauracyjne', 65);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 48, 'Pakiety oprogramowania', 52);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 79, 'Usługi biznesowe i doradcze', 50);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 38, 'Sprzęt laboratoryjny i naukowy', 46);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 44, 'Materiały budowlane', 31);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 66, 'Usługi finansowe i ubezpieczeniowe', 30);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 72, 'Usługi informatyczne', 27);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 32, 'Sprzęt elektroniczny i telekomunikacyjny', 26);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 24, 'Produkty chemiczne', 24);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 50, 'Usługi napraw i konserwacji', 24);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 31, 'Sprzęt elektryczny', 23);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 85, 'Usługi zdrowotne i społeczne', 20);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 77, 'Usługi rolnicze i leśne', 20);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 42, 'Maszyny przemysłowe', 20);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 3, 'Produkty rolne, łowieckie i rybne', 19);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 14, 'Górnictwo i minerały', 19);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 22, 'Drukowane materiały i produkty poligraficzne', 16);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 37, 'Sprzęt sportowy i rekreacyjny', 11);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 18, 'Odzież i obuwie', 10);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 70, 'Usługi w zakresie nieruchomości', 9);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 73, 'Usługi badawczo-rozwojowe', 9);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 16, 'Maszyny rolnicze', 8);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 98, 'Pozostałe usługi komunalne i osobiste', 7);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 64, 'Usługi pocztowe i telekomunikacyjne', 6);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 35, 'Sprzęt bezpieczeństwa i ochrony', 6);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 43, 'Maszyny górnicze', 5);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 19, 'Wyroby skórzane i tekstylne', 4);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 92, 'Usługi rekreacyjne i kulturalne', 4);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 63, 'Usługi spedycji i logistyki', 4);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 75, 'Usługi administracji publicznej', 1);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 51, 'Usługi instalacyjne', 1);
INSERT INTO tenders_by_province_and_division VALUES ('Lubelskie', 41, 'Woda i usługi wodne', 1);
INSERT INTO tenders_by_province_and_division VALUES ('Lubuskie', 45, 'Roboty budowlane', 626);
INSERT INTO tenders_by_province_and_division VALUES ('Lubuskie', 30, 'Sprzęt komputerowy i biurowy', 93);
INSERT INTO tenders_by_province_and_division VALUES ('Lubuskie', 71, 'Usługi architektoniczne i inżynieryjne', 89);
INSERT INTO tenders_by_province_and_division VALUES ('Lubuskie', 33, 'Sprzęt medyczny i farmaceutyczny', 77);
INSERT INTO tenders_by_province_and_division VALUES ('Lubuskie', 34, 'Sprzęt transportowy i pojazdy', 48);
INSERT INTO tenders_by_province_and_division VALUES ('Lubuskie', 39, 'Meble i wyposażenie wnętrz', 37);
INSERT INTO tenders_by_province_and_division VALUES ('Lubuskie', 90, 'Usługi środowiskowe i sanitarne', 37);
INSERT INTO tenders_by_province_and_division VALUES ('Lubuskie', 9, 'Produkty naftowe, paliwa i energia', 35);
INSERT INTO tenders_by_province_and_division VALUES ('Lubuskie', 60, 'Usługi transportu drogowego', 32);
INSERT INTO tenders_by_province_and_division VALUES ('Lubuskie', 79, 'Usługi biznesowe i doradcze', 28);
INSERT INTO tenders_by_province_and_division VALUES ('Lubuskie', 80, 'Usługi edukacyjne', 25);
INSERT INTO tenders_by_province_and_division VALUES ('Lubuskie', 55, 'Usługi hotelarskie i restauracyjne', 23);
INSERT INTO tenders_by_province_and_division VALUES ('Lubuskie', 85, 'Usługi zdrowotne i społeczne', 17);
INSERT INTO tenders_by_province_and_division VALUES ('Lubuskie', 15, 'Artykuły spożywcze i napoje', 13);
INSERT INTO tenders_by_province_and_division VALUES ('Lubuskie', 48, 'Pakiety oprogramowania', 10);
INSERT INTO tenders_by_province_and_division VALUES ('Lubuskie', 16, 'Maszyny rolnicze', 9);
INSERT INTO tenders_by_province_and_division VALUES ('Lubuskie', 37, 'Sprzęt sportowy i rekreacyjny', 8);
INSERT INTO tenders_by_province_and_division VALUES ('Lubuskie', 66, 'Usługi finansowe i ubezpieczeniowe', 8);
INSERT INTO tenders_by_province_and_division VALUES ('Lubuskie', 32, 'Sprzęt elektroniczny i telekomunikacyjny', 7);
INSERT INTO tenders_by_province_and_division VALUES ('Lubuskie', 72, 'Usługi informatyczne', 7);
INSERT INTO tenders_by_province_and_division VALUES ('Lubuskie', 42, 'Maszyny przemysłowe', 6);
INSERT INTO tenders_by_province_and_division VALUES ('Lubuskie', 51, 'Usługi instalacyjne', 5);
INSERT INTO tenders_by_province_and_division VALUES ('Lubuskie', 3, 'Produkty rolne, łowieckie i rybne', 5);
INSERT INTO tenders_by_province_and_division VALUES ('Lubuskie', 14, 'Górnictwo i minerały', 5);
INSERT INTO tenders_by_province_and_division VALUES ('Lubuskie', 77, 'Usługi rolnicze i leśne', 5);
INSERT INTO tenders_by_province_and_division VALUES ('Lubuskie', 38, 'Sprzęt laboratoryjny i naukowy', 5);
INSERT INTO tenders_by_province_and_division VALUES ('Lubuskie', 43, 'Maszyny górnicze', 4);
INSERT INTO tenders_by_province_and_division VALUES ('Lubuskie', 44, 'Materiały budowlane', 4);
INSERT INTO tenders_by_province_and_division VALUES ('Lubuskie', 73, 'Usługi badawczo-rozwojowe', 3);
INSERT INTO tenders_by_province_and_division VALUES ('Lubuskie', 50, 'Usługi napraw i konserwacji', 3);
INSERT INTO tenders_by_province_and_division VALUES ('Lubuskie', 35, 'Sprzęt bezpieczeństwa i ochrony', 3);
INSERT INTO tenders_by_province_and_division VALUES ('Lubuskie', 24, 'Produkty chemiczne', 3);
INSERT INTO tenders_by_province_and_division VALUES ('Lubuskie', 31, 'Sprzęt elektryczny', 3);
INSERT INTO tenders_by_province_and_division VALUES ('Lubuskie', 22, 'Drukowane materiały i produkty poligraficzne', 3);
INSERT INTO tenders_by_province_and_division VALUES ('Lubuskie', 75, 'Usługi administracji publicznej', 3);
INSERT INTO tenders_by_province_and_division VALUES ('Lubuskie', 64, 'Usługi pocztowe i telekomunikacyjne', 3);
INSERT INTO tenders_by_province_and_division VALUES ('Lubuskie', 92, 'Usługi rekreacyjne i kulturalne', 2);
INSERT INTO tenders_by_province_and_division VALUES ('Lubuskie', 19, 'Wyroby skórzane i tekstylne', 2);
INSERT INTO tenders_by_province_and_division VALUES ('Lubuskie', 63, 'Usługi spedycji i logistyki', 2);
INSERT INTO tenders_by_province_and_division VALUES ('Lubuskie', 70, 'Usługi w zakresie nieruchomości', 1);
INSERT INTO tenders_by_province_and_division VALUES ('Lubuskie', 18, 'Odzież i obuwie', 1);
INSERT INTO tenders_by_province_and_division VALUES ('Lubuskie', 65, 'Usługi komunalne (gaz, woda, energia)', 1);
INSERT INTO tenders_by_province_and_division VALUES ('Łódzkie', 45, 'Roboty budowlane', 1329);
INSERT INTO tenders_by_province_and_division VALUES ('Łódzkie', 71, 'Usługi architektoniczne i inżynieryjne', 172);
INSERT INTO tenders_by_province_and_division VALUES ('Łódzkie', 33, 'Sprzęt medyczny i farmaceutyczny', 170);
INSERT INTO tenders_by_province_and_division VALUES ('Łódzkie', 30, 'Sprzęt komputerowy i biurowy', 156);
INSERT INTO tenders_by_province_and_division VALUES ('Łódzkie', 34, 'Sprzęt transportowy i pojazdy', 133);
INSERT INTO tenders_by_province_and_division VALUES ('Łódzkie', 9, 'Produkty naftowe, paliwa i energia', 128);
INSERT INTO tenders_by_province_and_division VALUES ('Łódzkie', 55, 'Usługi hotelarskie i restauracyjne', 81);
INSERT INTO tenders_by_province_and_division VALUES ('Łódzkie', 90, 'Usługi środowiskowe i sanitarne', 74);
INSERT INTO tenders_by_province_and_division VALUES ('Łódzkie', 79, 'Usługi biznesowe i doradcze', 67);
INSERT INTO tenders_by_province_and_division VALUES ('Łódzkie', 39, 'Meble i wyposażenie wnętrz', 66);
INSERT INTO tenders_by_province_and_division VALUES ('Łódzkie', 60, 'Usługi transportu drogowego', 65);
INSERT INTO tenders_by_province_and_division VALUES ('Łódzkie', 80, 'Usługi edukacyjne', 64);
INSERT INTO tenders_by_province_and_division VALUES ('Łódzkie', 48, 'Pakiety oprogramowania', 46);
INSERT INTO tenders_by_province_and_division VALUES ('Łódzkie', 50, 'Usługi napraw i konserwacji', 43);
INSERT INTO tenders_by_province_and_division VALUES ('Łódzkie', 15, 'Artykuły spożywcze i napoje', 39);
INSERT INTO tenders_by_province_and_division VALUES ('Łódzkie', 38, 'Sprzęt laboratoryjny i naukowy', 38);
INSERT INTO tenders_by_province_and_division VALUES ('Łódzkie', 72, 'Usługi informatyczne', 32);
INSERT INTO tenders_by_province_and_division VALUES ('Łódzkie', 44, 'Materiały budowlane', 28);
INSERT INTO tenders_by_province_and_division VALUES ('Łódzkie', 66, 'Usługi finansowe i ubezpieczeniowe', 26);
INSERT INTO tenders_by_province_and_division VALUES ('Łódzkie', 16, 'Maszyny rolnicze', 23);
INSERT INTO tenders_by_province_and_division VALUES ('Łódzkie', 85, 'Usługi zdrowotne i społeczne', 22);
INSERT INTO tenders_by_province_and_division VALUES ('Łódzkie', 42, 'Maszyny przemysłowe', 18);
INSERT INTO tenders_by_province_and_division VALUES ('Łódzkie', 32, 'Sprzęt elektroniczny i telekomunikacyjny', 17);
INSERT INTO tenders_by_province_and_division VALUES ('Łódzkie', 14, 'Górnictwo i minerały', 15);
INSERT INTO tenders_by_province_and_division VALUES ('Łódzkie', 24, 'Produkty chemiczne', 13);
INSERT INTO tenders_by_province_and_division VALUES ('Łódzkie', 77, 'Usługi rolnicze i leśne', 13);
INSERT INTO tenders_by_province_and_division VALUES ('Łódzkie', 37, 'Sprzęt sportowy i rekreacyjny', 13);
INSERT INTO tenders_by_province_and_division VALUES ('Łódzkie', 31, 'Sprzęt elektryczny', 12);
INSERT INTO tenders_by_province_and_division VALUES ('Łódzkie', 73, 'Usługi badawczo-rozwojowe', 11);
INSERT INTO tenders_by_province_and_division VALUES ('Łódzkie', 3, 'Produkty rolne, łowieckie i rybne', 11);
INSERT INTO tenders_by_province_and_division VALUES ('Łódzkie', 98, 'Pozostałe usługi komunalne i osobiste', 10);
INSERT INTO tenders_by_province_and_division VALUES ('Łódzkie', 43, 'Maszyny górnicze', 8);
INSERT INTO tenders_by_province_and_division VALUES ('Łódzkie', 63, 'Usługi spedycji i logistyki', 8);
INSERT INTO tenders_by_province_and_division VALUES ('Łódzkie', 18, 'Odzież i obuwie', 8);
INSERT INTO tenders_by_province_and_division VALUES ('Łódzkie', 75, 'Usługi administracji publicznej', 7);
INSERT INTO tenders_by_province_and_division VALUES ('Łódzkie', 22, 'Drukowane materiały i produkty poligraficzne', 6);
INSERT INTO tenders_by_province_and_division VALUES ('Łódzkie', 92, 'Usługi rekreacyjne i kulturalne', 5);
INSERT INTO tenders_by_province_and_division VALUES ('Łódzkie', 70, 'Usługi w zakresie nieruchomości', 5);
INSERT INTO tenders_by_province_and_division VALUES ('Łódzkie', 64, 'Usługi pocztowe i telekomunikacyjne', 4);
INSERT INTO tenders_by_province_and_division VALUES ('Łódzkie', 19, 'Wyroby skórzane i tekstylne', 4);
INSERT INTO tenders_by_province_and_division VALUES ('Łódzkie', 35, 'Sprzęt bezpieczeństwa i ochrony', 1);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 45, 'Roboty budowlane', 1713);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 33, 'Sprzęt medyczny i farmaceutyczny', 400);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 71, 'Usługi architektoniczne i inżynieryjne', 322);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 30, 'Sprzęt komputerowy i biurowy', 197);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 34, 'Sprzęt transportowy i pojazdy', 167);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 60, 'Usługi transportu drogowego', 157);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 39, 'Meble i wyposażenie wnętrz', 140);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 15, 'Artykuły spożywcze i napoje', 135);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 90, 'Usługi środowiskowe i sanitarne', 128);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 80, 'Usługi edukacyjne', 117);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 79, 'Usługi biznesowe i doradcze', 113);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 9, 'Produkty naftowe, paliwa i energia', 95);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 55, 'Usługi hotelarskie i restauracyjne', 88);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 38, 'Sprzęt laboratoryjny i naukowy', 88);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 48, 'Pakiety oprogramowania', 86);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 42, 'Maszyny przemysłowe', 61);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 50, 'Usługi napraw i konserwacji', 50);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 72, 'Usługi informatyczne', 46);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 85, 'Usługi zdrowotne i społeczne', 42);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 32, 'Sprzęt elektroniczny i telekomunikacyjny', 42);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 44, 'Materiały budowlane', 34);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 3, 'Produkty rolne, łowieckie i rybne', 34);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 31, 'Sprzęt elektryczny', 30);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 66, 'Usługi finansowe i ubezpieczeniowe', 28);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 92, 'Usługi rekreacyjne i kulturalne', 27);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 77, 'Usługi rolnicze i leśne', 22);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 18, 'Odzież i obuwie', 21);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 63, 'Usługi spedycji i logistyki', 21);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 24, 'Produkty chemiczne', 21);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 64, 'Usługi pocztowe i telekomunikacyjne', 18);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 98, 'Pozostałe usługi komunalne i osobiste', 17);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 37, 'Sprzęt sportowy i rekreacyjny', 15);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 35, 'Sprzęt bezpieczeństwa i ochrony', 14);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 14, 'Górnictwo i minerały', 14);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 16, 'Maszyny rolnicze', 11);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 70, 'Usługi w zakresie nieruchomości', 8);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 73, 'Usługi badawczo-rozwojowe', 8);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 43, 'Maszyny górnicze', 7);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 75, 'Usługi administracji publicznej', 6);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 22, 'Drukowane materiały i produkty poligraficzne', 6);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 51, 'Usługi instalacyjne', 5);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 19, 'Wyroby skórzane i tekstylne', 4);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 76, 'Usługi związane z przemysłem naftowym', 1);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 41, 'Woda i usługi wodne', 1);
INSERT INTO tenders_by_province_and_division VALUES ('Małopolskie', 65, 'Usługi komunalne (gaz, woda, energia)', 1);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 45, 'Roboty budowlane', 3158);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 71, 'Usługi architektoniczne i inżynieryjne', 568);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 33, 'Sprzęt medyczny i farmaceutyczny', 547);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 30, 'Sprzęt komputerowy i biurowy', 412);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 79, 'Usługi biznesowe i doradcze', 375);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 34, 'Sprzęt transportowy i pojazdy', 293);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 9, 'Produkty naftowe, paliwa i energia', 280);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 55, 'Usługi hotelarskie i restauracyjne', 251);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 90, 'Usługi środowiskowe i sanitarne', 237);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 39, 'Meble i wyposażenie wnętrz', 233);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 38, 'Sprzęt laboratoryjny i naukowy', 199);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 48, 'Pakiety oprogramowania', 198);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 60, 'Usługi transportu drogowego', 189);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 15, 'Artykuły spożywcze i napoje', 175);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 80, 'Usługi edukacyjne', 170);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 50, 'Usługi napraw i konserwacji', 170);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 72, 'Usługi informatyczne', 158);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 32, 'Sprzęt elektroniczny i telekomunikacyjny', 117);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 85, 'Usługi zdrowotne i społeczne', 115);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 31, 'Sprzęt elektryczny', 98);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 77, 'Usługi rolnicze i leśne', 75);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 66, 'Usługi finansowe i ubezpieczeniowe', 75);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 44, 'Materiały budowlane', 74);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 64, 'Usługi pocztowe i telekomunikacyjne', 65);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 42, 'Maszyny przemysłowe', 64);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 92, 'Usługi rekreacyjne i kulturalne', 62);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 22, 'Drukowane materiały i produkty poligraficzne', 52);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 18, 'Odzież i obuwie', 46);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 24, 'Produkty chemiczne', 44);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 73, 'Usługi badawczo-rozwojowe', 33);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 37, 'Sprzęt sportowy i rekreacyjny', 30);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 3, 'Produkty rolne, łowieckie i rybne', 30);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 63, 'Usługi spedycji i logistyki', 29);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 14, 'Górnictwo i minerały', 27);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 35, 'Sprzęt bezpieczeństwa i ochrony', 26);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 98, 'Pozostałe usługi komunalne i osobiste', 24);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 43, 'Maszyny górnicze', 17);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 16, 'Maszyny rolnicze', 16);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 70, 'Usługi w zakresie nieruchomości', 14);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 19, 'Wyroby skórzane i tekstylne', 12);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 51, 'Usługi instalacyjne', 12);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 75, 'Usługi administracji publicznej', 11);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 41, 'Woda i usługi wodne', 4);
INSERT INTO tenders_by_province_and_division VALUES ('Mazowieckie', 65, 'Usługi komunalne (gaz, woda, energia)', 3);
INSERT INTO tenders_by_province_and_division VALUES ('Opolskie', 45, 'Roboty budowlane', 541);
INSERT INTO tenders_by_province_and_division VALUES ('Opolskie', 33, 'Sprzęt medyczny i farmaceutyczny', 117);
INSERT INTO tenders_by_province_and_division VALUES ('Opolskie', 30, 'Sprzęt komputerowy i biurowy', 81);
INSERT INTO tenders_by_province_and_division VALUES ('Opolskie', 71, 'Usługi architektoniczne i inżynieryjne', 60);
INSERT INTO tenders_by_province_and_division VALUES ('Opolskie', 9, 'Produkty naftowe, paliwa i energia', 50);
INSERT INTO tenders_by_province_and_division VALUES ('Opolskie', 34, 'Sprzęt transportowy i pojazdy', 47);
INSERT INTO tenders_by_province_and_division VALUES ('Opolskie', 15, 'Artykuły spożywcze i napoje', 46);
INSERT INTO tenders_by_province_and_division VALUES ('Opolskie', 39, 'Meble i wyposażenie wnętrz', 35);
INSERT INTO tenders_by_province_and_division VALUES ('Opolskie', 80, 'Usługi edukacyjne', 33);
INSERT INTO tenders_by_province_and_division VALUES ('Opolskie', 79, 'Usługi biznesowe i doradcze', 29);
INSERT INTO tenders_by_province_and_division VALUES ('Opolskie', 90, 'Usługi środowiskowe i sanitarne', 28);
INSERT INTO tenders_by_province_and_division VALUES ('Opolskie', 60, 'Usługi transportu drogowego', 27);
INSERT INTO tenders_by_province_and_division VALUES ('Opolskie', 77, 'Usługi rolnicze i leśne', 23);
INSERT INTO tenders_by_province_and_division VALUES ('Opolskie', 48, 'Pakiety oprogramowania', 17);
INSERT INTO tenders_by_province_and_division VALUES ('Opolskie', 63, 'Usługi spedycji i logistyki', 16);
INSERT INTO tenders_by_province_and_division VALUES ('Opolskie', 32, 'Sprzęt elektroniczny i telekomunikacyjny', 16);
INSERT INTO tenders_by_province_and_division VALUES ('Opolskie', 55, 'Usługi hotelarskie i restauracyjne', 15);
INSERT INTO tenders_by_province_and_division VALUES ('Opolskie', 44, 'Materiały budowlane', 15);
INSERT INTO tenders_by_province_and_division VALUES ('Opolskie', 85, 'Usługi zdrowotne i społeczne', 13);
INSERT INTO tenders_by_province_and_division VALUES ('Opolskie', 98, 'Pozostałe usługi komunalne i osobiste', 11);
INSERT INTO tenders_by_province_and_division VALUES ('Opolskie', 72, 'Usługi informatyczne', 11);
INSERT INTO tenders_by_province_and_division VALUES ('Opolskie', 38, 'Sprzęt laboratoryjny i naukowy', 10);
INSERT INTO tenders_by_province_and_division VALUES ('Opolskie', 66, 'Usługi finansowe i ubezpieczeniowe', 10);
INSERT INTO tenders_by_province_and_division VALUES ('Opolskie', 50, 'Usługi napraw i konserwacji', 9);
INSERT INTO tenders_by_province_and_division VALUES ('Opolskie', 42, 'Maszyny przemysłowe', 9);
INSERT INTO tenders_by_province_and_division VALUES ('Opolskie', 3, 'Produkty rolne, łowieckie i rybne', 8);
INSERT INTO tenders_by_province_and_division VALUES ('Opolskie', 37, 'Sprzęt sportowy i rekreacyjny', 5);
INSERT INTO tenders_by_province_and_division VALUES ('Opolskie', 14, 'Górnictwo i minerały', 4);
INSERT INTO tenders_by_province_and_division VALUES ('Opolskie', 22, 'Drukowane materiały i produkty poligraficzne', 4);
INSERT INTO tenders_by_province_and_division VALUES ('Opolskie', 64, 'Usługi pocztowe i telekomunikacyjne', 4);
INSERT INTO tenders_by_province_and_division VALUES ('Opolskie', 18, 'Odzież i obuwie', 3);
INSERT INTO tenders_by_province_and_division VALUES ('Opolskie', 92, 'Usługi rekreacyjne i kulturalne', 3);
INSERT INTO tenders_by_province_and_division VALUES ('Opolskie', 31, 'Sprzęt elektryczny', 3);
INSERT INTO tenders_by_province_and_division VALUES ('Opolskie', 24, 'Produkty chemiczne', 3);
INSERT INTO tenders_by_province_and_division VALUES ('Opolskie', 19, 'Wyroby skórzane i tekstylne', 2);
INSERT INTO tenders_by_province_and_division VALUES ('Opolskie', 16, 'Maszyny rolnicze', 2);
INSERT INTO tenders_by_province_and_division VALUES ('Opolskie', 43, 'Maszyny górnicze', 2);
INSERT INTO tenders_by_province_and_division VALUES ('Opolskie', 65, 'Usługi komunalne (gaz, woda, energia)', 2);
INSERT INTO tenders_by_province_and_division VALUES ('Opolskie', 75, 'Usługi administracji publicznej', 1);
INSERT INTO tenders_by_province_and_division VALUES ('Podkarpackie', 45, 'Roboty budowlane', 1253);
INSERT INTO tenders_by_province_and_division VALUES ('Podkarpackie', 71, 'Usługi architektoniczne i inżynieryjne', 204);
INSERT INTO tenders_by_province_and_division VALUES ('Podkarpackie', 33, 'Sprzęt medyczny i farmaceutyczny', 196);
INSERT INTO tenders_by_province_and_division VALUES ('Podkarpackie', 30, 'Sprzęt komputerowy i biurowy', 184);
INSERT INTO tenders_by_province_and_division VALUES ('Podkarpackie', 15, 'Artykuły spożywcze i napoje', 134);
INSERT INTO tenders_by_province_and_division VALUES ('Podkarpackie', 34, 'Sprzęt transportowy i pojazdy', 108);
INSERT INTO tenders_by_province_and_division VALUES ('Podkarpackie', 90, 'Usługi środowiskowe i sanitarne', 83);
INSERT INTO tenders_by_province_and_division VALUES ('Podkarpackie', 39, 'Meble i wyposażenie wnętrz', 74);
INSERT INTO tenders_by_province_and_division VALUES ('Podkarpackie', 9, 'Produkty naftowe, paliwa i energia', 67);
INSERT INTO tenders_by_province_and_division VALUES ('Podkarpackie', 60, 'Usługi transportu drogowego', 59);
INSERT INTO tenders_by_province_and_division VALUES ('Podkarpackie', 55, 'Usługi hotelarskie i restauracyjne', 46);
INSERT INTO tenders_by_province_and_division VALUES ('Podkarpackie', 48, 'Pakiety oprogramowania', 43);
INSERT INTO tenders_by_province_and_division VALUES ('Podkarpackie', 38, 'Sprzęt laboratoryjny i naukowy', 42);
INSERT INTO tenders_by_province_and_division VALUES ('Podkarpackie', 79, 'Usługi biznesowe i doradcze', 31);
INSERT INTO tenders_by_province_and_division VALUES ('Podkarpackie', 80, 'Usługi edukacyjne', 28);
INSERT INTO tenders_by_province_and_division VALUES ('Podkarpackie', 32, 'Sprzęt elektroniczny i telekomunikacyjny', 28);
INSERT INTO tenders_by_province_and_division VALUES ('Podkarpackie', 50, 'Usługi napraw i konserwacji', 26);
INSERT INTO tenders_by_province_and_division VALUES ('Podkarpackie', 3, 'Produkty rolne, łowieckie i rybne', 25);
INSERT INTO tenders_by_province_and_division VALUES ('Podkarpackie', 85, 'Usługi zdrowotne i społeczne', 22);
INSERT INTO tenders_by_province_and_division VALUES ('Podkarpackie', 42, 'Maszyny przemysłowe', 20);
INSERT INTO tenders_by_province_and_division VALUES ('Podkarpackie', 44, 'Materiały budowlane', 19);
INSERT INTO tenders_by_province_and_division VALUES ('Podkarpackie', 66, 'Usługi finansowe i ubezpieczeniowe', 18);
INSERT INTO tenders_by_province_and_division VALUES ('Podkarpackie', 77, 'Usługi rolnicze i leśne', 16);
INSERT INTO tenders_by_province_and_division VALUES ('Podkarpackie', 31, 'Sprzęt elektryczny', 16);
INSERT INTO tenders_by_province_and_division VALUES ('Podkarpackie', 72, 'Usługi informatyczne', 15);
INSERT INTO tenders_by_province_and_division VALUES ('Podkarpackie', 14, 'Górnictwo i minerały', 14);
INSERT INTO tenders_by_province_and_division VALUES ('Podkarpackie', 24, 'Produkty chemiczne', 13);
INSERT INTO tenders_by_province_and_division VALUES ('Podkarpackie', 18, 'Odzież i obuwie', 13);
INSERT INTO tenders_by_province_and_division VALUES ('Podkarpackie', 16, 'Maszyny rolnicze', 12);
INSERT INTO tenders_by_province_and_division VALUES ('Podkarpackie', 37, 'Sprzęt sportowy i rekreacyjny', 11);
INSERT INTO tenders_by_province_and_division VALUES ('Podkarpackie', 43, 'Maszyny górnicze', 10);
INSERT INTO tenders_by_province_and_division VALUES ('Podkarpackie', 70, 'Usługi w zakresie nieruchomości', 6);
INSERT INTO tenders_by_province_and_division VALUES ('Podkarpackie', 64, 'Usługi pocztowe i telekomunikacyjne', 6);
INSERT INTO tenders_by_province_and_division VALUES ('Podkarpackie', 35, 'Sprzęt bezpieczeństwa i ochrony', 5);
INSERT INTO tenders_by_province_and_division VALUES ('Podkarpackie', 98, 'Pozostałe usługi komunalne i osobiste', 5);
INSERT INTO tenders_by_province_and_division VALUES ('Podkarpackie', 73, 'Usługi badawczo-rozwojowe', 4);
INSERT INTO tenders_by_province_and_division VALUES ('Podkarpackie', 22, 'Drukowane materiały i produkty poligraficzne', 4);
INSERT INTO tenders_by_province_and_division VALUES ('Podkarpackie', 19, 'Wyroby skórzane i tekstylne', 3);
INSERT INTO tenders_by_province_and_division VALUES ('Podkarpackie', 75, 'Usługi administracji publicznej', 3);
INSERT INTO tenders_by_province_and_division VALUES ('Podkarpackie', 63, 'Usługi spedycji i logistyki', 3);
INSERT INTO tenders_by_province_and_division VALUES ('Podkarpackie', 92, 'Usługi rekreacyjne i kulturalne', 1);
INSERT INTO tenders_by_province_and_division VALUES ('Podkarpackie', 41, 'Woda i usługi wodne', 1);
INSERT INTO tenders_by_province_and_division VALUES ('Podlaskie', 45, 'Roboty budowlane', 673);
INSERT INTO tenders_by_province_and_division VALUES ('Podlaskie', 33, 'Sprzęt medyczny i farmaceutyczny', 123);
INSERT INTO tenders_by_province_and_division VALUES ('Podlaskie', 71, 'Usługi architektoniczne i inżynieryjne', 118);
INSERT INTO tenders_by_province_and_division VALUES ('Podlaskie', 30, 'Sprzęt komputerowy i biurowy', 111);
INSERT INTO tenders_by_province_and_division VALUES ('Podlaskie', 34, 'Sprzęt transportowy i pojazdy', 71);
INSERT INTO tenders_by_province_and_division VALUES ('Podlaskie', 9, 'Produkty naftowe, paliwa i energia', 61);
INSERT INTO tenders_by_province_and_division VALUES ('Podlaskie', 80, 'Usługi edukacyjne', 61);
INSERT INTO tenders_by_province_and_division VALUES ('Podlaskie', 90, 'Usługi środowiskowe i sanitarne', 58);
INSERT INTO tenders_by_province_and_division VALUES ('Podlaskie', 39, 'Meble i wyposażenie wnętrz', 55);
INSERT INTO tenders_by_province_and_division VALUES ('Podlaskie', 15, 'Artykuły spożywcze i napoje', 49);
INSERT INTO tenders_by_province_and_division VALUES ('Podlaskie', 48, 'Pakiety oprogramowania', 26);
INSERT INTO tenders_by_province_and_division VALUES ('Podlaskie', 60, 'Usługi transportu drogowego', 24);
INSERT INTO tenders_by_province_and_division VALUES ('Podlaskie', 55, 'Usługi hotelarskie i restauracyjne', 24);
INSERT INTO tenders_by_province_and_division VALUES ('Podlaskie', 38, 'Sprzęt laboratoryjny i naukowy', 24);
INSERT INTO tenders_by_province_and_division VALUES ('Podlaskie', 32, 'Sprzęt elektroniczny i telekomunikacyjny', 23);
INSERT INTO tenders_by_province_and_division VALUES ('Podlaskie', 44, 'Materiały budowlane', 23);
INSERT INTO tenders_by_province_and_division VALUES ('Podlaskie', 79, 'Usługi biznesowe i doradcze', 20);
INSERT INTO tenders_by_province_and_division VALUES ('Podlaskie', 50, 'Usługi napraw i konserwacji', 16);
INSERT INTO tenders_by_province_and_division VALUES ('Podlaskie', 66, 'Usługi finansowe i ubezpieczeniowe', 16);
INSERT INTO tenders_by_province_and_division VALUES ('Podlaskie', 43, 'Maszyny górnicze', 14);
INSERT INTO tenders_by_province_and_division VALUES ('Podlaskie', 77, 'Usługi rolnicze i leśne', 14);
INSERT INTO tenders_by_province_and_division VALUES ('Podlaskie', 31, 'Sprzęt elektryczny', 14);
INSERT INTO tenders_by_province_and_division VALUES ('Podlaskie', 42, 'Maszyny przemysłowe', 14);
INSERT INTO tenders_by_province_and_division VALUES ('Podlaskie', 14, 'Górnictwo i minerały', 13);
INSERT INTO tenders_by_province_and_division VALUES ('Podlaskie', 24, 'Produkty chemiczne', 9);
INSERT INTO tenders_by_province_and_division VALUES ('Podlaskie', 72, 'Usługi informatyczne', 9);
INSERT INTO tenders_by_province_and_division VALUES ('Podlaskie', 3, 'Produkty rolne, łowieckie i rybne', 8);
INSERT INTO tenders_by_province_and_division VALUES ('Podlaskie', 85, 'Usługi zdrowotne i społeczne', 8);
INSERT INTO tenders_by_province_and_division VALUES ('Podlaskie', 18, 'Odzież i obuwie', 7);
INSERT INTO tenders_by_province_and_division VALUES ('Podlaskie', 16, 'Maszyny rolnicze', 7);
INSERT INTO tenders_by_province_and_division VALUES ('Podlaskie', 37, 'Sprzęt sportowy i rekreacyjny', 6);
INSERT INTO tenders_by_province_and_division VALUES ('Podlaskie', 63, 'Usługi spedycji i logistyki', 6);
INSERT INTO tenders_by_province_and_division VALUES ('Podlaskie', 70, 'Usługi w zakresie nieruchomości', 5);
INSERT INTO tenders_by_province_and_division VALUES ('Podlaskie', 73, 'Usługi badawczo-rozwojowe', 5);
INSERT INTO tenders_by_province_and_division VALUES ('Podlaskie', 92, 'Usługi rekreacyjne i kulturalne', 5);
INSERT INTO tenders_by_province_and_division VALUES ('Podlaskie', 98, 'Pozostałe usługi komunalne i osobiste', 4);
INSERT INTO tenders_by_province_and_division VALUES ('Podlaskie', 64, 'Usługi pocztowe i telekomunikacyjne', 4);
INSERT INTO tenders_by_province_and_division VALUES ('Podlaskie', 35, 'Sprzęt bezpieczeństwa i ochrony', 2);
INSERT INTO tenders_by_province_and_division VALUES ('Podlaskie', 19, 'Wyroby skórzane i tekstylne', 2);
INSERT INTO tenders_by_province_and_division VALUES ('Podlaskie', 22, 'Drukowane materiały i produkty poligraficzne', 2);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 45, 'Roboty budowlane', 1079);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 71, 'Usługi architektoniczne i inżynieryjne', 221);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 30, 'Sprzęt komputerowy i biurowy', 157);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 33, 'Sprzęt medyczny i farmaceutyczny', 139);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 80, 'Usługi edukacyjne', 123);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 15, 'Artykuły spożywcze i napoje', 94);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 34, 'Sprzęt transportowy i pojazdy', 85);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 39, 'Meble i wyposażenie wnętrz', 83);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 9, 'Produkty naftowe, paliwa i energia', 76);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 90, 'Usługi środowiskowe i sanitarne', 65);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 38, 'Sprzęt laboratoryjny i naukowy', 65);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 55, 'Usługi hotelarskie i restauracyjne', 61);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 79, 'Usługi biznesowe i doradcze', 58);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 60, 'Usługi transportu drogowego', 56);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 77, 'Usługi rolnicze i leśne', 40);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 48, 'Pakiety oprogramowania', 40);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 85, 'Usługi zdrowotne i społeczne', 39);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 50, 'Usługi napraw i konserwacji', 38);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 44, 'Materiały budowlane', 38);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 32, 'Sprzęt elektroniczny i telekomunikacyjny', 32);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 42, 'Maszyny przemysłowe', 31);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 3, 'Produkty rolne, łowieckie i rybne', 30);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 66, 'Usługi finansowe i ubezpieczeniowe', 28);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 31, 'Sprzęt elektryczny', 25);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 37, 'Sprzęt sportowy i rekreacyjny', 23);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 72, 'Usługi informatyczne', 19);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 63, 'Usługi spedycji i logistyki', 16);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 22, 'Drukowane materiały i produkty poligraficzne', 16);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 98, 'Pozostałe usługi komunalne i osobiste', 16);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 64, 'Usługi pocztowe i telekomunikacyjne', 11);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 24, 'Produkty chemiczne', 10);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 35, 'Sprzęt bezpieczeństwa i ochrony', 9);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 14, 'Górnictwo i minerały', 9);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 18, 'Odzież i obuwie', 8);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 43, 'Maszyny górnicze', 8);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 73, 'Usługi badawczo-rozwojowe', 6);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 92, 'Usługi rekreacyjne i kulturalne', 6);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 16, 'Maszyny rolnicze', 4);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 19, 'Wyroby skórzane i tekstylne', 4);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 70, 'Usługi w zakresie nieruchomości', 3);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 51, 'Usługi instalacyjne', 3);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 75, 'Usługi administracji publicznej', 3);
INSERT INTO tenders_by_province_and_division VALUES ('Pomorskie', 65, 'Usługi komunalne (gaz, woda, energia)', 3);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 45, 'Roboty budowlane', 1940);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 71, 'Usługi architektoniczne i inżynieryjne', 373);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 33, 'Sprzęt medyczny i farmaceutyczny', 299);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 15, 'Artykuły spożywcze i napoje', 168);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 30, 'Sprzęt komputerowy i biurowy', 164);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 90, 'Usługi środowiskowe i sanitarne', 149);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 9, 'Produkty naftowe, paliwa i energia', 123);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 34, 'Sprzęt transportowy i pojazdy', 121);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 60, 'Usługi transportu drogowego', 121);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 79, 'Usługi biznesowe i doradcze', 104);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 80, 'Usługi edukacyjne', 99);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 39, 'Meble i wyposażenie wnętrz', 95);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 55, 'Usługi hotelarskie i restauracyjne', 71);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 48, 'Pakiety oprogramowania', 71);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 50, 'Usługi napraw i konserwacji', 60);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 38, 'Sprzęt laboratoryjny i naukowy', 51);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 85, 'Usługi zdrowotne i społeczne', 46);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 44, 'Materiały budowlane', 43);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 77, 'Usługi rolnicze i leśne', 40);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 66, 'Usługi finansowe i ubezpieczeniowe', 39);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 72, 'Usługi informatyczne', 39);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 42, 'Maszyny przemysłowe', 36);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 24, 'Produkty chemiczne', 31);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 3, 'Produkty rolne, łowieckie i rybne', 30);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 37, 'Sprzęt sportowy i rekreacyjny', 28);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 32, 'Sprzęt elektroniczny i telekomunikacyjny', 26);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 31, 'Sprzęt elektryczny', 25);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 70, 'Usługi w zakresie nieruchomości', 24);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 98, 'Pozostałe usługi komunalne i osobiste', 19);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 22, 'Drukowane materiały i produkty poligraficzne', 17);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 18, 'Odzież i obuwie', 16);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 14, 'Górnictwo i minerały', 16);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 64, 'Usługi pocztowe i telekomunikacyjne', 14);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 43, 'Maszyny górnicze', 12);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 92, 'Usługi rekreacyjne i kulturalne', 12);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 63, 'Usługi spedycji i logistyki', 8);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 75, 'Usługi administracji publicznej', 7);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 73, 'Usługi badawczo-rozwojowe', 7);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 19, 'Wyroby skórzane i tekstylne', 6);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 16, 'Maszyny rolnicze', 6);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 35, 'Sprzęt bezpieczeństwa i ochrony', 6);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 51, 'Usługi instalacyjne', 3);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 65, 'Usługi komunalne (gaz, woda, energia)', 2);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 41, 'Woda i usługi wodne', 2);
INSERT INTO tenders_by_province_and_division VALUES ('Śląskie', 76, 'Usługi związane z przemysłem naftowym', 1);
INSERT INTO tenders_by_province_and_division VALUES ('Świętokrzyskie', 45, 'Roboty budowlane', 698);
INSERT INTO tenders_by_province_and_division VALUES ('Świętokrzyskie', 33, 'Sprzęt medyczny i farmaceutyczny', 163);
INSERT INTO tenders_by_province_and_division VALUES ('Świętokrzyskie', 71, 'Usługi architektoniczne i inżynieryjne', 113);
INSERT INTO tenders_by_province_and_division VALUES ('Świętokrzyskie', 30, 'Sprzęt komputerowy i biurowy', 81);
INSERT INTO tenders_by_province_and_division VALUES ('Świętokrzyskie', 34, 'Sprzęt transportowy i pojazdy', 77);
INSERT INTO tenders_by_province_and_division VALUES ('Świętokrzyskie', 9, 'Produkty naftowe, paliwa i energia', 71);
INSERT INTO tenders_by_province_and_division VALUES ('Świętokrzyskie', 60, 'Usługi transportu drogowego', 70);
INSERT INTO tenders_by_province_and_division VALUES ('Świętokrzyskie', 90, 'Usługi środowiskowe i sanitarne', 58);
INSERT INTO tenders_by_province_and_division VALUES ('Świętokrzyskie', 15, 'Artykuły spożywcze i napoje', 38);
INSERT INTO tenders_by_province_and_division VALUES ('Świętokrzyskie', 39, 'Meble i wyposażenie wnętrz', 37);
INSERT INTO tenders_by_province_and_division VALUES ('Świętokrzyskie', 80, 'Usługi edukacyjne', 35);
INSERT INTO tenders_by_province_and_division VALUES ('Świętokrzyskie', 50, 'Usługi napraw i konserwacji', 29);
INSERT INTO tenders_by_province_and_division VALUES ('Świętokrzyskie', 79, 'Usługi biznesowe i doradcze', 24);
INSERT INTO tenders_by_province_and_division VALUES ('Świętokrzyskie', 32, 'Sprzęt elektroniczny i telekomunikacyjny', 19);
INSERT INTO tenders_by_province_and_division VALUES ('Świętokrzyskie', 73, 'Usługi badawczo-rozwojowe', 17);
INSERT INTO tenders_by_province_and_division VALUES ('Świętokrzyskie', 31, 'Sprzęt elektryczny', 17);
INSERT INTO tenders_by_province_and_division VALUES ('Świętokrzyskie', 63, 'Usługi spedycji i logistyki', 17);
INSERT INTO tenders_by_province_and_division VALUES ('Świętokrzyskie', 55, 'Usługi hotelarskie i restauracyjne', 17);
INSERT INTO tenders_by_province_and_division VALUES ('Świętokrzyskie', 38, 'Sprzęt laboratoryjny i naukowy', 16);
INSERT INTO tenders_by_province_and_division VALUES ('Świętokrzyskie', 44, 'Materiały budowlane', 16);
INSERT INTO tenders_by_province_and_division VALUES ('Świętokrzyskie', 48, 'Pakiety oprogramowania', 15);
INSERT INTO tenders_by_province_and_division VALUES ('Świętokrzyskie', 72, 'Usługi informatyczne', 12);
INSERT INTO tenders_by_province_and_division VALUES ('Świętokrzyskie', 66, 'Usługi finansowe i ubezpieczeniowe', 11);
INSERT INTO tenders_by_province_and_division VALUES ('Świętokrzyskie', 24, 'Produkty chemiczne', 11);
INSERT INTO tenders_by_province_and_division VALUES ('Świętokrzyskie', 85, 'Usługi zdrowotne i społeczne', 9);
INSERT INTO tenders_by_province_and_division VALUES ('Świętokrzyskie', 64, 'Usługi pocztowe i telekomunikacyjne', 8);
INSERT INTO tenders_by_province_and_division VALUES ('Świętokrzyskie', 70, 'Usługi w zakresie nieruchomości', 7);
INSERT INTO tenders_by_province_and_division VALUES ('Świętokrzyskie', 14, 'Górnictwo i minerały', 7);
INSERT INTO tenders_by_province_and_division VALUES ('Świętokrzyskie', 42, 'Maszyny przemysłowe', 6);
INSERT INTO tenders_by_province_and_division VALUES ('Świętokrzyskie', 16, 'Maszyny rolnicze', 6);
INSERT INTO tenders_by_province_and_division VALUES ('Świętokrzyskie', 77, 'Usługi rolnicze i leśne', 6);
INSERT INTO tenders_by_province_and_division VALUES ('Świętokrzyskie', 18, 'Odzież i obuwie', 6);
INSERT INTO tenders_by_province_and_division VALUES ('Świętokrzyskie', 3, 'Produkty rolne, łowieckie i rybne', 5);
INSERT INTO tenders_by_province_and_division VALUES ('Świętokrzyskie', 43, 'Maszyny górnicze', 5);
INSERT INTO tenders_by_province_and_division VALUES ('Świętokrzyskie', 98, 'Pozostałe usługi komunalne i osobiste', 4);
INSERT INTO tenders_by_province_and_division VALUES ('Świętokrzyskie', 37, 'Sprzęt sportowy i rekreacyjny', 3);
INSERT INTO tenders_by_province_and_division VALUES ('Świętokrzyskie', 35, 'Sprzęt bezpieczeństwa i ochrony', 3);
INSERT INTO tenders_by_province_and_division VALUES ('Świętokrzyskie', 92, 'Usługi rekreacyjne i kulturalne', 2);
INSERT INTO tenders_by_province_and_division VALUES ('Świętokrzyskie', 51, 'Usługi instalacyjne', 1);
INSERT INTO tenders_by_province_and_division VALUES ('Świętokrzyskie', 22, 'Drukowane materiały i produkty poligraficzne', 1);
INSERT INTO tenders_by_province_and_division VALUES ('Warmińsko-mazurskie', 45, 'Roboty budowlane', 678);
INSERT INTO tenders_by_province_and_division VALUES ('Warmińsko-mazurskie', 33, 'Sprzęt medyczny i farmaceutyczny', 168);
INSERT INTO tenders_by_province_and_division VALUES ('Warmińsko-mazurskie', 30, 'Sprzęt komputerowy i biurowy', 153);
INSERT INTO tenders_by_province_and_division VALUES ('Warmińsko-mazurskie', 71, 'Usługi architektoniczne i inżynieryjne', 91);
INSERT INTO tenders_by_province_and_division VALUES ('Warmińsko-mazurskie', 9, 'Produkty naftowe, paliwa i energia', 81);
INSERT INTO tenders_by_province_and_division VALUES ('Warmińsko-mazurskie', 34, 'Sprzęt transportowy i pojazdy', 79);
INSERT INTO tenders_by_province_and_division VALUES ('Warmińsko-mazurskie', 15, 'Artykuły spożywcze i napoje', 57);
INSERT INTO tenders_by_province_and_division VALUES ('Warmińsko-mazurskie', 60, 'Usługi transportu drogowego', 45);
INSERT INTO tenders_by_province_and_division VALUES ('Warmińsko-mazurskie', 39, 'Meble i wyposażenie wnętrz', 44);
INSERT INTO tenders_by_province_and_division VALUES ('Warmińsko-mazurskie', 55, 'Usługi hotelarskie i restauracyjne', 43);
INSERT INTO tenders_by_province_and_division VALUES ('Warmińsko-mazurskie', 90, 'Usługi środowiskowe i sanitarne', 42);
INSERT INTO tenders_by_province_and_division VALUES ('Warmińsko-mazurskie', 48, 'Pakiety oprogramowania', 38);
INSERT INTO tenders_by_province_and_division VALUES ('Warmińsko-mazurskie', 38, 'Sprzęt laboratoryjny i naukowy', 37);
INSERT INTO tenders_by_province_and_division VALUES ('Warmińsko-mazurskie', 79, 'Usługi biznesowe i doradcze', 31);
INSERT INTO tenders_by_province_and_division VALUES ('Warmińsko-mazurskie', 44, 'Materiały budowlane', 25);
INSERT INTO tenders_by_province_and_division VALUES ('Warmińsko-mazurskie', 80, 'Usługi edukacyjne', 23);
INSERT INTO tenders_by_province_and_division VALUES ('Warmińsko-mazurskie', 3, 'Produkty rolne, łowieckie i rybne', 23);
INSERT INTO tenders_by_province_and_division VALUES ('Warmińsko-mazurskie', 16, 'Maszyny rolnicze', 20);
INSERT INTO tenders_by_province_and_division VALUES ('Warmińsko-mazurskie', 32, 'Sprzęt elektroniczny i telekomunikacyjny', 19);
INSERT INTO tenders_by_province_and_division VALUES ('Warmińsko-mazurskie', 77, 'Usługi rolnicze i leśne', 18);
INSERT INTO tenders_by_province_and_division VALUES ('Warmińsko-mazurskie', 42, 'Maszyny przemysłowe', 18);
INSERT INTO tenders_by_province_and_division VALUES ('Warmińsko-mazurskie', 50, 'Usługi napraw i konserwacji', 18);
INSERT INTO tenders_by_province_and_division VALUES ('Warmińsko-mazurskie', 14, 'Górnictwo i minerały', 16);
INSERT INTO tenders_by_province_and_division VALUES ('Warmińsko-mazurskie', 37, 'Sprzęt sportowy i rekreacyjny', 16);
INSERT INTO tenders_by_province_and_division VALUES ('Warmińsko-mazurskie', 31, 'Sprzęt elektryczny', 16);
INSERT INTO tenders_by_province_and_division VALUES ('Warmińsko-mazurskie', 24, 'Produkty chemiczne', 13);
INSERT INTO tenders_by_province_and_division VALUES ('Warmińsko-mazurskie', 43, 'Maszyny górnicze', 13);
INSERT INTO tenders_by_province_and_division VALUES ('Warmińsko-mazurskie', 85, 'Usługi zdrowotne i społeczne', 12);
INSERT INTO tenders_by_province_and_division VALUES ('Warmińsko-mazurskie', 66, 'Usługi finansowe i ubezpieczeniowe', 12);
INSERT INTO tenders_by_province_and_division VALUES ('Warmińsko-mazurskie', 64, 'Usługi pocztowe i telekomunikacyjne', 8);
INSERT INTO tenders_by_province_and_division VALUES ('Warmińsko-mazurskie', 73, 'Usługi badawczo-rozwojowe', 7);
INSERT INTO tenders_by_province_and_division VALUES ('Warmińsko-mazurskie', 35, 'Sprzęt bezpieczeństwa i ochrony', 7);
INSERT INTO tenders_by_province_and_division VALUES ('Warmińsko-mazurskie', 22, 'Drukowane materiały i produkty poligraficzne', 5);
INSERT INTO tenders_by_province_and_division VALUES ('Warmińsko-mazurskie', 72, 'Usługi informatyczne', 5);
INSERT INTO tenders_by_province_and_division VALUES ('Warmińsko-mazurskie', 98, 'Pozostałe usługi komunalne i osobiste', 5);
INSERT INTO tenders_by_province_and_division VALUES ('Warmińsko-mazurskie', 70, 'Usługi w zakresie nieruchomości', 4);
INSERT INTO tenders_by_province_and_division VALUES ('Warmińsko-mazurskie', 18, 'Odzież i obuwie', 3);
INSERT INTO tenders_by_province_and_division VALUES ('Warmińsko-mazurskie', 63, 'Usługi spedycji i logistyki', 2);
INSERT INTO tenders_by_province_and_division VALUES ('Warmińsko-mazurskie', 92, 'Usługi rekreacyjne i kulturalne', 2);
INSERT INTO tenders_by_province_and_division VALUES ('Warmińsko-mazurskie', 19, 'Wyroby skórzane i tekstylne', 2);
INSERT INTO tenders_by_province_and_division VALUES ('Warmińsko-mazurskie', 51, 'Usługi instalacyjne', 1);
INSERT INTO tenders_by_province_and_division VALUES ('Wielkopolskie', 45, 'Roboty budowlane', 1699);
INSERT INTO tenders_by_province_and_division VALUES ('Wielkopolskie', 33, 'Sprzęt medyczny i farmaceutyczny', 295);
INSERT INTO tenders_by_province_and_division VALUES ('Wielkopolskie', 30, 'Sprzęt komputerowy i biurowy', 288);
INSERT INTO tenders_by_province_and_division VALUES ('Wielkopolskie', 71, 'Usługi architektoniczne i inżynieryjne', 227);
INSERT INTO tenders_by_province_and_division VALUES ('Wielkopolskie', 60, 'Usługi transportu drogowego', 168);
INSERT INTO tenders_by_province_and_division VALUES ('Wielkopolskie', 9, 'Produkty naftowe, paliwa i energia', 137);
INSERT INTO tenders_by_province_and_division VALUES ('Wielkopolskie', 90, 'Usługi środowiskowe i sanitarne', 116);
INSERT INTO tenders_by_province_and_division VALUES ('Wielkopolskie', 15, 'Artykuły spożywcze i napoje', 107);
INSERT INTO tenders_by_province_and_division VALUES ('Wielkopolskie', 39, 'Meble i wyposażenie wnętrz', 99);
INSERT INTO tenders_by_province_and_division VALUES ('Wielkopolskie', 34, 'Sprzęt transportowy i pojazdy', 95);
INSERT INTO tenders_by_province_and_division VALUES ('Wielkopolskie', 79, 'Usługi biznesowe i doradcze', 73);
INSERT INTO tenders_by_province_and_division VALUES ('Wielkopolskie', 24, 'Produkty chemiczne', 65);
INSERT INTO tenders_by_province_and_division VALUES ('Wielkopolskie', 55, 'Usługi hotelarskie i restauracyjne', 54);
INSERT INTO tenders_by_province_and_division VALUES ('Wielkopolskie', 38, 'Sprzęt laboratoryjny i naukowy', 50);
INSERT INTO tenders_by_province_and_division VALUES ('Wielkopolskie', 77, 'Usługi rolnicze i leśne', 47);
INSERT INTO tenders_by_province_and_division VALUES ('Wielkopolskie', 3, 'Produkty rolne, łowieckie i rybne', 44);
INSERT INTO tenders_by_province_and_division VALUES ('Wielkopolskie', 85, 'Usługi zdrowotne i społeczne', 36);
INSERT INTO tenders_by_province_and_division VALUES ('Wielkopolskie', 50, 'Usługi napraw i konserwacji', 36);
INSERT INTO tenders_by_province_and_division VALUES ('Wielkopolskie', 66, 'Usługi finansowe i ubezpieczeniowe', 35);
INSERT INTO tenders_by_province_and_division VALUES ('Wielkopolskie', 48, 'Pakiety oprogramowania', 35);
INSERT INTO tenders_by_province_and_division VALUES ('Wielkopolskie', 80, 'Usługi edukacyjne', 33);
INSERT INTO tenders_by_province_and_division VALUES ('Wielkopolskie', 72, 'Usługi informatyczne', 33);
INSERT INTO tenders_by_province_and_division VALUES ('Wielkopolskie', 44, 'Materiały budowlane', 30);
INSERT INTO tenders_by_province_and_division VALUES ('Wielkopolskie', 42, 'Maszyny przemysłowe', 29);
INSERT INTO tenders_by_province_and_division VALUES ('Wielkopolskie', 32, 'Sprzęt elektroniczny i telekomunikacyjny', 29);
INSERT INTO tenders_by_province_and_division VALUES ('Wielkopolskie', 98, 'Pozostałe usługi komunalne i osobiste', 26);
INSERT INTO tenders_by_province_and_division VALUES ('Wielkopolskie', 31, 'Sprzęt elektryczny', 21);
INSERT INTO tenders_by_province_and_division VALUES ('Wielkopolskie', 18, 'Odzież i obuwie', 17);
INSERT INTO tenders_by_province_and_division VALUES ('Wielkopolskie', 64, 'Usługi pocztowe i telekomunikacyjne', 14);
INSERT INTO tenders_by_province_and_division VALUES ('Wielkopolskie', 37, 'Sprzęt sportowy i rekreacyjny', 14);
INSERT INTO tenders_by_province_and_division VALUES ('Wielkopolskie', 16, 'Maszyny rolnicze', 12);
INSERT INTO tenders_by_province_and_division VALUES ('Wielkopolskie', 63, 'Usługi spedycji i logistyki', 10);
INSERT INTO tenders_by_province_and_division VALUES ('Wielkopolskie', 43, 'Maszyny górnicze', 9);
INSERT INTO tenders_by_province_and_division VALUES ('Wielkopolskie', 22, 'Drukowane materiały i produkty poligraficzne', 9);
INSERT INTO tenders_by_province_and_division VALUES ('Wielkopolskie', 14, 'Górnictwo i minerały', 8);
INSERT INTO tenders_by_province_and_division VALUES ('Wielkopolskie', 19, 'Wyroby skórzane i tekstylne', 7);
INSERT INTO tenders_by_province_and_division VALUES ('Wielkopolskie', 73, 'Usługi badawczo-rozwojowe', 5);
INSERT INTO tenders_by_province_and_division VALUES ('Wielkopolskie', 92, 'Usługi rekreacyjne i kulturalne', 3);
INSERT INTO tenders_by_province_and_division VALUES ('Wielkopolskie', 35, 'Sprzęt bezpieczeństwa i ochrony', 2);
INSERT INTO tenders_by_province_and_division VALUES ('Wielkopolskie', 51, 'Usługi instalacyjne', 2);
INSERT INTO tenders_by_province_and_division VALUES ('Wielkopolskie', 65, 'Usługi komunalne (gaz, woda, energia)', 2);
INSERT INTO tenders_by_province_and_division VALUES ('Zachodniopomorskie', 45, 'Roboty budowlane', 966);
INSERT INTO tenders_by_province_and_division VALUES ('Zachodniopomorskie', 33, 'Sprzęt medyczny i farmaceutyczny', 138);
INSERT INTO tenders_by_province_and_division VALUES ('Zachodniopomorskie', 30, 'Sprzęt komputerowy i biurowy', 135);
INSERT INTO tenders_by_province_and_division VALUES ('Zachodniopomorskie', 71, 'Usługi architektoniczne i inżynieryjne', 121);
INSERT INTO tenders_by_province_and_division VALUES ('Zachodniopomorskie', 34, 'Sprzęt transportowy i pojazdy', 111);
INSERT INTO tenders_by_province_and_division VALUES ('Zachodniopomorskie', 15, 'Artykuły spożywcze i napoje', 67);
INSERT INTO tenders_by_province_and_division VALUES ('Zachodniopomorskie', 90, 'Usługi środowiskowe i sanitarne', 61);
INSERT INTO tenders_by_province_and_division VALUES ('Zachodniopomorskie', 60, 'Usługi transportu drogowego', 56);
INSERT INTO tenders_by_province_and_division VALUES ('Zachodniopomorskie', 80, 'Usługi edukacyjne', 53);
INSERT INTO tenders_by_province_and_division VALUES ('Zachodniopomorskie', 55, 'Usługi hotelarskie i restauracyjne', 52);
INSERT INTO tenders_by_province_and_division VALUES ('Zachodniopomorskie', 9, 'Produkty naftowe, paliwa i energia', 51);
INSERT INTO tenders_by_province_and_division VALUES ('Zachodniopomorskie', 79, 'Usługi biznesowe i doradcze', 46);
INSERT INTO tenders_by_province_and_division VALUES ('Zachodniopomorskie', 39, 'Meble i wyposażenie wnętrz', 38);
INSERT INTO tenders_by_province_and_division VALUES ('Zachodniopomorskie', 50, 'Usługi napraw i konserwacji', 32);
INSERT INTO tenders_by_province_and_division VALUES ('Zachodniopomorskie', 85, 'Usługi zdrowotne i społeczne', 28);
INSERT INTO tenders_by_province_and_division VALUES ('Zachodniopomorskie', 38, 'Sprzęt laboratoryjny i naukowy', 28);
INSERT INTO tenders_by_province_and_division VALUES ('Zachodniopomorskie', 42, 'Maszyny przemysłowe', 24);
INSERT INTO tenders_by_province_and_division VALUES ('Zachodniopomorskie', 44, 'Materiały budowlane', 23);
INSERT INTO tenders_by_province_and_division VALUES ('Zachodniopomorskie', 66, 'Usługi finansowe i ubezpieczeniowe', 23);
INSERT INTO tenders_by_province_and_division VALUES ('Zachodniopomorskie', 77, 'Usługi rolnicze i leśne', 20);
INSERT INTO tenders_by_province_and_division VALUES ('Zachodniopomorskie', 48, 'Pakiety oprogramowania', 20);
INSERT INTO tenders_by_province_and_division VALUES ('Zachodniopomorskie', 32, 'Sprzęt elektroniczny i telekomunikacyjny', 17);
INSERT INTO tenders_by_province_and_division VALUES ('Zachodniopomorskie', 3, 'Produkty rolne, łowieckie i rybne', 16);
INSERT INTO tenders_by_province_and_division VALUES ('Zachodniopomorskie', 18, 'Odzież i obuwie', 16);
INSERT INTO tenders_by_province_and_division VALUES ('Zachodniopomorskie', 14, 'Górnictwo i minerały', 13);
INSERT INTO tenders_by_province_and_division VALUES ('Zachodniopomorskie', 72, 'Usługi informatyczne', 11);
INSERT INTO tenders_by_province_and_division VALUES ('Zachodniopomorskie', 98, 'Pozostałe usługi komunalne i osobiste', 11);
INSERT INTO tenders_by_province_and_division VALUES ('Zachodniopomorskie', 22, 'Drukowane materiały i produkty poligraficzne', 9);
INSERT INTO tenders_by_province_and_division VALUES ('Zachodniopomorskie', 16, 'Maszyny rolnicze', 8);
INSERT INTO tenders_by_province_and_division VALUES ('Zachodniopomorskie', 24, 'Produkty chemiczne', 8);
INSERT INTO tenders_by_province_and_division VALUES ('Zachodniopomorskie', 31, 'Sprzęt elektryczny', 6);
INSERT INTO tenders_by_province_and_division VALUES ('Zachodniopomorskie', 64, 'Usługi pocztowe i telekomunikacyjne', 5);
INSERT INTO tenders_by_province_and_division VALUES ('Zachodniopomorskie', 63, 'Usługi spedycji i logistyki', 4);
INSERT INTO tenders_by_province_and_division VALUES ('Zachodniopomorskie', 43, 'Maszyny górnicze', 4);
INSERT INTO tenders_by_province_and_division VALUES ('Zachodniopomorskie', 75, 'Usługi administracji publicznej', 3);
INSERT INTO tenders_by_province_and_division VALUES ('Zachodniopomorskie', 35, 'Sprzęt bezpieczeństwa i ochrony', 3);
INSERT INTO tenders_by_province_and_division VALUES ('Zachodniopomorskie', 37, 'Sprzęt sportowy i rekreacyjny', 3);
INSERT INTO tenders_by_province_and_division VALUES ('Zachodniopomorskie', 92, 'Usługi rekreacyjne i kulturalne', 2);
INSERT INTO tenders_by_province_and_division VALUES ('Zachodniopomorskie', 73, 'Usługi badawczo-rozwojowe', 1);
INSERT INTO tenders_by_province_and_division VALUES ('Zachodniopomorskie', 51, 'Usługi instalacyjne', 1);
INSERT INTO tenders_by_province_and_division VALUES ('Zachodniopomorskie', 19, 'Wyroby skórzane i tekstylne', 1);
INSERT INTO tenders_by_province_and_division VALUES ('Zachodniopomorskie', 70, 'Usługi w zakresie nieruchomości', 1);

CREATE VIEW tenders_by_day AS
SELECT 
    SUBSTR(publicationDate, 1, 10) AS publication_date,
    COUNT(*)                        AS tender_count
FROM raw_data
WHERE publicationDate IS NOT NULL
GROUP BY publication_date
ORDER BY publication_date;
