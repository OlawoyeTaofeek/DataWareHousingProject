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
