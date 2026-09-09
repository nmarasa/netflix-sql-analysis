# Netflix SQL Analysis

SQL analysis of 8,807 Netflix titles examining changes in catalog composition, international content production, genre mix, and release-to-platform timing.Goal: show clear, readable queries that answer practical questions with SQL.

## Dataset
- Source: Kaggle — *Netflix Movies and TV Shows* by Shivam Bansal  
- Link: (add the Kaggle link here)
- Note: I didn’t upload the CSV to this repo due to size/license. Download from Kaggle and import into SQLite as a table named `netflix_titles`.

## How to run
1. Open **DB Browser for SQLite** (or any SQLite tool).
2. Import the CSV as a table called `netflix_titles` (check “Column names in first line”).
3. Open `netflix_queries.sql`.
4. Run queries one at a time. They’re commented and self-contained.

## Skills Demo’d
- `SELECT`, `WHERE`, `GROUP BY`, `ORDER BY`, `LIMIT`
- Aggregations: `COUNT`, `AVG`, `SUM`
- Text search: `LIKE`, `LOWER`
- Data cleaning tricks: `TRIM`, `REPLACE`, `CAST`
- Bonus: splitting multi-country cells via a **recursive CTE** (SQLite)

## Example Insights (fill in with your results)
- Total titles: **xxxx**
- Movies vs TV Shows: **Movies = x, TV Shows = y**
- Most common ratings (top 5): **…**
- Titles after 2015: **…**
- Longest movies (top 3): **…**
- True top countries (after splitting multi-country cells): **…**

## Files
- `netflix_queries.sql` — all queries with comments.
- `README.md` — this file, instructions + results.

## Notes
- Some rows have messy data (e.g., durations appearing in `rating`). Queries include filters to keep results clean.
