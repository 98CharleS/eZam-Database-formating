# WiP

# eZamDB: Data Formatting & Cleaning

![Python](https://img.shields.io/badge/python-3.8+-blue.svg)
![SQLite](https://img.shields.io/badge/database-SQLite-lightgrey.svg)
![SQL](https://img.shields.io/badge/language-SQL-orange.svg)
![Status](https://img.shields.io/badge/status-WiP-yellow.svg)

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
├── data/                          # Raw input CSV files
├── converter.py                   # CSV → SQLite loader
├── 01_cleaning.sql                # Data cleaning queries
├── 02_changing_province_name.sql  # Province name standardization
├── 03_aggregations.sql            # Aggregated views & summaries
└── README.md
```

---

## 🔄 Pipeline Steps

### 1. `converter.py` — CSV to SQLite

Loads `eZam_DB.csv` (output from the extraction stage) into a local SQLite database.

- Automatically detects CSV delimiter
- Skips malformed rows without crashing (`on_bad_lines='warn'`)
- Overwrites the `raw_data` table on each run

```bash
python converter.py
```

### 2. `01_cleaning.sql` — Data Cleaning

Removes duplicates, handles nulls, and normalizes column formats.

### 3. `02_changing_province_name.sql` — Province Standardization

Maps inconsistent province name variants to the 16 official Polish voivodeship names (e.g. `"mazowieckie"`, `"Mazowieckie"`, `"woj. mazowieckie"` → `"Mazowieckie"`).

### 4. `03_aggregations.sql` — Aggregations

Produces summary views such as:
- Tender counts by voivodeship
- Breakdown by CPV code
- Trends over time

---

## 🚀 Usage

### Prerequisites

```bash
pip install pandas
```

### Run

1. Place your `eZam_DB.csv` (from the extraction stage) in the project root.
2. Run the converter:

```bash
python converter.py
```

3. Open `eZam_DB.db` in any SQLite client (e.g. [DB Browser for SQLite](https://sqlitebrowser.org/)) and execute the SQL scripts in order:

```
01_cleaning.sql
02_changing_province_name.sql
03_aggregations.sql
```

---

## 🗺️ Data Source

Data is sourced from **[eZamówienia](https://ezamowienia.gov.pl)** — the official Polish public procurement platform. Each record represents a single contract notice, identified by CPV code and date range as configured in the extraction stage.

---

## 🔗 Related Repositories

| Repository | Description |
|---|---|
| [eZam-Database-extraction](https://github.com/98CharleS/eZam-Database-extraction) | Stage 1 — API extraction to CSV |
| *(coming soon)* | Stage 3 — Analysis & Tableau dashboards |
