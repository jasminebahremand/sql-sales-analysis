-- =====================================
-- STRONG REVENUE. WRONG ACQUISITION.
-- Parch & Posey B2B Sales Analysis
-- SQL · DBeaver · PostgreSQL
-- =====================================


-- =====================================
-- 1. Current State of the Business
-- =====================================

-- Top 10 customers by single transaction value
SELECT
    a.name AS customer_name,
    o.total_amt_usd
FROM orders o
JOIN accounts a
    ON a.id = o.account_id
ORDER BY o.total_amt_usd DESC
LIMIT 10;

-- Total number of customers
SELECT
    COUNT(DISTINCT id) AS total_customers
FROM accounts;

-- Revenue by customer
SELECT
    a.name AS customer_name,
    SUM(o.total_amt_usd) AS total_sales_revenue
FROM accounts a
JOIN orders o
    ON a.id = o.account_id
GROUP BY a.name
ORDER BY total_sales_revenue DESC;

-- Total company revenue and product quantities
SELECT
    SUM(o.total_amt_usd) AS total_revenue,
    SUM(o.standard_qty) AS total_standard_paper_qty,
    SUM(o.gloss_qty) AS total_gloss_paper_qty,
    SUM(o.poster_qty) AS total_poster_paper_qty
FROM orders o;

-- First recorded sale date and total customers
SELECT
    MIN(o.occurred_at) AS first_sale_date,
    COUNT(DISTINCT a.id) AS total_customers
FROM orders o
JOIN accounts a
    ON o.account_id = a.id;

-- Employee distribution by region
SELECT
    r.name AS region,
    COUNT(sr.id) AS num_employees
FROM region r
JOIN sales_reps sr
    ON r.id = sr.region_id
GROUP BY r.name
ORDER BY num_employees DESC;


-- =====================================
-- 2. Revenue by Product Type
-- =====================================

-- Total revenue by product type
-- Standard leads in volume but Gloss generates disproportionately
-- higher revenue relative to order count
SELECT
    SUM(standard_amt_usd) AS standard_revenue,
    SUM(gloss_amt_usd) AS gloss_revenue,
    SUM(poster_amt_usd) AS poster_revenue
FROM orders;

-- Product popularity by UNITS SOLD (sum of quantity)
-- NOTE: these are units sold, NOT order counts
SELECT
    SUM(standard_qty) AS standard_units_sold,
    SUM(gloss_qty) AS gloss_units_sold,
    SUM(poster_qty) AS poster_units_sold
FROM orders;

-- Product popularity by ORDER COUNT (how many orders include each product)
SELECT
    COUNT(*) FILTER (WHERE standard_qty > 0) AS standard_order_count,
    COUNT(*) FILTER (WHERE gloss_qty > 0)    AS gloss_order_count,
    COUNT(*) FILTER (WHERE poster_qty > 0)   AS poster_order_count
FROM orders;

-- Revenue share by product type
SELECT
    ROUND(SUM(standard_amt_usd) / SUM(total_amt_usd) * 100, 2) AS standard_revenue_pct,
    ROUND(SUM(gloss_amt_usd) / SUM(total_amt_usd) * 100, 2) AS gloss_revenue_pct,
    ROUND(SUM(poster_amt_usd) / SUM(total_amt_usd) * 100, 2) AS poster_revenue_pct
FROM orders;

-- Monthly revenue trend
SELECT
    TO_CHAR(occurred_at, 'YYYY-MM') AS month,
    SUM(total_amt_usd) AS monthly_revenue
FROM orders
GROUP BY TO_CHAR(occurred_at, 'YYYY-MM')
ORDER BY month;

-- Monthly revenue trend by product type
SELECT
    TO_CHAR(occurred_at, 'YYYY-MM') AS month,
    SUM(total_amt_usd) AS monthly_revenue,
    SUM(standard_amt_usd) AS standard_revenue,
    SUM(gloss_amt_usd) AS gloss_revenue,
    SUM(poster_amt_usd) AS poster_revenue
