# World Layoffs Analysis Project

## 📊 Project Overview
This project analyzes global company layoffs data from March 2020 to October 2024. The analysis focuses on understanding layoff patterns across different companies, industries, and countries using MySQL for data analysis.

## 🔍 Key Findings

### Timeline Analysis
- Analysis Period: March 11, 2020 - October 25, 2024
- Yearly Layoff Trends:
  - 2023: 264,220 employees (highest)
  - 2022: 164,319 employees
  - 2024: 141,467 employees
  - 2020: 80,998 employees
  - 2021: 15,823 employees (lowest)

### Company-Specific Insights

#### Top Companies by Total Layoffs (2020-2024)
1. Amazon: 27,840 employees
2. Meta: 21,000 employees
3. Intel: 16,057 employees
4. Microsoft: 14,708 employees
5. Tesla: 14,500 employees

#### Yearly Leaders in Layoffs
- 2024: Intel (15,062 employees)
- 2023: Amazon (17,260 employees)
- 2022: Meta (11,000 employees)
- 2021: Bytedance (3,600 employees)
- 2020: Uber (7,525 employees)

### Industry Analysis
Top 5 Industries with Highest Layoffs:
1. Retail: 71,703 employees
2. Consumer: 70,941 employees
3. Other: 60,711 employees
4. Transportation: 60,048 employees
5. Hardware: 53,870 employees

### Geographical Distribution
Top 5 Countries by Layoff Numbers:
1. United States: 449,229 employees
2. India: 55,889 employees
3. Germany: 28,153 employees
4. United Kingdom: 20,019 employees
5. Netherlands: 18,705 employees

Lowest layoff numbers were recorded in Luxembourg and Ukraine.

## 📝 Data Cleaning Process
The analysis included several data cleaning steps:

1. Duplicate Removal
   - Created staging table with row numbers for duplicate identification
   - Removed exact duplicate entries

2. Data Standardization
   - Trimmed whitespace from all text fields
   - Standardized company names
   - Verified and cleaned industry categories
   - Normalized location and country data

3. Data Type Conversion
   - Converted date strings to proper DATE format
   - Changed percentage_laid_off to DECIMAL(5,2)
   - Modified total_laid_off to INTEGER
   - Converted funds_raised to BIGINT

4. NULL Value Handling
   - Replaced empty industry values with 'other'
   - Properly handled NULL values in percentage_laid_off
   - Cleaned up empty funds_raised entries
   - Removed rows with no meaningful data (NULL in both total_laid_off and percentage_laid_off)

## 📊 Key Performance Indicators (KPIs)

1. **Total Layoff Volume**
   - Tracks the absolute number of employees laid off
   - Measured at company, industry, and country levels

2. **Temporal Trends**
   - Monthly and yearly layoff patterns
   - Identification of peak layoff periods

3. **Geographic Impact**
   - Country-wise distribution of layoffs
   - Regional concentration of workforce reduction

4. **Industry Impact**
   - Sector-wise analysis of layoffs
   - Identification of most affected industries

5. **Company-Specific Metrics**
   - Individual company layoff patterns
   - Percentage of workforce reduction
   - Single-day maximum layoffs

## 💡 Interesting Insights

1. **Year-over-Year Trends**
   - 2023 saw the highest number of layoffs, indicating a significant shift in workforce management
   - 2021 had the lowest number of layoffs, suggesting a period of relative stability

2. **Industry Patterns**
   - Retail and Consumer sectors were most affected
   - Traditional tech hardware companies showed significant layoffs

3. **Geographic Distribution**
   - US companies dominated the layoffs landscape
   - Significant impact on Indian tech workforce
   - European companies showed more moderate layoff numbers

4. **Company Behavior**
   - Some companies implemented multiple rounds of layoffs
   - Large tech companies contributed significantly to total layoff numbers
   - Several companies had 100% layoffs, indicating complete shutdowns or major restructuring

## 🛠 Technical Implementation
- Database: MySQL
- Data Processing: SQL queries and stored procedures
- Analysis Tools: MySQL Workbench

## 🔄 Usage
To use this analysis:
1. Create the database using the provided SQL scripts
2. Import the layoffs data
3. Run the analysis queries in sequence
4. Modify the queries as needed for specific analysis requirements

---
*Note: This analysis is based on available data until October 2024 and should be updated regularly for current insights.*
