SELECT * FROM layoffs_staging2; 

-- 1. Remove Duplicates 
-- 2, Standarize the data 
-- 3. Null Values or Blank Values 
-- 4. Remove any Columns


# Creating a staging table to work on instead of the raw data.
CREATE TABLE layoffs_staging
LIKE layoffs;

# insering all data from the raw data table.
INSERT layoffs_staging 
SELECT * FROM layoffs; 

SELECT * FROM layoffs_staging;

# 1. Removing duplicates

# creating a CTE to check duplicates, while partioning by every column in the table
# The reason for doing this is that this that we don't have a uinque column

WITH duplicate_CTE AS 
(
	SELECT *, 
	ROW_NUMBER() OVER ( 
	PARTITION BY company, industry, location,  total_laid_off, percentage_laid_off,
    `date`, stage, country, funds_raised_millions ) AS row_num
	FROM layoffs_staging
) 
SELECT * FROM duplicate_CTE
WHERE row_num > 1;


# Creating another staging table
CREATE TABLE `layoffs_staging2`(
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL, 
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO layoffs_staging2 
SELECT *, 
	ROW_NUMBER() OVER ( 
	PARTITION BY company, industry, location,  total_laid_off, percentage_laid_off,
    `date`, stage, country, funds_raised_millions ) AS row_num
FROM layoffs_staging;

# let's now delete these duplicates
DELETE
FROM layoffs_staging2
WHERE row_num > 1; 

# Now we're done with deleting duplicates. 


-- Standardizing data

# First, let's trim the company name
SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2 
SET company = TRIM(company); 

# let's check for the duplicate or similar names in the indusctry column
SELECT DISTINCT industry 
FROM layoffs_staging2
ORDER BY 1; 

# notcing that we have rows that have similar names with "crypto" & "crypto_currency"
# we will only make it crypto for all rows.
SELECT * 
FROM layoffs_staging2
WHERE industry LIKE 'Crypto';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

# if we check the country column we find that there are some rows 
# where the country name is United States. with a period at the end
# we need to remove this period.

SELECT *
FROM layoffs_staging2
WHERE Country LIKE 'United States%'
ORDER BY 1;

# we will remove it by doing a trim + trailing
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1; 

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';


# the date column has a text data type, we need to change it to date

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y') AS formatted_date
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

# Let's check it 
SELECT * FROM layoffs_staging2;

# let's change the date data type from text to DATE
ALTER TABLE layoffs_staging2 
MODIFY COLUMN `date` DATE;


-- Working with nulls and blank values

SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

SELECT * 
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;


UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

# we want to delete the data where total_laid_off & percentage_laid_off is null

DELETE 
FROM layoffs_staging2 
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

# at the end, we need to delete the row_num column we made before
ALTER TABLE layoffs_staging2
DROP column row_num; 

SELECT * FROM layoffs_staging2;