import pandas as pd
import sqlite3

file = input("Enter file name:\n")
csv_name = file + ".csv"
db_name = file + ".db"


def convert_csv_to_db(csv_file, db_name, table_name):
    encodings = ['utf-8', 'cp1250', 'iso-8859-2', 'iso-8859-1']
    df = None

    for enc in encodings:
        try:
            df = pd.read_csv(csv_file, sep=None, engine='python',
                             on_bad_lines='warn', encoding=enc)
            print(f"Read file using encoding: {enc}")
            break
        except UnicodeDecodeError:
            continue

    if df is None:
        print("Error: Could not decode file with any known encoding.")
        return

    try:
        with sqlite3.connect(db_name) as conn:
            df.to_sql(table_name, conn, if_exists='replace', index=False)
        print(f"Success: Data from {csv_file} imported into '{table_name}'.")
    except Exception as e:
        print(f"Error during conversion: {e}")


if __name__ == "__main__":
    convert_csv_to_db(csv_name, db_name, 'raw_data')
