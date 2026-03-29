# eZamDB: Data Formatting & Cleaning
![Python](https://img.shields.io/badge/python-3.8+-blue.svg)
![SQLite](https://img.shields.io/badge/database-SQLite-lightgrey.svg)
![SQL](https://img.shields.io/badge/language-SQL-orange.svg)
![Status](https://img.shields.io/badge/status-complete-brightgreen.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## 📌 Project Overview
This repository is the second stage of the **eZamówienia data pipeline**. It takes raw tender data extracted from the [eZamówienia API](https://github.com/98CharleS/eZam-Database-extraction) and transforms it into a clean, query-ready SQLite database.

The pipeline handles inconsistent CSV formatting, standardizes province names across Poland's 16 voivodeships, and produces aggregated views ready for further analysis.

> **Part of a larger project:**
> [`eZam-Database-extraction`](https://github.com/98CharleS/eZam-Database-extraction) → **`eZam-Database-formating`** → *(analysis & Tableau dashboards — coming soon)*

---

## 🛠️ Technical Stack
- **Language:** Python
- **Database:** SQLite
- **Data Processing:** `pandas`, `sqlite3`
- **Querying & Transformation:** SQL

---

## 📁 Repository Structure

```
eZam-Database-formating/
│
├── data/
│   ├── eZam_DB.csv                    # Raw BZP data (export from eZamówienia)
│   ├── region_GDP.csv                 # Regional GDP by province (GUS, PLN millions)
│   ├── region_population.csv          # Regional population by province (GUS)
│   ├── tenders_by_province.csv        # Aggregation output
│   ├── tenders_by_province_year.csv   # Aggregation output
│   ├── tenders_by_cpv.csv             # Aggregation output
│   ├── tenders_by_gdp.csv             # Enrichment output
│   └── tenders_by_population.csv      # Enrichment output
│
├── queries/
│   ├── 01_cleaning.sql                # Data cleaning
│   ├── 02_changing_province_name.sql  # Province name standardization
│   ├── 03_aggregations.sql            # Aggregated views & summaries
│   └── 04_province_enriched.sql       # Regional enrichment (GDP & population)
│
├── converter.py                       # CSV → SQLite loader
├── tables_extractor.py                # SQLite tables → CSV exporter
└── README.md
```

---

## 🔄 Pipeline Steps

### 1. `converter.py` — CSV to SQLite
Loads a CSV file into a local SQLite database. The script prompts for the file name at runtime (without extension) and creates a matching `.db` file.
- Tries multiple encodings automatically (`utf-8`, `cp1250`, `iso-8859-2`, `iso-8859-1`)
- Skips malformed rows without crashing (`on_bad_lines='warn'`)
- Overwrites the `raw_data` table on each run

```bash
python converter.py
# Enter file name: eZam_DB
```

### 2. `queries/01_cleaning.sql` — Data Cleaning
- Removes non-Polish records (`organizationCountry != 'PL'`)
- Drops columns that contain only NULL values or a single constant value: `TenderType`, `procedureResult`, `isTenderAmountBelowEU`
- Trims whitespace from organization columns

> Requires SQLite ≥ 3.35.0 for `ALTER TABLE ... DROP COLUMN`.

### 3. `queries/02_changing_province_name.sql` — Province Standardization
Maps ISO province codes (`PL-XX`) to the 16 official Polish voivodeship names (e.g. `PL-14` → `Mazowieckie`).

### 4. `queries/03_aggregations.sql` — Aggregations
Creates three summary tables:

| Table | Description |
|---|---|
| `tenders_by_province` | Total tender count per province, descending |
| `tenders_by_province_year` | Pivot table with years 2021–2025 as columns |
| `tenders_by_cpv` | Tender count per primary CPV code and description, descending |

CPV parsing extracts only the first code and its description from the `cpvCode` field (format: `92111210-7 (Produkcja filmów reklamowych)`).

### 5. `queries/04_province_enriched.sql` — Regional Enrichment
Joins tender counts with regional GDP and population data (loaded as separate attached databases):
- Requires `ATTACH DATABASE` for `region_GDP.db` and `region_population.db` before running
- Requires `COMMIT` before `DETACH` due to active transactions in DB Browser
- GDP values use space as thousands separator — stripped via `REPLACE` before numeric conversion

| Table | Key columns |
|---|---|
| `tenders_by_gdp` | `wojewodztwo`, `total_tenders`, `gdp_mln_pln`, `przetargi_na_mln_gdp` |
| `tenders_by_population` | `wojewodztwo`, `total_tenders`, `ludnosc`, `przetargi_na_100k_mieszkancow` |

### 6. `tables_extractor.py` — Export to CSV
Exports all five aggregation/enrichment tables from `eZam_DB.db` to CSV files in the project root.
- Delimiter: `;`
- Encoding: `utf-8`
- No external dependencies (stdlib only)

```bash
python tables_extractor.py
```

---

## 🗃️ `raw_data` Table Schema

| Column | Description |
|---|---|
| `id`, `ObjectId` | Record identifiers |
| `clientType` | Type of contracting authority |
| `noticeType`, `noticeNumber`, `bzpNumber` | Notice metadata |
| `publicationDate` | Publication date (ISO 8601) |
| `orderObject` | Description of the procurement object |
| `cpvCode` | CPV codes — pipeline uses the primary (first) code only |
| `submittingOffersDate` | Offer submission deadline (ISO 8601) |
| `organizationName`, `organizationCity` | Contracting authority details |
| `organizationProvince` | Province (after `02_`: full Polish name) |
| `organizationCountry`, `organizationNationalId`, `organizationId`, `tenderId` | Additional identifiers |

> Columns `TenderType`, `procedureResult`, and `isTenderAmountBelowEU` are dropped during cleaning (`01_cleaning.sql`).

---

## 📊 Reference Data

### `region_GDP.csv`
Regional GDP by province (source: GUS), format: `region;GDP`. Values use a space as thousands separator (e.g. `282 957`) — SQL scripts use `REPLACE` before numeric conversion.

### `region_population.csv`
Regional population by province (source: GUS), format: `region;population`.

Both files use `;` as delimiter and Windows-1250 encoding.

---

## 🚀 Usage

### Prerequisites
```bash
pip install pandas
```

### Run
1. Place your `eZam_DB.csv` (from the extraction stage) in `data/`.
2. Run the converter:
```bash
python converter.py
# Enter file name: eZam_DB
```
3. Open `eZam_DB.db` in [DB Browser for SQLite](https://sqlitebrowser.org/) and execute the SQL scripts in order:
```
queries/01_cleaning.sql
queries/02_changing_province_name.sql
queries/03_aggregations.sql
```
4. For regional enrichment, also attach `region_GDP.db` and `region_population.db`, then run:
```
queries/04_province_enriched.sql
```
5. Export results to CSV:
```bash
python tables_extractor.py
```

---

## 🗺️ Data Source
Data is sourced from **[eZamówienia](https://ezamowienia.gov.pl)** — the official Polish public procurement platform. Each record represents a single contract notice, identified by CPV code and date range as configured in the extraction stage.

Regional reference data (GDP, population) sourced from **GUS** (Główny Urząd Statystyczny / Central Statistical Office of Poland).

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

## 🔗 Related Repositories

| Repository | Description |
|---|---|
| [eZam-Database-extraction](https://github.com/98CharleS/eZam-Database-extraction) | Stage 1 — API extraction to CSV |
| *(coming soon)* | Stage 3 — Analysis & Tableau dashboards |
