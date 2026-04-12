import sqlite3
import csv

conn = sqlite3.connect("eZam_DB.db")

tables = [
    "tenders_by_cpv",
    "tenders_by_cpv_division",
    "tenders_by_gdp",
    "tenders_by_gdp_per_capita",
    "tenders_by_population",
    "tenders_by_population_warsaw_split",
    "tenders_by_province",
    "tenders_by_province_and_division",
    "tenders_by_province_year",
    "top5_cpv_by_province",
    "top5_cpv_by_province_2021",
    "top5_cpv_by_province_2022",
    "top5_cpv_by_province_2023",
    "top5_cpv_by_province_2024",
    "top5_cpv_by_province_2025"
]

for table in tables:
    cursor = conn.execute(f"SELECT * FROM {table}")
    with open(f"{table}.csv", "w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f, delimiter=";")
        writer.writerow([d[0] for d in cursor.description])
        writer.writerows(cursor)

conn.close()