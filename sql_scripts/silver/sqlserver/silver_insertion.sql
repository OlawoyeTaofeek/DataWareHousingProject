TRUNCATE TABLE silver.crm_prd_info;

INSERT INTO silver.crm_prd_info (
			prd_id,
			cat_id,
			prd_key,
			prd_nm,
			prd_cost,
			prd_line,
			prd_start_dt,
			prd_end_dt
		)
		SELECT
			prd_id,
			REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id, -- Extract category ID
			SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,        -- Extract product key
			prd_nm,
			ISNULL(prd_cost, 0) AS prd_cost,
			CASE 
				WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
				WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
				WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
				WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
				ELSE 'Unknown'
			END AS prd_line, -- Map product line codes to descriptive values
			CAST(prd_start_dt AS DATE) AS prd_start_dt,
			CAST(
				LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - 1 
				AS DATE
			) AS prd_end_dt -- Calculate end date as one day before the next start date
		FROM bronze.crm_prd_info;


SELECT * FROM silver.crm_prd_info;
-- Inspection Queries

-- Check for start dates greater than end dates
SELECT *
FROM silver.crm_prd_info
WHERE prd_start_dt > prd_end_dt;

-- Check for duplicate product IDs
SELECT prd_id, COUNT(*) AS Number_of_duplicates
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 
   OR prd_id IS NULL;

-- Check for product names with extra spaces
SELECT prd_nm 
FROM silver.crm_prd_info
WHERE prd_nm <> LTRIM(RTRIM(prd_nm));

-- Check for negative or NULL product costs
SELECT prd_cost 
FROM silver.crm_prd_info
WHERE prd_cost < 0 
   OR prd_cost IS NULL;

-- View all records
SELECT *
FROM silver.crm_prd_info;

-- Data stanardization  Consistency
select DISTINCT prd_line
from silver.crm_prd_info;