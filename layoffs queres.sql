CREATE DATABASE world_layoffs;

USE world_layoffs;

ALTER TABLE layoffs
ADD COLUMN id INT AUTO_INCREMENT PRIMARY KEY FIRST;

SELECT * FROM layoffs_staging;

-- 1- DATA CLEANING 
        -- Remove Duplicates
        -- Standardize the data 
        -- Handle NULL values or blank values
        -- Remove unnecessary columns or rows

-- Remove duplicates
CREATE TABLE layoffs_staging AS
SELECT *, 
    ROW_NUMBER() OVER(
        PARTITION BY company, location, industry, total_laid_off, 
                     percentage_laid_off, `date`, stage, country, funds_raised
    ) AS row_num
FROM layoffs;

-- Delete duplicate rows
DELETE 
FROM layoffs_staging
WHERE row_num > 1;

-- Standardizing data by removing extra spaces
SELECT company, TRIM(company) FROM layoffs_staging;

SET SQL_SAFE_UPDATES = 0; -- Disable safe update mode to allow updates and deletes

UPDATE layoffs_staging
SET company = TRIM(company),
    location = TRIM(location),
    industry = TRIM(industry),
    total_laid_off = TRIM(total_laid_off),
    `date` = TRIM(`date`),
    percentage_laid_off = TRIM(percentage_laid_off),
    stage = TRIM(stage),
    funds_raised = TRIM(funds_raised),
    country = TRIM(country);

SELECT DISTINCT company
FROM layoffs_staging
ORDER BY 1;

-- Check for similar company names (e.g., 'center' & 'centr')
SELECT DISTINCT *
FROM layoffs_staging
WHERE company LIKE 'cent%';

SELECT DISTINCT industry
FROM layoffs_staging
ORDER BY 1;
-- Industry data is clean

SELECT DISTINCT location
FROM layoffs_staging
ORDER BY 1;
-- Location data is clean

SELECT DISTINCT stage
FROM layoffs_staging
ORDER BY 1;
-- Stage data is clean

SELECT DISTINCT country
FROM layoffs_staging
ORDER BY 1;
-- Country data is clean

-- Clean data types
SHOW COLUMNS FROM layoffs_staging;
-- Date is text and percentage_laid_off is text - need to convert

UPDATE layoffs_staging
SET `date` = STR_TO_DATE(`date`, '%d/%m/%Y');

-- Convert date column to proper DATE type
ALTER TABLE layoffs_staging
MODIFY COLUMN `date` DATE;

-- Handle empty percentage values
UPDATE layoffs_staging
SET percentage_laid_off = '0.00'
WHERE percentage_laid_off = '' OR percentage_laid_off IS NULL;

ALTER TABLE layoffs_staging
MODIFY COLUMN percentage_laid_off DECIMAL(5, 2);

UPDATE layoffs_staging
SET percentage_laid_off = NULL
WHERE percentage_laid_off = '0.00';

ALTER TABLE layoffs_staging
MODIFY COLUMN total_laid_off INT;

ALTER TABLE layoffs_staging
MODIFY COLUMN funds_raised BIGINT;

-- Handle blank and NULL values
SELECT * FROM layoffs_staging 
WHERE industry = '' OR industry = NULL;
-- Industry column has one blank record

UPDATE layoffs_staging 
SET industry = 'other'
WHERE industry = '';

SELECT * FROM layoffs_staging 
WHERE percentage_laid_off IS NULL; -- 1000 rows are NULL

SELECT * FROM layoffs_staging 
WHERE funds_raised = ''; -- 421 rows are blank

UPDATE layoffs_staging 
SET funds_raised = NULL
WHERE funds_raised = '';

UPDATE layoffs_staging 
SET total_laid_off = NULL
WHERE total_laid_off = '';

-- Remove rows with no meaningful data
SELECT * FROM layoffs_staging
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL; -- Returns 629 rows

DELETE
FROM layoffs_staging
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

-- Remove temporary row_num column
ALTER TABLE layoffs_staging
DROP COLUMN row_num;

-- DATA ANALYSIS

-- Find maximum layoffs
SELECT MAX(total_laid_off), MAX(percentage_laid_off) FROM layoffs_staging; 
-- Max total laid off is 15000 and max percentage is 1

-- Companies that laid off all employees (100%)
SELECT * 
FROM layoffs_staging
WHERE percentage_laid_off = 1;

-- Largest single-day layoffs by company
SELECT 
    company,
    `date`,
    SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging
GROUP BY company, `date`
ORDER BY total_layoffs DESC;

-- Total layoffs by company across all years
SELECT 
    company,
    SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging
GROUP BY company
ORDER BY total_layoffs DESC;

-- Analysis period
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging;
-- Data spans from 11-3-2020 to 25-10-2024

-- Total layoffs by industry
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging
GROUP BY industry
ORDER BY 2 DESC;

-- Total layoffs by country
SELECT country, SUM(total_laid_off)
FROM layoffs_staging
GROUP BY country
ORDER BY 2 ASC;

-- Annual layoff totals
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging
GROUP BY YEAR(`date`)
ORDER BY 2;

-- Monthly layoff trends
SELECT SUBSTRING(`date`, 1,7) AS `month`, SUM(total_laid_off)
FROM layoffs_staging
GROUP BY `month`
ORDER BY 1;

-- Company layoffs by year
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging
GROUP BY company, YEAR(`date`)
ORDER BY company;

-- Ranked company layoffs by year
WITH company_year (company, years, total_laid_off) AS
(
    SELECT company, YEAR(`date`), SUM(total_laid_off)
    FROM layoffs_staging
    GROUP BY company, YEAR(`date`)
    ORDER BY company
),
company_year_rank AS (
    SELECT *,
        DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
    FROM company_year
    ORDER BY ranking ASC
)
SELECT * FROM company_year_rank;

-- Top 5 companies with most layoffs per year
WITH company_year (company, years, total_laid_off) AS
(
    SELECT company, YEAR(`date`), SUM(total_laid_off)
    FROM layoffs_staging
    GROUP BY company, YEAR(`date`)
    ORDER BY company
),
company_year_rank AS (
    SELECT *,
        DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
    FROM company_year
    ORDER BY years ASC
)
SELECT * FROM company_year_rank
WHERE ranking <= 5;

-- Company with most layoffs each year
WITH company_year (company, years, total_laid_off) AS
(
    SELECT company, YEAR(`date`), SUM(total_laid_off)
    FROM layoffs_staging
    GROUP BY company, YEAR(`date`)
    ORDER BY company
),
company_year_rank AS (
    SELECT *,
        DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
    FROM company_year
    ORDER BY years ASC
)
SELECT * FROM company_year_rank
WHERE ranking = 1;