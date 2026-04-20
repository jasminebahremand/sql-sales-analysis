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

## Key Visuals

### Monthly Revenue & Sales Volume Trends (2014–2016)
![Revenue Trend](plots/revenue_trend.png)

Revenue grew steadily from 2014 before accelerating sharply in mid-2016 — but volume and value growth diverged, suggesting average order size was increasing rather than new customer acquisition driving the trend.

### Sales Rep Allocation by Region
![Sales Rep Allocation](plots/sales_rep_allocation.png)

The Northeast holds the most accounts and the most reps — but Southeast and West manage comparable account loads with half the headcount, signaling a structural inefficiency.

### Revenue per Sales Rep by Region
![Revenue Per Rep](plots/revenue_per_rep.png)

Southeast and West reps generate nearly 2x the revenue per person compared to the Northeast ($645K and $593K vs $368K) — the strongest single indicator of resource misallocation in the dataset.

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

## How to Run
1. Load the Parch & Posey dataset into PostgreSQL
2. Open DBeaver and connect to your database
3. Run `analysis_queries.sql` top to bottom

---

## Data

**Parch & Posey Dataset:** https://www.kaggle.com/datasets/khalidbasalamah/sql-project-parch-and-posey-dataset-and-queries

Load into PostgreSQL or DBeaver before running queries.

---

## Files
- `analysis_queries.sql` — full analysis with inline comments
- `plots/` — visualizations
- `README.md`
