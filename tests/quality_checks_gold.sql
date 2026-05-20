/*
===============================================================================
Quality Checks - Gold Layer
===============================================================================
Script Purpose:
    This script performs quality checks to validate the integrity, consistency,
    and accuracy of the Gold Layer for the Clicks Pharmacy Data Warehouse.

    These checks ensure:
    - Uniqueness of surrogate keys in dimension tables.
    - Referential integrity between fact and dimension tables.
    - Valid pharmacy business metrics.
    - Data consistency for analytics and reporting.

Usage Notes:
    - Run after Gold Layer views are created.
    - Investigate and resolve any discrepancies found.
===============================================================================
*/

-- =============================================================================
-- Checking 'gold.dim_customers'
-- =============================================================================

-- Check for duplicate customer surrogate keys
-- Expectation: No Results
SELECT
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

-- Check for NULL customer keys
-- Expectation: No Results
SELECT *
FROM gold.dim_customers
WHERE customer_key IS NULL;

-- Check loyalty tier consistency
-- Expectation: Standardized values only
SELECT DISTINCT loyalty_tier
FROM gold.dim_customers
ORDER BY loyalty_tier;

-- Check gender consistency
-- Expectation: Male, Female, n/a
SELECT DISTINCT gender
FROM gold.dim_customers
ORDER BY gender;


-- =============================================================================
-- Checking 'gold.dim_products'
-- =============================================================================

-- Check for duplicate product surrogate keys
-- Expectation: No Results
SELECT
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- Check for NULL product keys
-- Expectation: No Results
SELECT *
FROM gold.dim_products
WHERE product_key IS NULL;

-- Check for invalid prices
-- Expectation: No negative values
SELECT *
FROM gold.dim_products
WHERE selling_price < 0
   OR cost_price < 0;

-- Check medication schedule consistency
-- Expectation: Schedule 0 - Schedule 6
SELECT DISTINCT medication_schedule
FROM gold.dim_products
ORDER BY medication_schedule;


-- =============================================================================
-- Checking 'gold.dim_medical_schemes'
-- =============================================================================

-- Check for duplicate scheme surrogate keys
-- Expectation: No Results
SELECT
    scheme_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_medical_schemes
GROUP BY scheme_key
HAVING COUNT(*) > 1;

-- Check approval status consistency
-- Expectation: Approved / Rejected / Pending
SELECT DISTINCT approval_status
FROM gold.dim_medical_schemes
ORDER BY approval_status;


-- =============================================================================
-- Checking 'gold.fact_pharmacy_sales'
-- =============================================================================

-- Check fact-to-dimension relationships
-- Expectation: No Results
SELECT *
FROM gold.fact_pharmacy_sales f
LEFT JOIN gold.dim_customers c
    ON f.customer_key = c.customer_key
LEFT JOIN gold.dim_products p
    ON f.product_key = p.product_key
WHERE c.customer_key IS NULL
   OR p.product_key IS NULL;

-- Check for invalid sales values
-- Expectation: No negative or NULL values
SELECT *
FROM gold.fact_pharmacy_sales
WHERE sales_amount <= 0
   OR quantity <= 0
   OR unit_price <= 0
   OR sales_amount IS NULL
   OR quantity IS NULL
   OR unit_price IS NULL;

-- Validate sales calculation
-- Expectation: sales_amount = quantity * unit_price
SELECT *
FROM gold.fact_pharmacy_sales
WHERE sales_amount != quantity * unit_price;


-- =============================================================================
-- Checking 'gold.fact_medical_claims'
-- =============================================================================

-- Check referential integrity
-- Expectation: No Results
SELECT *
FROM gold.fact_medical_claims f
LEFT JOIN gold.dim_customers c
    ON f.customer_key = c.customer_key
LEFT JOIN gold.dim_medical_schemes s
    ON f.scheme_key = s.scheme_key
WHERE c.customer_key IS NULL
   OR s.scheme_key IS NULL;

-- Check for invalid claim amounts
-- Expectation: No negative values
SELECT *
FROM gold.fact_medical_claims
WHERE claim_amount < 0
   OR approved_amount < 0;

-- Check denial logic
-- Expectation: denied_amount = claim_amount - approved_amount
SELECT *
FROM gold.fact_medical_claims
WHERE denied_amount != (claim_amount - approved_amount);


-- =============================================================================
-- Checking 'gold.fact_prescription_refills'
-- =============================================================================

-- Check referential integrity
-- Expectation: No Results
SELECT *
FROM gold.fact_prescription_refills f
LEFT JOIN gold.dim_customers c
    ON f.customer_key = c.customer_key
LEFT JOIN gold.dim_products p
    ON f.product_key = p.product_key
WHERE c.customer_key IS NULL
   OR p.product_key IS NULL;

-- Check refill adherence values
-- Expectation: Between 0 and 100
SELECT *
FROM gold.fact_prescription_refills
WHERE adherence_percentage < 0
   OR adherence_percentage > 100;

-- Check chronic flag consistency
-- Expectation: 0 or 1 only
SELECT DISTINCT chronic_flag
FROM gold.fact_prescription_refills;
