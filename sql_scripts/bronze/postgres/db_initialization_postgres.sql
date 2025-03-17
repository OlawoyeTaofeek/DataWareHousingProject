/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    - Creates a new database named 'data_warehouse' after checking if it already exists.
    - If the database exists, it is dropped and recreated.
    - Sets up three schemas: 'bronze', 'silver', and 'gold'.

WARNING:
    Running this script will drop the entire 'data_warehouse' database if it exists.
    All data in the database will be permanently deleted. Proceed with caution
    and ensure you have proper backups before running this script.
*/

-- Terminate existing connections and drop database if it exists
SELECT pg_terminate_backend(pid) 
FROM pg_stat_activity 
WHERE datname = 'data_warehouse';

DROP DATABASE IF EXISTS data_warehouse;

-- Create the 'data_warehouse' database
CREATE DATABASE data_warehouse;

-- Connect to the new database
\c data_warehouse;

-- Create Schemas
CREATE SCHEMA bronze;
CREATE SCHEMA silver;
CREATE SCHEMA gold;
