INSERT INTO silver.crm_sales_details (
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
)
-- Code to correct any possible mistake in the crm_sales_details data
SELECT 
   sls_ord_num,
   sls_prd_key,
   sls_cust_id,
   CASE 
      WHEN sls_order_dt = 0 
	  OR LEN(sls_order_dt) != 8 
	  OR sls_order_dt > 20500101 
      OR sls_order_dt < 19000101
	    THEN NULL 
	  ELSE CAST(CAST(sls_order_dt AS varchar) AS DATE)
   END AS sls_order_dt,
   CASE 
      WHEN sls_ship_dt = 0 
	  OR LEN(sls_ship_dt) != 8 
	  OR sls_ship_dt > 20500101 
      OR sls_ship_dt < 19000101
	    THEN NULL 
	  ELSE CAST(CAST(sls_ship_dt AS varchar) AS DATE)
   END AS sls_ship_dt,
   CASE 
      WHEN sls_due_dt = 0 
	  OR LEN(sls_due_dt) != 8 
	  OR sls_due_dt > 20500101 
      OR sls_due_dt < 19000101
	    THEN NULL 
	  ELSE CAST(CAST(sls_due_dt AS varchar) AS DATE)
   END AS sls_due_dt,
   CASE 
	    WHEN sls_sales != sls_price * ABS(sls_quantity)
	      OR sls_sales is NULL  OR sls_sales <= 0
		  THEN sls_quantity * ABS(sls_price)
		ELSE sls_sales
   END AS sls_sales,
   sls_quantity,
   CASE 
	    WHEN sls_price IS NULL OR sls_price <= 0
		  THEN sls_sales / NULLIF(sls_quantity, 0)
	    ELSE sls_price
   END as sls_price
FROM bronze.crm_sales_details;

SELECT *
from silver.crm_sales_details;

-- check 
SELECT TOP 20*
from silver.crm_sales_details;

-- Count number of rows
SELECT COUNT(*) AS Number_of_rows
from silver.crm_sales_details;

-- CHECK IF THERE ARE ID(KEY) in the crm_prd_info table but not in crm_sales_details
SELECT *
from bronze.crm_sales_details
WHERE sls_prd_key NOT IN (
   SELECT prd_key 
   from silver.crm_prd_info
);

-- CHECK IF THERE ARE ID(KEY) in the crm_cust_info table but not in crm_sales_details
SELECT *
from bronze.crm_sales_details
WHERE sls_cust_id NOT IN (
   SELECT cst_id 
   from silver.crm_cust_info
);

-- Correcting the Data columns, which are in wrong Data Types
-- Check for 0 first since the column is integer
SELECT *
from silver.crm_sales_details
WHERE sls_order_dt <= 0;

-- Replace the zero with null instead using NULLIF
SELECT 
    NULLIF(sls_order_dt, 0) as sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 
   OR LEN(sls_order_dt) != 8;

SELECT 
    NULLIF(sls_order_dt, 0) as sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 
   OR sls_order_dt > 20500101 
   OR sls_order_dt < 19000101
   OR LEN(sls_order_dt) != 8;

-- Check same thing for shipping Date and due date
SELECT 
    NULLIF(sls_ship_dt, 0) as sls_ship_dt
FROM bronze.crm_sales_details
WHERE sls_ship_dt <= 0 
   OR sls_ship_dt > 20500101 
   OR sls_ship_dt < 19000101
   OR LEN(sls_ship_dt) != 8;

SELECT 
    NULLIF(sls_due_dt, 0) as sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0 
   OR sls_due_dt > 20500101 
   OR sls_due_dt < 19000101
   OR LEN(sls_due_dt) != 8;

-- Count of rows violating the Date format
SELECT COUNT(*)
FROM (
	SELECT
		NULLIF(sls_order_dt, 0) as sls_order_dt
	FROM bronze.crm_sales_details
	WHERE sls_order_dt <= 0 
	   OR sls_order_dt > 20500101 
	   OR sls_order_dt < 19000101
	   OR LEN(sls_order_dt) != 8)
AS T;

-- Check for invalid date order: The sls_order_dt should never be greater than sls_ship_dt or sls_due_dt
SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
      OR sls_order_dt > sls_due_dt;

-- sls_price, sls_quantity_sls_sales
SELECT
    sls_sales,
	sls_quantity,
	sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_price * sls_quantity
   OR sls_sales is NULL 
   or sls_quantity is null
   or sls_price is null
   or sls_sales <= 0
   or sls_quantity <= 0
   or sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;