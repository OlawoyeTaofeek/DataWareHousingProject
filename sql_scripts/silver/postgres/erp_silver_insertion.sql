INSERT INTO silver.erp_cust_az12 (
   cid,
   bdate,
   gen
)
SELECT 
    CASE  
        WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid))
        ELSE cid
    END AS cid,

    CASE 
        WHEN bdate > CURRENT_DATE THEN NULL
        ELSE bdate
    END AS bdate,

    CASE 
        WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') 
            THEN 'Female'
        WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') 
            THEN 'Male'
        ELSE 'Unknown'
    END AS gen

FROM bronze.erp_cust_az12;


-- Insert into erp_loc_a101
INSERT INTO silver.erp_loc_a101 (
   cid,
   cntry
)
SELECT 
     CASE 
	    WHEN cid LIKE '%-%' THEN REPLACE(cid, '-', '') 
	    ELSE cid
	 END AS cid,
	 CASE 
	     WHEN TRIM(cntry) in ('USA', 'US') 
		    THEN 'United States' 
		 WHEN TRIM(cntry) = 'DE' THEN 'Germany'
		 WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'Unknown'
		 ELSE TRIM(cntry)
	 END AS cntry
from bronze.erp_loc_a101;

-- Insert into silver.erp_px_cat_g1v2
INSERT INTO silver.erp_px_cat_g1v2 (
    id, 
	cat,
	subcat,
	maintenance
)
SELECT 
      CASE 
	     WHEN id LIKE '%_%' THEN REPLACE(id, '_', '-')
		 ELSE id
	  END AS id,
	  cat,
	  subcat,
	  maintenance
from bronze.erp_px_cat_g1v2;

--Inspect 

-- Identify Out-of-Range Dates
SELECT DISTINCT bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > CURRENT_DATE;

-- Check distinct gender values in the "gen" column
SELECT DISTINCT gen
FROM silver.erp_cust_az12;

-- Correct Transformation for cid
SELECT 
    cid,
    CASE  
        WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid))
        ELSE cid
    END AS cid_cleaned,
    bdate,
    gen
FROM silver.erp_cust_az12
WHERE  
    CASE  
        WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid))
        ELSE cid
    END NOT IN (
        SELECT DISTINCT cst_key FROM silver.crm_cust_info
    );

-- Inspect full table (fixing the incomplete query)
SELECT * FROM silver.erp_cust_az12;

select *
from silver.erp_px_cat_g1v2;


