INSERT INTO silver.crm_cust_info (
	cst_id, 
	cst_key, 
	cst_firstname, 
	cst_lastname, 
	cst_marital_status, 
	cst_gndr,
	cst_create_date
)
SELECT 
     cst_id,
	 cst_key,
	 TRIM(cst_firstname) AS cst_firstname,
	 TRIM(cst_lastname) as cst_lastname,
     CASE 
        WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
        WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
		ELSE 'Unknown'
     END AS cst_marital_status,
	 CASE 
	     WHEN UPPER(cst_gndr) = 'F' THEN 'Female'
	     WHEN UPPER(cst_gndr) = 'M' THEN 'Male'
		 ELSE 'Unknown'
	 END AS cst_gndr,
	 cst_create_date::DATE
FROM (
	SELECT 
	*,
	ROW_NUMBER() over (partition by cst_id order by cst_create_date desc) as latest_ranking
	FROM bronze.crm_cust_info
	) AS t
WHERE latest_ranking = 1;
-- and cst_id = 29466;