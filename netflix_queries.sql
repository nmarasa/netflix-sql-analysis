-- See the schema (column names/types)
PRAGMA table_info(netflix_titles);


--using first two rows to preview data
SELECT *
FROM netflix_titles
LIMIT 10;


-- Count number of Movies vs TV Shows
SELECT
  type,                 -- the category column
  COUNT(*) AS count     -- how many rows in each category
FROM netflix_titles
GROUP BY type           -- make one result row per 'type'
ORDER BY count DESC;    -- biggest first (nice to read)


-- How many total titles? How many are missing 'country'?
SELECT
  COUNT(*) AS total_titles,
  SUM(CASE WHEN country IS NULL OR TRIM(country) = '' THEN 1 ELSE 0 END) AS missing_country_rows
FROM netflix_titles;

-- How many titles released after 2015?
SELECT COUNT(*) AS titles_after_2015
FROM netflix_titles
WHERE release_year > 2015;


-- Simple top countries (note: rows with multiple countries count once for the whole cell)
SELECT country, COUNT(*) AS num_titles
FROM netflix_titles
WHERE country IS NOT NULL AND TRIM(country) <> ''
GROUP BY country
ORDER BY num_titles DESC
LIMIT 10;


-- Most common valid ratings
SELECT rating, COUNT(*) AS num_titles
FROM netflix_titles
WHERE rating IS NOT NULL
  AND rating NOT LIKE '%min%'   -- filter out bad data
GROUP BY rating
ORDER BY num_titles DESC;


-- Top 10 longest movies by minutes
SELECT
  title,
  CAST(REPLACE(duration, ' min', '') AS INTEGER) AS minutes
FROM netflix_titles
WHERE type = 'Movie' AND duration LIKE '%min%'
ORDER BY minutes DESC
LIMIT 10;


-- Titles containing the word 'love' (case-insensitive)
SELECT title, release_year, rating
FROM netflix_titles
WHERE LOWER(title) LIKE '%love%'
ORDER BY release_year DESC
LIMIT 20;


-- Normalize 'country' into one-country-per-row and get true top 10 countries
WITH RECURSIVE split AS (
  -- seed: start with full string and take the first comma chunk
  SELECT
    show_id,
    TRIM(country) AS remaining,
    TRIM(SUBSTR(country, 1, INSTR(country || ',', ',') - 1)) AS country_one
  FROM netflix_titles
  WHERE country IS NOT NULL AND TRIM(country) <> ''

  UNION ALL

  -- recurse: drop the first chunk and repeat until empty
  SELECT
    show_id,
    LTRIM(SUBSTR(remaining, INSTR(remaining || ',', ',') + 1)) AS remaining,
    TRIM(SUBSTR(LTRIM(SUBSTR(remaining, INSTR(remaining || ',', ',') + 1)),
                1, INSTR(LTRIM(SUBSTR(remaining, INSTR(remaining || ',', ',') + 1)) || ',', ',') - 1)) AS country_one
  FROM split
  WHERE remaining <> '' AND remaining IS NOT NULL
)
SELECT country_one AS country, COUNT(*) AS num_titles
FROM split
WHERE country_one <> ''
GROUP BY country_one
ORDER BY num_titles DESC
LIMIT 10;




