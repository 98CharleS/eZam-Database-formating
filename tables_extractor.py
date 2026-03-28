import sqlite3
import csv

conn = sqlite3.connect("eZam_DB.db")

tables = ["tenders_by_province", "tenders_by_province_year", "tenders_by_cpv", "tenders_by_gdp", "tenders_by_population"]

for table in tables:
    cursor = conn.execute(f"SELECT * FROM {table}")
    with open(f"{table}.csv", "w", newline="", encoding="utf-8") as f:
        writer = csv.writer(f, delimiter=";")
        writer.writerow([d[0] for d in cursor.description])
        writer.writerows(cursor)

conn.close()