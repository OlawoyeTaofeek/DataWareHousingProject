import pyodbc

# SQL Server connection using Windows Authentication
conn = pyodbc.connect(
    "DRIVER={ODBC Driver 17 for SQL Server};"
    "SERVER=localhost;"  # Use your actual server name if needed
    "DATABASE=master;"
    "Trusted_Connection=yes;"  # Enables Windows Authentication
)

cursor = conn.cursor()
cursor.execute("SELECT name FROM sys.databases;")
for row in cursor.fetchall():
    print(row[0])  # Prints available databases

conn.close()
