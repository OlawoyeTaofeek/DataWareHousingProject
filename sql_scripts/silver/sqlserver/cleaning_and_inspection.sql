SELECT *
FROM bronze.crm_cust_info;

-- Notice 1: Check for null value and duplicates
-- Expectation: No null or duplicates result returned
SELECT cst_id, COUNT(*) AS Number_of_duplicates
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING 
    COUNT(*) > 1 
	OR
	cst_id = null;

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
SELECT *
from (
	SELECT 
	*,
	ROW_NUMBER() over (partition by cst_id order by cst_create_date desc) as latest_ranking
	FROM bronze.crm_cust_info
	) as t
	WHERE latest_ranking = 1
	and cst_id = 29466
;

-- Notice 2: Cjeck for extra spaces since most columns are strings
-- Expectation: No result returned
SELECT cst_firstname, cst_lastname
FROM bronze.crm_cust_info;

-- Now let's confirm if there are leading or trailing spaces
SELECT cst_firstname
FROM bronze.crm_cust_info
where cst_firstname != TRIM(cst_firstname);

SELECT cst_lastname
FROM bronze.crm_cust_info
where cst_lastname != TRIM(cst_lastname);

-- 2. The code to take care of leading and trailing spaces
SELECT 
     cst_id,
	 cst_key,
	 TRIM(cst_firstname) AS cst_firstname,
	 TRIM(cst_lastname) as cst_lastname,
	 cst_marital_status,
	 cst_gndr,
	 cst_create_date
FROM (
	SELECT 
	*,
	ROW_NUMBER() over (partition by cst_id order by cst_create_date desc) as latest_ranking
	FROM bronze.crm_cust_info
	) AS t
WHERE latest_ranking = 1;