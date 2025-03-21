-- Cleaning the crm_prd_info table 

-- Check for missing and duplicates


SELECT SUBSTRING(prd_key, 1, 5) AS cat_key
FROM bronze.crm_prd_info
limit 5;

-- Replacing character
/*SELECT REPLACE(prd_key, 'A', 'X') AS new_prd_key
FROM bronze.crm_prd_info;
*/


SELECT *
FROM bronze.crm_prd_info
limit 5;

SELECT DISTINCT id from bronze.erp_px_cat_g1v2; -- 37 Distinct key

SELECT DISTINCT SUBSTRING(prd_key, 1, 5)
FROM bronze.crm_prd_info; -- Balanced 37 Distinct keys

-- Let's replace the '-' with and '_' to make it uniform with the bronze.erp_px_cat_g1v2 table
SELECT REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS prd_key
FROM bronze.crm_prd_info; 


SELECT 
   prd_id,
   prd_key,
   REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
   prd_nm,
   prd_cost,
   prd_line,
   prd_start_dt,
   prd_end_dt
FROM bronze.crm_prd_info
WHERE REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') NOT IN (
   SELECT DISTINCT id from bronze.erp_px_cat_g1v2
);


SELECT * FROM bronze.crm_sales_details;

-- Since the crm_prd_info links with the crm_sales_details, we do have to extract the key to join it
SELECT 
   prd_id,
   prd_key,
   REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
   SUBSTRING(prd_key, 7, LENgth(prd_key)) AS prd_key,
   prd_nm,
   prd_cost,
   prd_line,
   prd_start_dt,
   prd_end_dt
FROM bronze.crm_prd_info;

SELECT 
   prd_id,
   prd_key,
   REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
   SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key,
   prd_nm,
   prd_cost,
   prd_line,
   prd_start_dt,
   prd_end_dt
FROM bronze.crm_prd_info
WHERE SUBSTRING(prd_key, 7, LENGTH(prd_key)) NOT IN (
   SELECT DISTINCT sls_prd_key from bronze.crm_sales_details
);

SELECT 
   prd_id,
   prd_key,
   REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
   SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key,
   prd_nm,
   prd_cost,
   prd_line,
   prd_start_dt,
   prd_end_dt
FROM bronze.crm_prd_info
WHERE SUBSTRING(prd_key, 7, LENGTH(prd_key)) IN (
   SELECT DISTINCT sls_prd_key from bronze.crm_sales_details
);

-- Check for Unwanted spaces in the prd_nm column
SELECT prd_nm 
from bronze.crm_prd_info
where prd_nm != TRIM(prd_nm);

-- For the prd_ check for nulls, or negative numbers
-- Expectation: No result should be gotten.
SELECT prd_cost 
from bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL; -- 2 NULL Values, so we would be filling with 0


SELECT COALESCE(prd_cost, 0) AS new_prd_cost
FROM bronze.crm_prd_info;

SELECT 
   prd_id,
   prd_key,
   REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
   SUBSTRING(prd_key, 7, LENgth(prd_key)) AS prd_key,
   prd_nm,
   COALESCE(prd_cost, 0) AS prd_cost,
   CASE 
      WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
	  WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
	  WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
	  WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
	  ELSE 'Unknown'
   END AS prd_line,
   prd_start_dt,
   prd_end_dt
FROM bronze.crm_prd_info;

-- OR
SELECT 
   prd_id,
   prd_key,
   REPLACE(SUBSTRING(prd_key FROM 1 FOR 5), '-', '_') AS cat_id,
   SUBSTRING(prd_key FROM 7 FOR LENGTH(prd_key)) AS prd_key,
   prd_nm,
   COALESCE(prd_cost, 0) AS prd_cost,
   COALESCE(mapping.prd_line_name, 'Unknown') AS prd_line,
   prd_start_dt,
   prd_end_dt
FROM bronze.crm_prd_info
LEFT JOIN (VALUES 
    ('M', 'Mountain'),
    ('R', 'Road'),
    ('S', 'Other Sales'),
    ('T', 'Touring')
) AS mapping(prd_code, prd_line_name) 
ON mapping.prd_code = UPPER(TRIM(bronze.crm_prd_info.prd_line));


-- Note: Creating a temporary table using VALUES, but exists within a query
SELECT * 
FROM (VALUES 
    ('M', 'Mountain'),
    ('R', 'Road'),
    ('S', 'Other Sales'),
    ('T', 'Touring')
) AS mapping(prd_code, prd_line_name);

SELECT p.prd_id, p.prd_key, COALESCE(m.prd_line_name, 'Unknown') AS prd_line
FROM bronze.crm_prd_info p
LEFT JOIN (VALUES 
    ('M', 'Mountain'),
    ('R', 'Road'),
    ('S', 'Other Sales'),
    ('T', 'Touring')
) AS m(prd_code, prd_line_name) 
ON UPPER(TRIM(p.prd_line)) = m.prd_code;

-- Check for Invalid Date Order
select *
from bronze.crm_prd_info
where prd_start_dt > prd_end_dt;

-- We can decide to update as some of the date from prd_start_dt > prd_end_dt which should not be
-- UPDATE your_table
-- SET start_date = CASE 
--                    WHEN start_date > end_date THEN end_date 
--                    ELSE start_date 
--                  END,
--     end_date = CASE 
--                  WHEN start_date > end_date THEN start_date 
--                  ELSE end_date 
--                END
-- WHERE start_date > end_date;

-- Or we can add it straight into the query since we will be loading it all into silver schema

SELECT 
   prd_id,
   prd_key,
   prd_nm,
   prd_start_dt::DATE,
   prd_end_dt::DATE,
   (LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt))::DATE - 1 AS prd_end_dt_test
from bronze.crm_prd_info
where prd_key in ('AC-HE-HL-U509-R', 'AC-HE-HL-U509');

-- Correction code
SELECT 
   prd_id,
   prd_key,
   REPLACE(SUBSTRING(prd_key FROM 1 FOR 5), '-', '_') AS cat_id,
   SUBSTRING(prd_key FROM 7 FOR LENGTH(prd_key)) AS prd_key,
   prd_nm,
   COALESCE(prd_cost, 0) AS prd_cost,
   COALESCE(mapping.prd_line_name, 'Unknown') AS prd_line,
   prd_start_dt::DATE,
   (LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt))::DATE - 1 AS prd_end_dt_test
FROM bronze.crm_prd_info
LEFT JOIN (VALUES 
    ('M', 'Mountain'),
    ('R', 'Road'),
    ('S', 'Other Sales'),
    ('T', 'Touring')
) AS mapping(prd_code, prd_line_name) 
ON mapping.prd_code = UPPER(TRIM(bronze.crm_prd_info.prd_line));





































































