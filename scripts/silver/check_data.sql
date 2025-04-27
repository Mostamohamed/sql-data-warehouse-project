/*
===============================================================================
Stored Procedure: check datat in Silver Layer
===============================================================================
Script Purpose:
    This stored procedure performs Test Transform
*/

-----------------------------------crm_cust_info-------------------------------------------------

-- Check For Nulls or Duplicates in Primary Key
-- Expectation: No Results
SELECT cst_id,COUNT(*) FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1  OR cst_id IS NULL


-- Check For unwanted Spaces
-- Expectation: No Results
SELECT cst_firstname FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

SELECT cst_lastname FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname)

SELECT cst_gndr FROM silver.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr)

SELECT cst_key FROM silver.crm_cust_info
WHERE cst_key != TRIM(cst_key)

SELECT cst_marital_status FROM silver.crm_cust_info
WHERE cst_marital_status != TRIM(cst_marital_status)



-- Data Standardization & Consistency
SELECT DISTINCT cst_gndr FROM silver.crm_cust_info

SELECT DISTINCT cst_marital_status FROM silver.crm_cust_info

SELECT * FROM silver.crm_cust_info



-----------------------------------crm_prd_info-------------------------------------------------

-- Check For Nulls or Duplicates in Primary Key
-- Expectation: No Results
SELECT prd_id,COUNT(*) FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1  OR prd_id IS NULL


-- Check For unwanted Spaces
-- Expectation: No Results
SELECT prd_nm FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

-- Check For Nulls or Negative Numbers Spaces
-- Expectation: No Results
SELECT prd_cost FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL


-- Data Standardization & Consistency
SELECT DISTINCT prd_line FROM silver.crm_prd_info

-- Check for Invalid Date Orders
SELECT * FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt

SELECT * FROM silver.crm_prd_info

-----------------------------------crm_sales_details-------------------------------------------------
-- check for Invalid Dates
SELECT  NULLIF(sls_order_dt,0) sls_order_dt
FROM silver.crm_sales_details
WHERE sls_order_dt <=0 
OR LEN(sls_order_dt) !=8 
OR sls_order_dt > 20500101 
OR sls_order_dt < 19000101

SELECT  NULLIF(sls_ship_dt,0) sls_ship_dt
FROM silver.crm_sales_details
WHERE sls_ship_dt <=0 
OR LEN(sls_ship_dt) !=8 
OR sls_ship_dt > 20500101 
OR sls_ship_dt < 19000101


SELECT  NULLIF(sls_due_dt,0) sls_ship_dt
FROM silver.crm_sales_details
WHERE sls_due_dt <=0 
OR LEN(sls_due_dt) !=8 
OR sls_due_dt > 20500101 
OR sls_due_dt < 19000101

-- check for Invalid Date Orders
SELECT * FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt


-- check Data Consistenct: Between sales,Quantity, and Price
-->> Sales=Quantity*Price
-->> Values must not be NULL , zero or negative

SELECT DISTINCT 
sls_sales,
sls_quantity,
sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity *sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL 
OR sls_sales <=0 OR sls_quantity <=0  OR sls_price <=0   
ORDER BY sls_sales,sls_quantity,sls_price



  -----------------------------------erp_cust_az12-------------------------------------------------
-- Identify Out-of-Range Dates

SELECT DISTINCT
bdate
from silver.erp_cust_az12
WHERE bdate <'1924-01-01' OR bdate >GETDATE()

-- Data Standardization & Consistenct

SELECT DISTINCT gen
from silver.erp_cust_az12

SELECT *from silver.erp_cust_az12

  -----------------------------------erp_loc_a101-------------------------------------------------
  -- Data Standardization & Consistenct
SELECT DISTINCT cntry 
FROM silver.erp_loc_a101 
ORDER BY cntry

SELECT *from silver.erp_loc_a101


-----------------------------------erp_px_cat_g1v2-------------------------------------------------
-- Check for unwanted Spaces
SELECT  * from bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance)

  -- Data Standardization & Consistenct
SELECT  DISTINCT cat
from bronze.erp_px_cat_g1v2

SELECT  DISTINCT subcat
from bronze.erp_px_cat_g1v2

SELECT  DISTINCT maintenance
from bronze.erp_px_cat_g1v2

SELECT *
from bronze.erp_px_cat_g1v2
