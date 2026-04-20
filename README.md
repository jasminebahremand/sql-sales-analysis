# Strong Revenue. Wrong Acquisition.
**SQL · Business Intelligence · M&A Analysis · $23.1M Dataset**

---

## Overview
Strong revenue growth does not guarantee a sound acquisition. This analysis evaluated whether Parch & Posey, a B2B paper company operating across the US, represented a viable acquisition target — examining $23.1M in lifetime revenue across 352 accounts to assess company health, growth trajectory, operational efficiency, and marketing positioning.

> Full write-up available at [portfolio URL]

---

## Key Findings
- **Revenue grew 216% from 2014 to 2016** — but growth alone did not reflect operational readiness
- **Sales rep allocation was critically misaligned** — the Northeast held 21 of 51 total reps but generated only $368K revenue per rep vs $645K in the Southeast and $593K in the West
- **Finance & Insurance and Energy were the strongest customer segments** by order volume — indicating where future acquisition value would actually live
- **Direct channel dominated web engagement** across all regions — Twitter and banner ads were the least utilized channels, suggesting significant untapped marketing upside
- **Recommendation: Do not proceed** — operational inefficiencies, misallocated resources, and gaps in business intelligence outweighed the revenue growth story

---

## Methods
- Multi-table SQL joins across 5 relational tables (orders, accounts, sales_reps, region, web_events)
- Revenue and regional performance analysis
- Sales rep efficiency analysis (revenue per rep by region)
- Customer segmentation by industry using keyword-based classification
- Marketing channel analysis by region
- Aggregations, subqueries, and UNION operations throughout

---

## Tech Stack
SQL · DBeaver · PostgreSQL

---

## Files
- `queries/01_current_state.sql` — top customers, total revenue, employee distribution
- `queries/02_product_revenue.sql` — revenue by product type and monthly trends
- `queries/03_growth_over_time.sql` — monthly growth in quantities and revenue
- `queries/04_regional_performance.sql` — regional sales and rep efficiency analysis
- `queries/05_industry_segmentation.sql` — customer segmentation by industry
- `queries/06_channel_analysis.sql` — web engagement by channel and region

---

## Data

**Parch & Posey dataset** is a publicly available teaching dataset.

Search "Parch and Posey dataset" on GitHub or Kaggle to find the CSV files. Load into PostgreSQL or DBeaver before running queries.

---

## How to Run

1. Load the Parch & Posey dataset into PostgreSQL
2. Open DBeaver and connect to your database
3. Run queries in order from `01` through `06`

---

## Sample Queries

**Revenue per sales rep by region — key finding:**
```sql
SELECT
    r.name AS region,
    COUNT(DISTINCT sr.id) AS num_sales_reps,
    SUM(o.total_amt_usd) AS total_revenue,
    ROUND(SUM(o.total_amt_usd) / NULLIF(COUNT(DISTINCT sr.id), 0), 2) AS revenue_per_rep
FROM orders o
JOIN accounts a ON o.account_id = a.id
JOIN sales_reps sr ON a.sales_rep_id = sr.id
JOIN region r ON sr.region_id = r.id
GROUP BY r.name
ORDER BY revenue_per_rep DESC;
```

**Industry segmentation by order volume:**
```sql
SELECT
    industry_category,
    COUNT(DISTINCT o.id) AS total_orders
FROM (
    SELECT id, 'Finance & Insurance' AS industry_category
    FROM accounts
    WHERE name ILIKE '%financ%' OR name ILIKE '%Bank%'
       OR name ILIKE '%Capital%' OR name ILIKE '%Insurance%'
    UNION ALL
    SELECT id, 'Energy' AS industry_category
    FROM accounts
    WHERE name ILIKE '%energy%' OR name ILIKE '%power%'
       OR name ILIKE '%oil%' OR name ILIKE '%gas%'
) categorized
JOIN orders o ON o.account_id = categorized.id
GROUP BY industry_category
ORDER BY total_orders DESC;
```
