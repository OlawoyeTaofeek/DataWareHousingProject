import pyodbc

# SQL Server connection using Windows Authentication
conn = pyodbc.connect(
    "DRIVER={ODBC Driver 17 for SQL Server};"
    "SERVER=localhost\\SQLEXPRESS;"  # Double backslashes
    "DATABASE=master;"
    "Trusted_Connection=yes;"
)

cursor = conn.cursor()
cursor.execute("SELECT name FROM sys.databases;")
for row in cursor.fetchall():
    print(row[0])  # Prints available databases

conn.close()


import psycopg2
import os

# Database connection settings
DB_NAME = "your_database"
DB_USER = "your_username"
DB_PASSWORD = "your_password"
DB_HOST = "localhost"  # Change if using a remote database
DB_PORT = "5432"       # Default PostgreSQL port

# Path to your CSV file
CSV_FILE_PATH = "/Users/muhammadusama/work/data/5m_Sales_Records.csv"

# PostgreSQL table
TABLE_NAME = "sales_record"

# PostgreSQL connection function
def connect_db():
    try:
        conn = psycopg2.connect(
            dbname=DB_NAME, user=DB_USER, password=DB_PASSWORD, host=DB_HOST, port=DB_PORT
        )
        conn.autocommit = True  # Enables immediate execution of commands
        return conn
    except Exception as e:
        print(f"Error connecting to database: {e}")
        return None

# Function to bulk load CSV using COPY
def bulk_import_csv():
    conn = connect_db()
    if not conn:
        return

    try:
        with conn.cursor() as cur:
            # Truncate table (optional: only if you want to remove old data)
            cur.execute(f"TRUNCATE TABLE {TABLE_NAME};")

            # Perform the COPY command for fast import
            with open(CSV_FILE_PATH, "r", encoding="utf-8") as f:
                cur.copy_expert(
                    f"COPY {TABLE_NAME} FROM STDIN WITH CSV HEADER DELIMITER ',' NULL ''", f
                )
            
            print(f"Successfully imported {CSV_FILE_PATH} into {TABLE_NAME}")

    except Exception as e:
        print(f"Error importing CSV: {e}")
    finally:
        conn.close()

# Run the script
if __name__ == "__main__":
    if os.path.exists(CSV_FILE_PATH):
        bulk_import_csv()
    else:
        print(f"CSV file not found: {CSV_FILE_PATH}")

