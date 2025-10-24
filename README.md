# 🧹 SQL Data Cleaning Project – Layoffs Dataset

This project was completed as the **Capstone Project** for the course  
🎓 **“Learn SQL: Beginner to Advanced” by Alex The Analyst**.  
It demonstrates my ability to perform comprehensive **data cleaning** operations using SQL.

---

## 📊 Project Overview

The goal of this project was to **clean and prepare a real-world layoffs dataset** for analysis.  
Raw data often contains duplicates, inconsistent text, null values, and incorrect data types —  
this project walks through the full process of transforming messy data into a reliable dataset ready for analysis.

---

## 🧠 Key Objectives

1. **Remove Duplicates**  
   - Created staging tables to preserve raw data.  
   - Used a CTE with `ROW_NUMBER()` to detect and remove duplicate rows.

2. **Standardize Data**  
   - Trimmed extra spaces in company names.  
   - Unified similar industry names (e.g., `Crypto`, `Crypto Currency`).  
   - Fixed country names (`United States.` → `United States`).  
   - Converted text-based date fields to proper `DATE` format.

3. **Handle Null and Blank Values**  
   - Replaced blank text values with `NULL`.  
   - Populated missing industry values using matching company records.  
   - Deleted rows where essential columns (`total_laid_off`, `percentage_laid_off`) were missing.

4. **Finalize the Clean Dataset**  
   - Dropped helper columns (`row_num`).  
   - Produced a fully cleaned table ready for analysis.

---

## 🛠️ Technologies Used

- **SQL** (MySQL)
- **Window Functions** – `ROW_NUMBER() OVER (PARTITION BY ...)`
- **Data Cleaning Techniques** – `TRIM()`, `STR_TO_DATE()`, `UPDATE`, `DELETE`, and `ALTER TABLE`
- **CTEs (Common Table Expressions)** for structured transformations

---

## 📂 Project Files

| File | Description |
|------|--------------|
| `data_cleaning.sql` | Main SQL script containing all cleaning steps |
| `layoffs.csv` *(optional)* | Raw data source used for the project |
| `README.md` | Project documentation |

---

## 📈 Results

After cleaning, the data:
- Contains **no duplicates**
- Has **standardized text formatting**
- Has **correct data types**
- Is **ready for analytical queries** such as layoffs by country, industry, or year

---

## 🚀 How to Run

1. Create and load the raw data table:
   sql
   CREATE TABLE layoffs (...);
   LOAD DATA INFILE 'layoffs_raw.csv' INTO TABLE layoffs;


2. Run the cleaning script:

   ```sql
   SOURCE data_cleaning.sql;
   ```

3. Verify cleaned data:

   ```sql
   SELECT * FROM layoffs_staging2;
   ```

---

## 🧩 Learning Outcome

Through this project, I practiced:

* Building **reliable data pipelines** using SQL
* Working with **CTEs** and **window functions**
* Performing **data standardization and cleaning** in a real-world workflow

---

## 👨‍💻 Author

**Abdullah Mohamed**
📚 Aspiring Software Engineer
📫 Connect on [LinkedIn](https://www.linkedin.com/) *(https://www.linkedin.com/in/abdullah-mohamed2210/)*