FROM orders
GROUP BY TO_CHAR(occurred_at, 'YYYY-MM')
ORDER BY month;

-- Revenue contribution by product type per order
SELECT
    id AS order_id,
    ROUND((standard_amt_usd / NULLIF(total_amt_usd, 0)) * 100, 2) AS standard_pct,
    ROUND((gloss_amt_usd / NULLIF(total_amt_usd, 0)) * 100, 2) AS gloss_pct,
    ROUND((poster_amt_usd / NULLIF(total_amt_usd, 0)) * 100, 2) AS poster_pct
FROM orders
WHERE total_amt_usd > 0
LIMIT 30;


-- =====================================
-- 3. Growth Over Time
-- =====================================

-- Total revenue growth, first full year to last full year
SELECT
    ROUND((y2016.rev - y2014.rev) / y2014.rev * 100, 2) AS revenue_growth_pct
FROM
    (SELECT SUM(total_amt_usd) AS rev FROM orders
     WHERE EXTRACT(YEAR FROM occurred_at) = 2014) AS y2014,
    (SELECT SUM(total_amt_usd) AS rev FROM orders
     WHERE EXTRACT(YEAR FROM occurred_at) = 2016) AS y2016;

-- Yearly revenue and quantity (2014-2016) -- supports the per-year table
SELECT
    EXTRACT(YEAR FROM occurred_at) AS year,
    SUM(standard_qty + gloss_qty + poster_qty) AS total_qty,
    ROUND(SUM(total_amt_usd), 2) AS total_revenue
FROM orders
WHERE EXTRACT(YEAR FROM occurred_at) BETWEEN 2014 AND 2016
GROUP BY EXTRACT(YEAR FROM occurred_at)
ORDER BY year;

-- Year-over-year growth rate (2014-15: 41.4%, 2015-16: 123.7%)
-- Uses a window function (LAG) to compare each year to the one before
SELECT
    year,
    total_revenue,
    ROUND((total_revenue - LAG(total_revenue) OVER (ORDER BY year))
          / LAG(total_revenue) OVER (ORDER BY year) * 100, 1) AS yoy_growth_pct
FROM (
    SELECT EXTRACT(YEAR FROM occurred_at) AS year,
           SUM(total_amt_usd) AS total_revenue
    FROM orders
    WHERE EXTRACT(YEAR FROM occurred_at) BETWEEN 2014 AND 2016
    GROUP BY EXTRACT(YEAR FROM occurred_at)
) yearly
ORDER BY year;

-- Monthly growth in quantities and revenue across all product types
SELECT
    DATE_TRUNC('month', occurred_at) AS month,
    SUM(standard_qty) AS standard_total_qty,
    SUM(gloss_qty) AS gloss_total_qty,
    SUM(poster_qty) AS poster_total_qty,
    SUM(standard_qty + gloss_qty + poster_qty) AS total_qty,
    SUM(standard_amt_usd) AS standard_total_amt_usd,
    SUM(gloss_amt_usd) AS gloss_total_amt_usd,
    SUM(poster_amt_usd) AS poster_total_amt_usd,
    SUM(total_amt_usd) AS total_amt_usd
FROM orders
GROUP BY DATE_TRUNC('month', occurred_at)
ORDER BY month;

-- Average order value per month (is order size growing? -- stays roughly flat)
SELECT
    DATE_TRUNC('month', occurred_at) AS month,
    ROUND(SUM(total_amt_usd) / COUNT(id), 2) AS avg_order_value
FROM orders
GROUP BY DATE_TRUNC('month', occurred_at)
ORDER BY month;

-- New customers acquired per month, by first order date (rises through 2016)
SELECT
    DATE_TRUNC('month', first_order) AS month,
    COUNT(*) AS new_customers
FROM (
    SELECT account_id, MIN(occurred_at) AS first_order
    FROM orders
    GROUP BY account_id
) first_orders
GROUP BY DATE_TRUNC('month', first_order)
ORDER BY month ASC;


