SELECT *
FROM bronze.erp_cust_az12;

SELECT *
FROM silver.crm_cust_info;


-- Since the erp_cust_az12(cid) is connected to the crm_cust_info cst_key, let's inspect
SELECT * FROM silver.crm_cust_info

-- erp_cust_az12 has id like this 'NASAW00011002' and crm_cust_info has cst_key like this 'AW00011000' 
-- So I will be removing the first 3 letter from the erp_cust_az12 to make it same as the cst_key

SELECT *,
       SUBSTRING(cid, 4, LENGTH(cid)) AS cst_id
FROM bronze.erp_cust_az12
WHERE SUBSTRING(cid, 4, LENGTH(cid)) NOT IN 
   (
     SELECT cst_key FROM silver.crm_cust_info
   );

-- Wrong Transformation


-- Correct one
SELECT 
    cid,
    CASE  
        WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid))
        ELSE cid
    END AS cid_transformed,
    bdate,
    gen
FROM bronze.erp_cust_az12
WHERE     
    CASE  
        WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid))
        ELSE cid
    END NOT IN (
        SELECT DISTINCT cst_key FROM silver.crm_cust_info
    );


SELECT DISTINCT bdate
FROM bronze.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > CURRENT_DATE;


SELECT DISTINCT gen
FROM bronze.erp_cust_az12;

-- Normalize Gender Values
SELECT DISTINCT gen,
       CASE 
           WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') 
               THEN 'Female'
           WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') 
               THEN 'Male'
           ELSE 'Unknown'
       END AS gen_normalized
FROM bronze.erp_cust_az12;


--  Final Query with All Corrections
SELECT 
    CASE  
        WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid))
        ELSE cid
    END AS cid_transformed,
    
    CASE 
        WHEN bdate > CURRENT_DATE THEN NULL
        ELSE bdate
    END AS valid_bdate,
    
    CASE 
        WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') 
            THEN 'Female'
        WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') 
            THEN 'Male'
        ELSE 'Unknown'
    END AS gen_normalized

FROM bronze.erp_cust_az12;

