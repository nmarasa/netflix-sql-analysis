# Netflix SQL Analysis

SQL analysis of 8,807 Netflix titles examining how the platform’s catalog changed over time across content type, international production, genre mix, and release-to-platform timing.

## Project Goal
Analyze Netflix’s catalog using SQL to identify meaningful trends in content strategy rather than only basic dataset summaries.

## Dataset
- Source: Kaggle — *Netflix Movies and TV Shows* by Shivam Bansal
- Table name: `netflix_titles`
- Records analyzed: **8,807 titles**

## Analysis
The project focuses on four main questions:

1. How did the balance between Movies and TV Shows change over time?
2. Did Netflix increasingly add newer or older catalog content?
3. How did international content contribution change by country?
4. Which genres became more prominent as the catalog expanded?

## Key Findings
- Movies remained the majority of yearly additions, but TV Shows increased from **25.0% of additions in 2018 to 33.7% in 2021**.
- The average gap between a title’s release year and the year it was added to Netflix increased from **1.3 years in 2015 to 5.8 years in 2021**, indicating a greater share of older catalog content in later years.
- The United States remained the largest content contributor, while countries including **India, the United Kingdom, Canada, and France** became increasingly significant contributors over time.
- International content grew substantially, with **International Movies** and **International TV Shows** becoming top-ranked genres by the mid-to-late 2010s.

## SQL Techniques Used
- `SELECT`, `WHERE`, `GROUP BY`, `ORDER BY`
- Aggregations: `COUNT`, `AVG`, `SUM`
- Conditional aggregation with `CASE`
- String cleaning and parsing with `TRIM`, `SUBSTR`, `INSTR`, and `CAST`
- Recursive CTEs to normalize comma-separated country and genre fields
- Window functions using `RANK() OVER`
- `PARTITION BY` for yearly ranking
- Time-based trend analysis

## Data Cleaning
Several fields required normalization before analysis:
- Multi-country values were split into one country per row using recursive CTEs
- Multi-genre values were similarly normalized for genre-level analysis
- Missing country values were identified and excluded where appropriate
- `date_added` values were parsed to extract the year for longitudinal analysis

## Files
- `netflix_queries.sql` — SQL queries for dataset overview, content mix, catalog freshness, international content trends, and genre analysis
- `README.md` — project overview, methods, and findings

## How to Run
1. Open **DB Browser for SQLite** or another SQLite-compatible tool
2. Import the Netflix CSV as a table named `netflix_titles`
3. Open `netflix_queries.sql`
4. Run the queries section by section
