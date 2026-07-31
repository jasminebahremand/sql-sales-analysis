# Is Parch & Posey Worth Acquiring?
**SQL · Business Intelligence · M&A Analysis · $23.1M Dataset**

---

## Overview
A potential acquirer needs to know if growth is real and sustainable — or just a number. This analysis evaluated whether Parch & Posey, a fictional B2B paper company, represented a viable acquisition target — examining $23.1M in lifetime revenue across 352 accounts to assess operational efficiency, sales performance, and marketing positioning.

> Full write-up: https://jasminebahremand.my.canva.site/

---

## Key Findings
- **Revenue grew 216% from 2014 to 2016** — but growth alone did not reflect operational readiness
- **Sales rep allocation was critically misaligned** — the Northeast held 21 of 50 reps but generated only $368K per rep vs $645K in the Southeast and $593K in the West
- **Finance & Insurance and Energy were the strongest customer segments** by order volume — indicating where acquisition value would actually live
- **Critical data gaps around retention, satisfaction, and competitive positioning** left too many unknowns to make a confident investment decision
- **Recommendation: Do not proceed** — operational inefficiencies, misallocated resources, and unresolved data gaps outweigh the revenue growth story

---

## Key Visuals

### Monthly Revenue & Sales Volume Trends (2014–2016)
![Revenue Trend](plots/revenue_sales_volume_trends.png)
Revenue accelerated through 2016. Average order value held roughly flat (~$3,000 per order), while new-customer acquisition climbed from about 2 per month in 2014 to 15-33 per month by late 2016, showing growth was driven by winning new customers rather than larger orders.

### Revenue per Sales Rep by Region
![Revenue Per Rep](plots/revenue_per_rep_by_region.png)
Southeast and West reps generate nearly 2x the revenue per person compared to the Northeast ($645K and $593K vs $368K) — the strongest single indicator of resource misallocation in the dataset.

### Sales Rep Allocation by Region
![Sales Rep Allocation](plots/sales_rep_allocation_by_accounts.png)
The Northeast holds the most accounts and the most reps — but Southeast and West manage comparable account loads with half the headcount.

---

## Methods
- Multi-table SQL joins across 5 relational tables (orders, accounts, sales_reps, region, web_events)
- Revenue and regional performance analysis
- Sales rep efficiency analysis (revenue per rep by region)
- Customer segmentation by industry
- Marketing channel analysis by region
- Aggregations, subqueries, and UNION operations

---

## Tech Stack
SQL · DBeaver · PostgreSQL

---

## How to Run
1. Load the Parch & Posey dataset into PostgreSQL
2. Open DBeaver and connect to your database
3. Run `analysis_queries.sql` top to bottom

---

## Data
**Parch & Posey Dataset:** https://video.udacity-data.com/topher/2020/May/5eb5533b_parch-and-posey/parch-and-posey.sql

Load into PostgreSQL or DBeaver before running queries.

---

## Files
- `analysis_queries.sql` — full analysis with inline comments
- `plots/` — visualizations
- `README.md`
