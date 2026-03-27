SELECT * FROM raw_data_housing;

SELECT MAX(price), MIN(price) FROM raw_data_housing;

SELECT MAX(size_sqm), MIN(size_sqm) FROM raw_data_housing;

-- Create duplicate Table for data cleaning
CREATE TABLE clean_data_housing AS
SELECT * FROM raw_data_housing;

SELECT * FROM clean_data_housing;

-- Check for wrong values
SELECT * FROM clean_data_housing
WHERE size_sqm < 0
	OR age_year < 0
	OR price < 50000;

SELECT * FROM clean_data_housing
WHERE size_sqm < 0
	OR age_year < 0;

-- Clean the wrong values
DELETE FROM clean_data_housing WHERE size_sqm < 0 OR
(size_sqm < 0 AND age_year < 0);

-- Still 1822 rows with negative age values. set them to 0
SELECT * FROM clean_data_housing WHERE age_year < 0;

UPDATE clean_data_housing SET age_year = 0
WHERE age_year < 0;

-- Check for wrong values for elevator
SELECT * FROM clean_data_housing
WHERE elevator_bool NOT IN (true, false) OR elevator_bool IS NULL;

-- Suspicious values for size_sqm
SELECT * FROM clean_data_housing
WHERE size_sqm < 5;

DELETE FROM clean_data_housing WHERE size_sqm < 5;

-- Suspicious values for size_sqm and rooms_num and bathrooms_num
SELECT * FROM clean_data_housing
WHERE (size_sqm >= 5 AND size_sqm < 20) 
AND rooms_num > 2;

-- Delete the rows
DELETE FROM clean_data_housing
WHERE (size_sqm >= 5 AND size_sqm < 20) AND rooms_num > 2;

-- -- Suspicious values for size_sqm and bathrooms_num and bathrooms_num
SELECT * FROM clean_data_housing
WHERE size_sqm < 25 AND bathrooms_num > 2;

-- Delete the rows
DELETE FROM clean_data_housing
WHERE size_sqm < 25 AND bathrooms_num > 2;

-- Rate combinations. We keep them
SELECT * FROM clean_data_housing
WHERE size_sqm < 20 AND price > 200000;

-- unusual values for rooms_num
SELECT * FROM clean_data_housing
WHERE rooms_num > 10;

-- Delete them
DELETE FROM clean_data_housing
WHERE rooms_num > 10;

-- Extreme values for bathrooms_num
SELECT * FROM clean_data_housing
WHERE bathrooms_num > 6;

-- Delete
DELETE FROM clean_data_housing
WHERE bathrooms_num > 6;

-- Extreme values for age_year. Already set age_year < 0 to 0
SELECT * FROM clean_data_housing
WHERE age_year > 100 OR age_year < 0;

-- Extreme values for city_center_distance_km
SELECT * FROM clean_data_housing
WHERE city_center_distance_km > 30;

-- Extreme values for price
SELECT * FROM clean_data_housing
WHERE price < 50000 OR price > 5000000;

-- Checking for price extreme values with INTERQUARTILE RANGE(IQR)
WITH IQR AS(
SELECT
	percentile_cont(0.25) WITHIN GROUP (ORDER BY price) AS Q1,
	percentile_cont(0.75) WITHIN GROUP (ORDER BY price) AS Q3
FROM clean_data_housing
)
SELECT clean_data_housing.* FROM clean_data_housing, IQR
WHERE price < Q1 - (Q3 - Q1) * 1.5
	OR price > Q3 + (Q3 - Q1) * 1.5;

-- There are houses smaller than 10 m2 and having 2 or more rooms
SELECT * FROM clean_data_housing
WHERE size_sqm < 10 AND rooms_num > 1;

DELETE FROM clean_data_housing
WHERE size_sqm < 10 AND rooms_num > 1;

-- Check for NULL
SELECT * FROM clean_data_housing
WHERE size_sqm IS NULL
	OR rooms_num IS NULL
	OR bathrooms_num IS NULL
	OR age_year IS NULL
	OR city_center_distance_km IS NULL
	OR elevator_bool IS NULL
	OR floor IS NULL
	OR price IS NULL;

