-- Gold Layer Data Ingestion and Data Checck
SELECT  * from silver.crm_cust_info;
SELECT * from silver.erp_cust_az12;
SELECT * from silver.erp_loc_a101;

SELECT 
     ci.cst_key as CustomerKey,
     ci.cst_id as CustomerId,
	 ci.cst_firstname as first_name,
	 ci.cst_lastname as last_name,
	 la.cntry as country,
	 ci.cst_marital_status as marital_status,
	 ci.cst_gndr as gender,
	 ca.bdate as birthdate,
	 ci.cst_create_date,
	 ca.gen as gender
FROM silver.crm_cust_info as ci
LEFT JOIN silver.erp_cust_az12 as ca
on ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 as la
on ci.cst_key = la.cid;

-- Check for duplicate
SELECT CustomerId, COUNT(*) FROM 
  (
	SELECT 
		 ci.cst_key as CustomerKey,
		 ci.cst_id as CustomerId,
		 ci.cst_firstname as first_name,
		 ci.cst_lastname as last_name,
		 la.cntry as country,
		 ci.cst_marital_status as marital_status,
		 ci.cst_gndr as gender,
		 ca.bdate as birthdate,
		 ci.cst_create_date
	FROM silver.crm_cust_info as ci
	LEFT JOIN silver.erp_cust_az12 as ca
	on ci.cst_key = ca.cid
	LEFT JOIN silver.erp_loc_a101 as la
	on ci.cst_key = la.cid
) as t
GROUP BY CustomerId
HAVING COUNT(*) > 1;

-- Problem of two gender columns
SELECT
     DISTINCT
	 ci.cst_gndr as gender,
	 ca.gen as gender,
	 CASE 
	     WHEN ci.cst_gndr <> 'Unknown' THEN ci.cst_gndr -- CRM is the Master source for gender info
		 ELSE COALESCE(ca.gen, 'Unknown')
	 END AS new_gen
FROM silver.crm_cust_info as ci
LEFT JOIN silver.erp_cust_az12 as ca
on ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 as la
on ci.cst_key = la.cid
order by 1, 2;

-- Testing the gold.dim_customers view created
SELECT * FROM gold.dim_customers;

SELECT distinct gender from gold.dim_customers;


SELECT 
   pn.prd_id,
   pn.cat_id,
   pn.prd_key,
   pn.prd_nm,
   pn.prd_cost,
   pn.prd_line,
   pn.prd_start_dt,
   pn.prd_end_dt
FROM silver.crm_prd_info as pn
WHERE prd_end_dt IS NULL;

SELECT 
   pn.prd_id,
   pn.cat_id,
   pn.prd_key,
   pn.prd_nm,
   pn.prd_cost,
   pn.prd_line,
   pn.prd_start_dt,
   pc.cat,
   pc.subcat,
   pc.maintenance
FROM silver.crm_prd_info as pn
Left JOIN silver.erp_px_cat_g1v2 as pc
ON pn.cat_id = pc.id
-- Filter out all historical data
WHERE prd_end_dt IS NULL; 
-- If end_dt is NULL, then it is the current info of the product!

SELECT * from silver.erp_px_cat_g1v2
WHERE id = (
SELECT cat_id
from silver.crm_prd_info
LIMIT 1
);

SELECT pn.cat_id, pc.id
FROM silver.crm_prd_info as pn
LEFT JOIN silver.erp_px_cat_g1v2 as pc
ON pn.cat_id = pc.id
WHERE pc.id IS NOT NULL;

SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name IN ('crm_prd_info', 'erp_px_cat_g1v2');

TRUNCATE silver.crm_prd_info;
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
    REPLACE(SUBSTRING(prd_key FROM 1 FOR 5), '-', '_') AS cat_id, -- Extract category ID
    SUBSTRING(prd_key FROM 7) AS prd_key,        -- Extract product key
    prd_nm,
    COALESCE(prd_cost, 0) AS prd_cost,
    CASE 
        WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
        WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
        WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
        WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
        ELSE 'n/a'
    END AS prd_line, -- Map product line codes to descriptive values
    prd_start_dt::DATE AS prd_start_dt,
    (LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - INTERVAL '1 day')::DATE AS prd_end_dt -- Calculate end date as one day before the next start date
FROM bronze.crm_prd_info;


TRUNCATE silver.erp_px_cat_g1v2;
INSERT INTO silver.erp_px_cat_g1v2 (
    id, 
	cat,
	subcat,
	maintenance
)
SELECT 
      id,
	  cat,
	  subcat,
	  maintenance
from bronze.erp_px_cat_g1v2;










