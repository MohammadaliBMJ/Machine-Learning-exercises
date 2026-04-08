SELECT current_database();

-- First we inspect the data
SELECT * FROM diabetes LIMIT 20;

SELECT * FROM diabetes ORDER BY RANDOM() LIMIT 20;

SELECT column_name, is_nullable, data_type
FROM information_schema.columns
WHERE table_name = 'diabetes';

SELECT COUNT(*) FROM diabetes;

SELECT COUNT(DISTINCT "Age") FROM diabetes;

SELECT MAX("Age"), MIN("Age"), ROUND(AVG("Age"), 2)
FROM diabetes;

SELECT
    SUM(CASE WHEN "Pregnancies" IS NULL THEN 1 ELSE 0 END) AS missing_pregnancies,
    SUM(CASE WHEN "Glucose" IS NULL THEN 1 ELSE 0 END) AS missing_glucose,
    SUM(CASE WHEN "BloodPressure" IS NULL THEN 1 ELSE 0 END) AS missing_bloodpressure,
    SUM(CASE WHEN "SkinThickness" IS NULL THEN 1 ELSE 0 END) AS missing_skinthickness,
    SUM(CASE WHEN "Insulin" IS NULL THEN 1 ELSE 0 END) AS missing_insulin,
    SUM(CASE WHEN "BMI" IS NULL THEN 1 ELSE 0 END) AS missing_bmi,
    SUM(CASE WHEN "DiabetesPedigreeFunction" IS NULL THEN 1 ELSE 0 END) AS missing_DiabetesPedigreeFunction,
    SUM(CASE WHEN "Age" IS NULL THEN 1 ELSE 0 END) AS missing_age,
    SUM(CASE WHEN "Outcome" IS NULL THEN 1 ELSE 0 END) AS missing_outcome
FROM diabetes;


SELECT DISTINCT "Age", COUNT(*) FROM diabetes GROUP BY "Age"  ORDER BY "Age";