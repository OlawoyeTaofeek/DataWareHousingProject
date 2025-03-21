DO $$ 
BEGIN
    RAISE NOTICE '======================================================';
    RAISE NOTICE 'Data Cleaning Before Loading into the Silver';
    RAISE NOTICE '======================================================';
END $$;

SELECT *
FROM bronze.crm_cust_info;

--Notice 1: Check for null value and duplicates
SELECT cst_id, COUNT(*) AS Number_of_duplicates
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 
   OR cst_id IS NULL;

SELECT cst_id, COUNT(*) AS Number_of_duplicates
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL
ORDER BY cst_id NULLS LAST;

-- Inspect the 29466 cst_id 
SELECT * from bronze.crm_cust_info
WHERE cst_id = 29466;

-- So we are only going to be taking one of the duplicate for 29466 which is the latest one
SELECT 
*,
ROW_NUMBER() over (partition by cst_id order by cst_create_date desc) as latest_ranking
FROM bronze.crm_cust_info
WHERE cst_id = 29466;


-- So we are only going to be taking one of the duplicate for 29466 which is the latest one
SELECT 
*,
ROW_NUMBER() over (partition by cst_id order by cst_create_date desc) as latest_ranking
FROM bronze.crm_cust_info;

-- Using Subqueries to take care of the missing data and dupliacates
SELECT *
FROM (
	SELECT 
	*,
	ROW_NUMBER() over (partition by cst_id order by cst_create_date desc) as latest_ranking
	FROM bronze.crm_cust_info
	) AS t
WHERE latest_ranking <> 1
;

-- 1. The code that takes care of duplicate
SELECT *
FROM (
	SELECT 
	*,
	ROW_NUMBER() over (partition by cst_id order by cst_create_date desc) as latest_ranking
	FROM bronze.crm_cust_info
	) AS t
WHERE latest_ranking = 1;
-- and cst_id = 29466;

-- Notice 2: Check for extra spaces since most columns are strings
SELECT cst_firstname, cst_lastname
FROM bronze.crm_cust_info;

-- Now let's confirm if there are leading or trailing spaces
SELECT cst_firstname
FROM bronze.crm_cust_info
where cst_firstname != TRIM(cst_firstname);

SELECT cst_lastname
FROM bronze.crm_cust_info
where cst_lastname != TRIM(cst_lastname);


-- Notice 3: Data Standardization & Consistency
SELECT distinct cst_gndr
from bronze.crm_cust_info;

-- Changing the abbreviation to Full word
SELECT 
   CASE 
        WHEN UPPER(cst_gndr) = 'F' THEN 'Female'
        WHEN UPPER(cst_gndr) = 'M' THEN 'Male'
        ELSE 'Unknown'
   END AS cst_gndr
FROM bronze.crm_cust_info
LIMIT 10;










































