-- Duplicate rows
SELECT size_sqm,
rooms_num,
bathrooms_num, 
age_year, 
city_center_distance_km, 
elevator_bool, 
floor, 
price,
COUNT(*) AS counter
FROM clean_data_housing
GROUP BY size_sqm, 
rooms_num, 
bathrooms_num, 
age_year, 
city_center_distance_km, 
elevator_bool, 
floor, 
price
HAVING COUNT(*) > 1;

-- Unusual combination of Size and Number of the Rooms. We keep them
SELECT * FROM clean_data_housing
WHERE size_sqm < 60 AND rooms_num > 5;

-- Unusual combination of Size and Number of Bathrooms. We keep them
SELECT * FROM clean_data_housing
WHERE size_sqm < 60 AND bathrooms_num > 4;

-- Size and Price. Too Cheap
SELECT * FROM clean_data_housing
WHERE price < size_sqm * 1000;

-- Size and Price. Too Expensive
SELECT * FROM clean_data_housing
WHERE price > size_sqm * 15000;

/* let's consider the minimum size of one room to be 6 m^2. So each house
should still have some extra space besides the rooms. */
SELECT * FROM clean_data_housing
WHERE size_sqm - (rooms_num * 6) < 2;

DELETE FROM clean_data_housing
WHERE size_sqm - (rooms_num * 6) < 2;

-- Just a practice for views in SQL
CREATE VIEW clean_data AS
SELECT * FROM raw_data_housing
WHERE size_sqm - (rooms_num * 6) > 2
	AND rooms_num < 10
	AND age_year >= 0
	AND bathrooms_num < 7;
	
SELECT COUNT(*) AS new_column FROM raw_data_housing;

-- Statistics from the clean table
SELECT COUNT(*) AS total_rows,
	SUM(CASE WHEN size_sqm < 10 THEN 1 ELSE 0 END) AS small_house,
	SUM(CASE WHEN rooms_num = 0 THEN 1 ELSE 0 END) AS studio,
	SUM(CASE WHEN age_year = 0 THEN 1 ELSE 0 END) AS new_house,
	SUM(CASE WHEN price < 100000 THEN 1 ELSE 0 END) AS cheap
FROM clean_data_housing;

-- Common Table Expression practice on raw_data_housing
WITH impossible_size AS (
	SELECT * FROM raw_data_housing
	WHERE size_sqm - (rooms_num * 6) < 2
),
many_rooms AS (
	SELECT * FROM raw_data_housing
	WHERE rooms_num > 10
),
impossible_age AS (
	SELECT * FROM raw_data_housing
	WHERE age_year < 0
)
SELECT
	(SELECT COUNT(*) FROM impossible_size) AS impossible_size,
	(SELECT COUNT(*) FROM many_rooms) AS many_rooms,
	(SELECT COUNT(*) FROM impossible_age) AS impossible_age;

-- Same results different way
SELECT COUNT(*) AS total,
	COUNT(*) FILTER (WHERE size_sqm - (rooms_num * 6) < 2) AS impossible_size,
	COUNT(*) FILTER (WHERE rooms_num > 10) AS many_rooms,
	COUNT(*) FILTER (WHERE age_year < 0) AS impossible_age
FROM raw_data_housing;

-- Same results different way
SELECT COUNT(*) AS total,
	SUM(CASE WHEN size_sqm - (rooms_num * 6) < 2 THEN 1 ELSE 0 END) AS impossible_size,
	SUM(CASE WHEN rooms_num > 10 THEN 1 ELSE 0 END) AS many_rooms,
	SUM(CASE WHEN age_year < 0 THEN 1 ELSE 0 END) AS impossible_age
FROM raw_data_housing;

-- Limit decimal precision
UPDATE clean_data_housing
SET size_sqm = ROUND(size_sqm::numeric, 1),
	city_center_distance_km = ROUND(city_center_distance_km::numeric, 2);

