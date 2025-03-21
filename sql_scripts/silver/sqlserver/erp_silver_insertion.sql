-- INSERT all erp data into silver layer

INSERT INTO silver.erp_cust_az12 (
   cid,
   bdate,
   gen
)

SELECT 
	 CASE  
	    WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
		Else cid
	 END as cid,
	 CASE 
	     WHEN bdate > GETDATE() THEN NULL
	     ELSE bdate
	 END AS bdate,
     CASE 
	     WHEN UPPER(TRIM(gen))  IN ('F', 'FEMALE') 
		    THEN 'Female'
		 WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') 
		    THEN 'Male'
		 ELSE 'Unknown'
	 END AS gen
FROM bronze.erp_cust_az12;

-- Inspect 


-- Identify Out if Range Dates
SELECT DISTINCT bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE();

-- Check distinct gender in the gen columns
SELECT DISTINCT gen
FROM silver.erp_cust_az12;

-- Correct one
SELECT 
     cid,
	 CASE  
	    WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
		Else cid
	 END as cid,
	 bdate,
	 gen
FROM silver.erp_cust_az12
WHERE 	 
    CASE  
	    WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
		Else cid
	 END not in (
	    SELECT DISTINCT cst_key FROM silver.crm_cust_info
	 );

SELECT * FROM silver.erp_cust_az12;