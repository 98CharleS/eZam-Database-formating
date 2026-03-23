import pandas as pd
import sqlite3


def convert_csv_to_db(csv_file, db_name, table_name):
    """
    Imports data from CSV to SQLite.
    Handles potential delimiter issues and inconsistent row lengths.
    """
    try:
        # Load the dataset.
        # sep=None with engine='python' enables automatic delimiter detection.
        # on_bad_lines='warn' skips problematic rows instead of crashing.
        df = pd.read_csv(csv_file, sep=None, engine='python', on_bad_lines='warn')

        with sqlite3.connect(db_name) as conn:
            # Overwrite the table with the imported data
            df.to_sql(table_name, conn, if_exists='replace', index=False)

        print(f"Success: Data from {csv_file} has been imported into '{table_name}'.")
    except Exception as e:
        print(f"Error during conversion: {e}")


if __name__ == "__main__":
    convert_csv_to_db('eZam_DB.csv', 'eZam_DB.db', 'raw_data')
