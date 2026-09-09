-- ============================================================
-- 1. DATASET OVERVIEW
-- ============================================================

PRAGMA table_info(netflix_titles);

 SELECT *
 FROM netflix_titles
 LIMIT 10;
 
SELECT
  type,
  COUNT(*) AS count
FROM netflix_titles
GROUP BY type
ORDER BY count DESC;

SELECT
  COUNT(*) AS total_titles,
  SUM(
    CASE
      WHEN country IS NULL OR TRIM(country) = ''
      THEN 1 ELSE 0
    END
  ) AS missing_country_rows
FROM netflix_titles;


-- ============================================================
-- 2. CONTENT MIX OVER TIME
-- ============================================================
-- Yearly Netflix additions by content type and share
WITH yearly AS (
    SELECT
        CAST(SUBSTR(TRIM(date_added), -4) AS INTEGER) AS year_added,
        SUM(CASE WHEN type = 'Movie' THEN 1 ELSE 0 END) AS movies_added,
        SUM(CASE WHEN type = 'TV Show' THEN 1 ELSE 0 END) AS tv_added,
        COUNT(*) AS total_added
    FROM netflix_titles
    WHERE date_added IS NOT NULL
      AND TRIM(date_added) <> ''
    GROUP BY year_added
)
SELECT
    year_added,
    movies_added,
    tv_added,
    total_added,
    ROUND(100.0 * movies_added / total_added, 1) AS movie_share_pct,
    ROUND(100.0 * tv_added / total_added, 1) AS tv_share_pct
FROM yearly
WHERE year_added >= 2015
ORDER BY year_added;


-- ============================================================
-- 3. CATALOG FRESHNESS
-- ============================================================
-- Average lag between a title's release year and when it was added to Netflix
WITH title_age AS (
    SELECT
        CAST(SUBSTR(TRIM(date_added), -4) AS INTEGER) AS year_added,
        release_year,
        CAST(SUBSTR(TRIM(date_added), -4) AS INTEGER) - release_year AS years_old_when_added
    FROM netflix_titles
    WHERE date_added IS NOT NULL
      AND TRIM(date_added) <> ''
      AND release_year IS NOT NULL
)
SELECT
    year_added,
    COUNT(*) AS titles_added,
    ROUND(AVG(years_old_when_added), 1) AS avg_years_old_when_added
FROM title_age
WHERE year_added >= 2015
  AND years_old_when_added >= 0
GROUP BY year_added
ORDER BY year_added;

-- ============================================================
-- 4. INTERNATIONAL CONTENT ANALYSIS
-- ============================================================
-- Top content-producing countries by year
WITH RECURSIVE split_countries AS (
    SELECT
        show_id,
        CAST(SUBSTR(TRIM(date_added), -4) AS INTEGER) AS year_added,
        TRIM(
            CASE
                WHEN INSTR(country, ',') > 0
                THEN SUBSTR(country, 1, INSTR(country, ',') - 1)
                ELSE country
            END
        ) AS country_name,
        CASE
            WHEN INSTR(country, ',') > 0
            THEN SUBSTR(country, INSTR(country, ',') + 1)
            ELSE ''
        END AS remaining
    FROM netflix_titles
    WHERE country IS NOT NULL
      AND TRIM(country) <> ''
      AND date_added IS NOT NULL

    UNION ALL

    SELECT
        show_id,
        year_added,
        TRIM(
            CASE
                WHEN INSTR(remaining, ',') > 0
                THEN SUBSTR(remaining, 1, INSTR(remaining, ',') - 1)
                ELSE remaining
            END
        ),
        CASE
            WHEN INSTR(remaining, ',') > 0
            THEN SUBSTR(remaining, INSTR(remaining, ',') + 1)
            ELSE ''
        END
    FROM split_countries
    WHERE remaining <> ''
),
country_year_counts AS (
    SELECT
        year_added,
        country_name,
        COUNT(*) AS titles_added
    FROM split_countries
    WHERE year_added >= 2015
      AND country_name <> ''
    GROUP BY year_added, country_name
),
ranked AS (
    SELECT
        year_added,
        country_name,
        titles_added,
        RANK() OVER (
            PARTITION BY year_added
            ORDER BY titles_added DESC
        ) AS country_rank
    FROM country_year_counts
)
SELECT
    year_added,
    country_name,
    titles_added,
    country_rank
