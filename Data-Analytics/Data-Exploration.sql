-- =========================================================
-- Database Explorations: 
-- =========================================================

-- Explore All objects in the Database;
SELECT * FROM INFORMATION_SCHEMA.TABLES; 

SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';


-- Explore all column in the Database
SELECT * FROM INFORMATION_SCHEMA.COLUMNS; -- Give all tables column in the database

-- Selecting for specific table
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';

SELECT TABLE_SCHEMA, COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';