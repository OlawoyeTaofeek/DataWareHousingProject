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

-- Inspection
select *
from silver.crm_prd_info
where prd_start_dt > crm_prd_info.prd_end_dt;


SELECT crm_prd_info.prd_id, COUNT(*) AS Number_of_duplicates
FROM silver.crm_prd_info
GROUP BY crm_prd_info.prd_id
HAVING 
    COUNT(*) > 1 
	OR
	crm_prd_info.prd_id = null;

SELECT crm_prd_info.prd_nm 
from silver.crm_prd_info
where crm_prd_info.prd_nm != TRIM(crm_prd_info.prd_nm);


SELECT crm_prd_info.prd_cost 
from silver.crm_prd_info
WHERE crm_prd_info.prd_cost < 0 
    OR crm_prd_info.prd_cost IS NULL;

SELECT *
FROM crm_prd_info


