-- =====================================
-- 4. Regional Sales Performance & Rep Allocation
-- =====================================

-- Accounts, reps, and average accounts per rep by region
SELECT
    r.name AS region,
    COUNT(DISTINCT a.id) AS num_accounts,
    COUNT(DISTINCT sr.id) AS num_reps,
    ROUND(COUNT(DISTINCT a.id)::numeric / NULLIF(COUNT(DISTINCT sr.id), 0), 0) AS avg_accounts_per_rep
FROM accounts a
JOIN sales_reps sr
    ON sr.id = a.sales_rep_id
JOIN region r
    ON r.id = sr.region_id
GROUP BY r.name
ORDER BY num_accounts DESC;

-- Number of sales representatives by region
SELECT
    r.name AS region,
    COUNT(sr.id) AS num_representatives
FROM sales_reps sr
JOIN region r
    ON r.id = sr.region_id
GROUP BY r.name
ORDER BY num_representatives DESC;

-- Sales performance by region
SELECT
    r.name AS region,
    SUM(o.standard_qty + o.gloss_qty + o.poster_qty) AS total_quantity,
    ROUND(SUM(o.total_amt_usd), 0) AS total_amt_usd
FROM orders o
JOIN accounts a
    ON a.id = o.account_id
JOIN sales_reps sr
    ON sr.id = a.sales_rep_id
JOIN region r
    ON r.id = sr.region_id
GROUP BY r.name
ORDER BY total_amt_usd DESC;

-- Revenue per sales rep by region, with each region's share of total revenue
-- KEY FINDING: Northeast has 21 of 50 reps but lowest revenue per rep
-- ($368K vs $645K in Southeast) — resources are misallocated
SELECT
    r.name AS region,
    COUNT(DISTINCT sr.id) AS num_sales_reps,
    ROUND(SUM(o.total_amt_usd), 0) AS total_revenue,
    ROUND(SUM(o.total_amt_usd) / (SELECT SUM(total_amt_usd) FROM orders) * 100, 2) AS revenue_proportion_pct,
    ROUND(SUM(o.total_amt_usd) / NULLIF(COUNT(DISTINCT sr.id), 0), 0) AS revenue_per_rep
FROM orders o
JOIN accounts a
    ON o.account_id = a.id
JOIN sales_reps sr
    ON a.sales_rep_id = sr.id
JOIN region r
    ON sr.region_id = r.id
GROUP BY r.name
ORDER BY revenue_per_rep DESC;

-- Total orders and revenue per region
SELECT
    r.name AS region,
    SUM(o.standard_qty + o.gloss_qty + o.poster_qty) AS qty_sold,
    SUM(o.total_amt_usd) AS total_revenue
FROM orders o
JOIN accounts a
    ON o.account_id = a.id
JOIN sales_reps sr
    ON a.sales_rep_id = sr.id
JOIN region r
    ON sr.region_id = r.id
GROUP BY r.name
ORDER BY total_revenue DESC;


-- =====================================
-- 5. Industry Segmentation
-- =====================================

-- Customer count by industry category
-- Note: Uses keyword matching on account names to infer industry
SELECT 'Food' AS industry_category, COUNT(*) AS customer_count
FROM accounts
WHERE name ILIKE '%Food%'
   OR name ILIKE '%Restaurant%'
   OR name ILIKE '%Cafe%'
   OR name ILIKE '%Catering%'
   OR name ILIKE '%Soup%'
   OR name ILIKE '%Market%'

UNION

SELECT 'Finance & Insurance' AS industry_category, COUNT(*) AS customer_count
FROM accounts
WHERE name ILIKE '%financ%'
   OR name ILIKE '%Bank%'
   OR name ILIKE '%Capital%'
   OR name ILIKE '%Investment%'
   OR name ILIKE '%Insurance%'
   OR name ILIKE '%Insure%'
   OR name ILIKE '%Policy%'
   OR name ILIKE '%Life%'

UNION