FROM ranked
WHERE country_rank <= 5
ORDER BY year_added, country_rank;


--Yearly contribution from major Netflix content-producing countries
WITH RECURSIVE split_countries AS (
    SELECT
        show_id,
        CAST(SUBSTR(TRIM(date_added), -4) AS INTEGER) AS year_added,
        TRIM(
            CASE
                WHEN INSTR(country, ',') > 0
                THEN SUBSTR(country, 1, INSTR(country, ',') - 1)
                ELSE country
            END
        ) AS country_name,
        CASE
            WHEN INSTR(country, ',') > 0
            THEN SUBSTR(country, INSTR(country, ',') + 1)
            ELSE ''
        END AS remaining
    FROM netflix_titles
    WHERE country IS NOT NULL
      AND TRIM(country) <> ''
      AND date_added IS NOT NULL

    UNION ALL

    SELECT
        show_id,
        year_added,
        TRIM(
            CASE
                WHEN INSTR(remaining, ',') > 0
                THEN SUBSTR(remaining, 1, INSTR(remaining, ',') - 1)
                ELSE remaining
            END
        ),
        CASE
            WHEN INSTR(remaining, ',') > 0
            THEN SUBSTR(remaining, INSTR(remaining, ',') + 1)
            ELSE ''
        END
    FROM split_countries
    WHERE remaining <> ''
)
SELECT
    year_added,
    SUM(CASE WHEN country_name = 'United States' THEN 1 ELSE 0 END) AS united_states,
    SUM(CASE WHEN country_name = 'India' THEN 1 ELSE 0 END) AS india,
    SUM(CASE WHEN country_name = 'United Kingdom' THEN 1 ELSE 0 END) AS united_kingdom,
    SUM(CASE WHEN country_name = 'Canada' THEN 1 ELSE 0 END) AS canada,
    SUM(CASE WHEN country_name = 'France' THEN 1 ELSE 0 END) AS france
FROM split_countries
WHERE year_added >= 2015
GROUP BY year_added
ORDER BY year_added;


-- ============================================================
-- 5. GENRE TRENDS
-- ============================================================
--Top Netflix genres by year
WITH RECURSIVE split_genres AS (
    SELECT
        show_id,
        CAST(SUBSTR(TRIM(date_added), -4) AS INTEGER) AS year_added,
        TRIM(
            CASE
                WHEN INSTR(listed_in, ',') > 0
                THEN SUBSTR(listed_in, 1, INSTR(listed_in, ',') - 1)
                ELSE listed_in
            END
        ) AS genre_name,
        CASE
            WHEN INSTR(listed_in, ',') > 0
            THEN SUBSTR(listed_in, INSTR(listed_in, ',') + 1)
            ELSE ''
        END AS remaining
    FROM netflix_titles
    WHERE listed_in IS NOT NULL
      AND TRIM(listed_in) <> ''
      AND date_added IS NOT NULL

    UNION ALL

    SELECT
        show_id,
        year_added,
        TRIM(
            CASE
                WHEN INSTR(remaining, ',') > 0
                THEN SUBSTR(remaining, 1, INSTR(remaining, ',') - 1)
                ELSE remaining
            END
        ),
        CASE
            WHEN INSTR(remaining, ',') > 0
            THEN SUBSTR(remaining, INSTR(remaining, ',') + 1)
            ELSE ''
        END
    FROM split_genres
    WHERE remaining <> ''
),
genre_year_counts AS (
    SELECT
        year_added,
        genre_name,
        COUNT(*) AS titles_added
    FROM split_genres
    WHERE year_added >= 2015
      AND genre_name <> ''
    GROUP BY year_added, genre_name
),
ranked AS (
    SELECT
        year_added,
        genre_name,
        titles_added,
        RANK() OVER (
            PARTITION BY year_added
            ORDER BY titles_added DESC
        ) AS genre_rank
    FROM genre_year_counts
)
SELECT
    year_added,
    genre_name,
    titles_added,
    genre_rank
FROM ranked
WHERE genre_rank <= 5
ORDER BY year_added, genre_rank;