/*
=============================================================
Create Database and Schemas for Data Warehouse
=============================================================

Purpose:
    This script sets up a new database named 'DataWarehouse'. 
    If the database already exists, it is dropped and recreated. 
    It also defines three schemas: 'bronze', 'silver', and 'gold' 
    to support the Medallion Architecture.

Warning:
    ⚠️ This script will **permanently delete** the existing 'DataWarehouse' database if it exists.  
    All data will be lost. Ensure you have a backup before executing this script.
*/


USE master;
GO

-- Drop and recreate the 'DataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO

-- Create the 'DataWarehouse' database
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO


/*
- IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse') — This checks if a database called DataWarehouse already exists in the SQL Server instance.

- sys.databases is a system view that holds information about all databases on the server.

- SELECT 1 is just a quick and lightweight way to check for the existence of the database — you could use SELECT *, but this is faster.

- BEGIN ... END — This groups multiple SQL statements into a block that runs only if the condition is true.

- ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

- This forces the DataWarehouse database into single-user mode, allowing only one connection to access it.
WITH ROLLBACK IMMEDIATE — If there are any active connections or transactions on the database, they are immediately rolled back and the connections are closed. This ensures you can drop the database without waiting.
DROP DATABASE DataWarehouse; — Deletes the DataWarehouse database if it exists.
 */