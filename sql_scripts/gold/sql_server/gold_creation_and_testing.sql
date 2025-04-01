-- Gold Layer Data Ingestion and Data Checck
SELECT top 5 * from silver.crm_cust_info;
SELECT top 5 * from silver.erp_cust_az12;
SELECT top 5 * from silver.erp_loc_a101;

SELECT 
     top 100
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
SELECT TOP 5 * FROM gold.dim_customers;

SELECT distinct gender from gold.dim_customers;
 