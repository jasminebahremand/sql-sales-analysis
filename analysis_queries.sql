=====================================
SQL SALES ANALYSIS
Parch & Posey
=====================================

---------------------------------------
Current State of the Business
---------------------------------------

-- Top customer transactions --
SELECT 
  accounts.name,
  orders.total_amt_usd
FROM orders
JOIN accounts 
  ON accounts.id = orders.account_id
ORDER BY orders.total_amt_usd DESC;

-- Total number of customers --
SELECT 
  COUNT(DISTINCT id) AS total_customers
FROM accounts;

-- Revenue by customer --
SELECT 
  accounts.name,
  SUM(orders.standard_amt_usd) AS total_sales_revenue
FROM accounts
JOIN orders 
  ON accounts.id = orders.account_id
GROUP BY accounts.name
ORDER BY total_sales_revenue DESC;

-- Total company revenue and product quantities --
SELECT 
  SUM(orders.total_amt_usd) AS total_revenue,
  SUM(orders.standard_qty) AS total_standard_paper,
  SUM(orders.gloss_qty) AS total_gloss_paper,
  SUM(orders.poster_qty) AS total_poster_paper
FROM orders;

-- First recorded sale date and total customers --
SELECT 
  MIN(orders.occurred_at) AS first_sale_date,
  COUNT(DISTINCT accounts.id) AS total_customers
FROM orders
JOIN accounts 
  ON orders.account_id = accounts.id;

-- Employee distribution by region --
SELECT 
  region.name AS region,
  COUNT(sales_reps.region_id) AS num_employees
FROM region
JOIN sales_reps 
  ON region.id = sales_reps.region_id
GROUP BY region.name, sales_reps.region_id;

---------------------------------------
Revenue by Product Type 
---------------------------------------

-- Total revenue by product type --
SELECT 
  SUM(standard_amt_usd) AS standard_revenue,
  SUM(gloss_amt_usd) AS gloss_revenue,
  SUM(poster_amt_usd) AS poster_revenue
FROM orders;

-- Product popularity by quantity sold --
SELECT 
  SUM(standard_qty) AS standard_orders,
  SUM(gloss_qty) AS gloss_orders,
  SUM(poster_qty) AS poster_orders
FROM orders;

-- Monthly revenue trend --
SELECT 
  TO_CHAR(occurred_at, 'YYYY-MM') AS month,
  SUM(total_amt_usd) AS monthly_revenue
FROM orders
GROUP BY month
ORDER BY month;

-- Monthly revenue trend by product type --
SELECT 
  TO_CHAR(occurred_at, 'YYYY-MM') AS month,
  SUM(total_amt_usd) AS monthly_revenue,
  SUM(standard_amt_usd) AS standard_revenue,
  SUM(gloss_amt_usd) AS gloss_revenue,
  SUM(poster_amt_usd) AS poster_revenue
FROM orders
GROUP BY month
ORDER BY month;

-- Revenue contribution by product type for sample orders --
SELECT 
  id AS order_id,
  (standard_amt_usd / total_amt_usd) * 100 AS standard_pct,
  (gloss_amt_usd / total_amt_usd) * 100 AS gloss_pct,
  (poster_amt_usd / total_amt_usd) * 100 AS poster_pct
FROM orders
LIMIT 30;



---------------------------------------
Growth Over Time 
---------------------------------------

SELECT
  DATE_TRUNC('month', occurred_at) AS month,
  SUM(standard_qty) AS standard_total_qty,
  SUM(gloss_qty) AS gloss_total_qty,
  SUM(poster_qty) AS paper_total_qty,
  SUM(standard_qty + gloss_qty + poster_qty) AS total_qty,
  SUM(standard_amt_usd) AS standard_total_amt_usd,
  SUM(gloss_amt_usd) AS gloss_total_amt_usd,
  SUM(poster_amt_usd) AS paper_total_amt_usd,
  SUM(total_amt_usd) AS total_amt_usd
FROM orders
GROUP BY month
ORDER BY month;

---------------------------------------
Regional Sales Efficiency
---------------------------------------

-- Number of accounts by region --
SELECT 
  r.name AS region,
  COUNT(a.id) AS num_of_account
FROM accounts a
JOIN sales_reps sr
  ON sr.id = a.sales_rep_id
JOIN region r
  ON r.id = sr.region_id
GROUP BY r.name
ORDER BY COUNT(a.id) DESC;

-- Number of sales representatives by region --
SELECT 
  r.name AS region,
  COUNT(sr.id) AS num_of_representative
FROM sales_reps sr
LEFT JOIN region r
  ON r.id = sr.region_id
GROUP BY region
ORDER BY COUNT(sr.id) DESC;

-- Sales performance by region --
SELECT 
  sr.region_id AS region,
  SUM(total) AS total_quantity,
  ROUND(SUM(total_amt_usd)) AS total_amt_usd
FROM orders o
JOIN accounts a
  ON a.id = o.account_id
JOIN sales_reps sr
  ON sr.id = a.sales_rep_id
GROUP BY sr.region_id
ORDER BY total_amt_usd DESC;

-- Revenue by sales representative --
SELECT 
  a.sales_rep_id,
  SUM(o.standard_amt_usd)
FROM accounts a
JOIN orders o
  ON a.id = o.account_id
GROUP BY a.sales_rep_id;

-- Number of accounts per sales representative --
SELECT 
  sales_rep_id,
  COUNT(id)
FROM accounts a
GROUP BY sales_rep_id;

-- Number of reps per region --
SELECT 
  r.name AS region,
  COUNT(sr.id) AS num_sales_reps
FROM sales_reps sr
JOIN region r 
  ON sr.region_id = r.id
GROUP BY r.name
ORDER BY num_sales_reps DESC;

-- Total orders and revenue per region --
SELECT 
  r.name,
  SUM(o.total) AS qty_sold,
  SUM(total_amt_usd) AS total_revenue
FROM orders o
JOIN accounts a 
  ON o.account_id = a.id
JOIN sales_reps sr 
  ON a.sales_rep_id = sr.id
JOIN region r 
  ON sr.region_id = r.id
GROUP BY r.name
ORDER BY SUM(total_amt_usd) DESC;



---------------------------------------
Industry Segmentation
---------------------------------------

-- Count customers by industry category --
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

-- Total orders by industry category --
SELECT 
  industry_category,
  COUNT(DISTINCT orders.id) AS total_orders
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
) AS categorized_companies
JOIN orders 
  ON orders.account_id = categorized_companies.id
GROUP BY industry_category
ORDER BY total_orders DESC;



---------------------------------------
Marketing Channel Analysis
---------------------------------------
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
