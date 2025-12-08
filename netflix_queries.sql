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
  SUM(CASE WHEN country IS NULL OR TRIM(country) = '' THEN 1 ELSE 0 END) AS missing_country_rows
FROM netflix_titles;

SELECT COUNT(*) AS titles_after_2015
FROM netflix_titles
WHERE release_year > 2015;


SELECT country, COUNT(*) AS num_titles
FROM netflix_titles
WHERE country IS NOT NULL AND TRIM(country) <> ''
GROUP BY country
ORDER BY num_titles DESC
LIMIT 10;


SELECT rating, COUNT(*) AS num_titles
FROM netflix_titles
WHERE rating IS NOT NULL
  AND rating NOT LIKE '%min%'
GROUP BY rating
ORDER BY num_titles DESC;


SELECT
  title,
  CAST(REPLACE(duration, ' min', '') AS INTEGER) AS minutes
FROM netflix_titles
WHERE type = 'Movie' AND duration LIKE '%min%'
ORDER BY minutes DESC
LIMIT 10;


SELECT title, release_year, rating
FROM netflix_titles
WHERE LOWER(title) LIKE '%love%'
ORDER BY release_year DESC
LIMIT 20;


WITH RECURSIVE split AS (

  SELECT
    show_id,
    TRIM(country) AS remaining,
    TRIM(SUBSTR(country, 1, INSTR(country || ',', ',') - 1)) AS country_one
  FROM netflix_titles
  WHERE country IS NOT NULL AND TRIM(country) <> ''

  UNION ALL

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




