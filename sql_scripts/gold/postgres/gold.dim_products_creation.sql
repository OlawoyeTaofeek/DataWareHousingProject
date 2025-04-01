CREATE VIEW gold.dim_products AS (
	SELECT 
	   ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
	   pn.prd_id as product_id,
	   pn.prd_key as product_number,
	   pn.prd_nm as prd_name,
	   pn.cat_id as category_id,
	   pc.cat as category,
	   pc.subcat as subcategory,
	   pc.maintenance,
	   pn.prd_cost as cost,
	   pn.prd_line as product_line,
	   pn.prd_start_dt as start_date
	FROM silver.crm_prd_info as pn
	Left JOIN silver.erp_px_cat_g1v2 as pc
	ON pn.cat_id = pc.id
	-- Filter out all historical data
	WHERE prd_end_dt IS NULL
);