SELECT 'Energy' AS industry_category, COUNT(*) AS customer_count
FROM accounts
WHERE name ILIKE '%energy%'
   OR name ILIKE '%power%'
   OR name ILIKE '%electric%'
   OR name ILIKE '%oil%'
   OR name ILIKE '%gas%'
   OR name ILIKE '%petro%'
   OR name ILIKE '%renewable%'

UNION

SELECT 'Automobile' AS industry_category, COUNT(*) AS customer_count
FROM accounts
WHERE name ILIKE '%auto%'
   OR name ILIKE '%motor%'

UNION

SELECT 'Tech' AS industry_category, COUNT(*) AS customer_count
FROM accounts
WHERE name ILIKE '%tech%'
   OR name ILIKE '%software%'
   OR name ILIKE '%digital%'
   OR name ILIKE '%communication%'
   OR name ILIKE '%solution%'
   OR name ILIKE '%system%'

UNION

SELECT 'Health' AS industry_category, COUNT(*) AS customer_count
FROM accounts
WHERE name ILIKE '%health%'
   OR name ILIKE '%hospital%'
   OR name ILIKE '%pharma%';

-- Total orders by industry category
-- KEY FINDING: Finance & Insurance and Energy are top segments by order volume
SELECT
    industry_category,
    COUNT(DISTINCT o.id) AS total_orders
FROM (
    SELECT id, 'Food' AS industry_category
    FROM accounts
    WHERE name ILIKE '%Food%'
       OR name ILIKE '%Restaurant%'
       OR name ILIKE '%Cafe%'
       OR name ILIKE '%Catering%'
       OR name ILIKE '%Soup%'
       OR name ILIKE '%Market%'

    UNION ALL

    SELECT id, 'Finance & Insurance' AS industry_category
    FROM accounts
    WHERE name ILIKE '%financ%'
       OR name ILIKE '%Bank%'
       OR name ILIKE '%Capital%'
       OR name ILIKE '%Investment%'
       OR name ILIKE '%Insurance%'
       OR name ILIKE '%Insure%'
       OR name ILIKE '%Policy%'
       OR name ILIKE '%Life%'

    UNION ALL

    SELECT id, 'Energy' AS industry_category
    FROM accounts
    WHERE name ILIKE '%energy%'
       OR name ILIKE '%power%'
       OR name ILIKE '%electric%'
       OR name ILIKE '%oil%'
       OR name ILIKE '%gas%'
       OR name ILIKE '%petro%'
       OR name ILIKE '%renewable%'

    UNION ALL

    SELECT id, 'Automobile' AS industry_category
    FROM accounts
    WHERE name ILIKE '%auto%'
       OR name ILIKE '%motor%'

    UNION ALL

    SELECT id, 'Tech' AS industry_category
    FROM accounts
    WHERE name ILIKE '%tech%'
       OR name ILIKE '%software%'
       OR name ILIKE '%digital%'
       OR name ILIKE '%communication%'
       OR name ILIKE '%solution%'
       OR name ILIKE '%system%'

    UNION ALL

    SELECT id, 'Health' AS industry_category
    FROM accounts
    WHERE name ILIKE '%health%'
       OR name ILIKE '%hospital%'
       OR name ILIKE '%pharma%'
) categorized_companies
JOIN orders o
    ON o.account_id = categorized_companies.id
GROUP BY industry_category
ORDER BY total_orders DESC;


-- =====================================
-- 6. Marketing Channel Analysis
-- =====================================

-- Web engagement by channel and region
-- KEY FINDING: Direct channel dominates across all regions
-- Twitter and banner ads are significantly underutilized
SELECT
    q.region_id,
    we.channel,
    COUNT(q.region_id) AS counts
FROM web_events we
LEFT JOIN (
    SELECT
        a.id,
        a.name,
        a.sales_rep_id,
        sr.region_id
    FROM accounts a
    LEFT JOIN sales_reps sr
        ON a.sales_rep_id = sr.id
) q
    ON we.account_id = q.id
GROUP BY we.channel, q.region_id
ORDER BY q.region_id, counts ASC;
