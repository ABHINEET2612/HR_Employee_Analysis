# HR_Employee_Analysis
SQL and Excel-based analysis of employee salary and workforce data (Chicago dataset)
# 📊 Employee Salary Analysis (SQL + Excel)

## 📌 Project Overview

This project presents a structured analysis of employee salary data from the City of Chicago. The objective was to demonstrate strong proficiency in **SQL and Excel**, focusing on data cleaning, transformation, querying, and dashboarding — without relying on Python or BI tools.

The analysis follows a complete workflow from raw data to business insights, emphasizing real-world data handling and decision-making support.

---

## 🎯 Objectives

* Analyze employee salary distribution across departments
* Identify high-paying roles and workforce concentration
* Understand organizational salary structure
* Build an interactive Excel dashboard for business insights
* Demonstrate core Data Analyst skills using SQL and Excel only

---

## 🛠️ Tools & Technologies

* **SQL (MySQL)** → Data querying, aggregation, and analysis
* **Excel (Power Query)** → Data cleaning and transformation
* **Excel (Pivot Tables & Charts)** → Dashboard creation

---

## 🔄 End-to-End Workflow

### 1. Data Cleaning (Excel Power Query)

* Removed inconsistencies and null values
* Standardized column formats
* Created derived columns for better analysis
* Prepared structured dataset for SQL ingestion

---

### 2. SQL Data Analysis

* Imported cleaned dataset into SQL database
* Performed:

  * Aggregations (SUM, AVG, COUNT)
  * Filtering and grouping
  * Department-level and role-level analysis
* Identified patterns in salary distribution and workforce structure

---

### 3. Excel Dashboarding

* Built a **4-sheet Excel dashboard structure**:

  * Raw Data
  * Analysis
  * Dashboard
  * Data Dictionary
* Used Pivot Tables and charts for visualization
* Designed dashboard for quick business interpretation

---

## 📊 Dashboard Preview

### 📍 Page 1

![Dashboard Page 1](images/EXCEL_DASH-PAGE%201.png)

### 📍 Page 2

![Dashboard Page 2](images/EXCEL_DASH-PAGE%202.png)

### 📍 Page 3

![Dashboard Page 3](images/EXCEL_DASH-PAGE%203.png)

### 📍 Page 4

![Dashboard Page 4](images/EXCEL_DASH-PAGE%204.png)

---

## ⚙️ Dataset & Complexity

- Dataset Size: ~32,000 employee records  
- Data Type: Static snapshot (no time dimension)  
- Key Fields: Employee Name, Department, Job Title, Salary  

### Technical Approach:
- Data cleaned and transformed using Excel Power Query  
- Loaded into MySQL using structured schema  
- SQL analysis performed using:
  - Aggregations (COUNT, AVG, SUM)  
  - Window functions (RANK, DENSE_RANK, ROW_NUMBER, NTILE, PERCENT_RANK)  
  - CTEs and subqueries  

### Key Constraint:
- As this is a point-in-time dataset, time-series analysis (e.g., LAG/LEAD trends) is not applicable

---
## 🧾 Sample SQL Queries

### Top 10 Highest Paying Job Titles
SELECT job_title,
       ROUND(AVG(salary), 2) AS avg_salary
FROM employees
GROUP BY job_title
ORDER BY avg_salary DESC
LIMIT 10;

### Department-wise Workforce & Salary Distribution
SELECT department,
       COUNT(*) AS employee_count,
       ROUND(AVG(salary), 2) AS avg_salary
FROM employees
GROUP BY department
ORDER BY employee_count DESC;

### Salary Ranking Within Departments
SELECT department,
       job_title,
       salary,
       RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS salary_rank
FROM employees;
---
## 🔍 Key Insights

- The dataset contains approximately 32,000 employees, providing a comprehensive view of workforce and salary distribution.  

- Salary distribution is highly uneven across departments, with certain departments showing significantly higher average salaries than others.  

- Job title plays a critical role in compensation, with top-ranked roles consistently appearing at the highest salary levels based on ranking functions.  

- Workforce distribution is concentrated in a limited number of departments, indicating imbalance in employee allocation across the organization.  

- Salary ranking within departments highlights a clear hierarchical pay structure, where a small subset of roles dominates the upper salary brackets.  

- Percentile-based analysis (PERCENT_RANK, NTILE) shows that a small percentage of employees fall into top salary tiers, indicating skewed compensation distribution.
---
## 💡 Business Recommendations

- Departments with significantly higher average salaries should be reviewed for budget efficiency and role justification.  

- High-paying job titles identified through ranking analysis should be evaluated for performance alignment and organizational impact.  

- Workforce concentration in specific departments suggests potential inefficiencies — resource allocation should be balanced across departments.  

- Salary distribution skew indicates the need for compensation benchmarking to ensure fairness and transparency.  

- Organizations can use percentile-based segmentation to identify top earners and design targeted retention or performance strategies.  
---
## 📌 Case Insight

### Salary Hierarchy Within Departments

Using window functions such as RANK() and PERCENT_RANK(), the analysis reveals a clear salary hierarchy within departments.

A small proportion of employees consistently occupy the top salary ranks, while the majority fall into mid-to-lower salary brackets.

This indicates that compensation is heavily influenced by role seniority and specialization, rather than being evenly distributed across employees.
---
## 📁 Project Structure

data/ → Dataset and source documentation
sql/ → SQL queries and analysis
excel/ → Cleaned dataset and Excel workbook with Dashboard inside
images/ → Dashboard screenshots

---

## 📂 Dataset Information

* **Source:** City of Chicago Open Data Portal
* **Dataset:** Current Employee Names, Salaries, and Position Titles

### ⚠️ Note:

The dataset link may occasionally return a **403 Forbidden error** due to access restrictions from the data portal.

### 🔗 Access Options:

**Option 1 (Primary):**
https://data.cityofchicago.org/Administration-Finance/Current-Employee-Names-Salaries-and-Position-Title/xzkq-xp2w/about_data

**Option 2 (If link doesn't work):**

* Open Google
* Search: **"Chicago employee salary dataset"**
* Click the official City of Chicago dataset page

Alternatively, users can directly use the cleaned dataset provided in this repository inside the `/data` folder OR can be viewed by opening link in new tab / copy-paste.

---

## 💡 Skills Demonstrated

* Data Cleaning & Transformation using Excel Power Query on ~32K records  
* Advanced SQL Querying (CTEs, Window Functions: RANK, DENSE_RANK, NTILE, PERCENT_RANK)  
* Data Aggregation & Analysis across departments, job titles, and salary distributions  
* Salary Ranking & Segmentation using analytical functions  
* Excel Dashboarding (multi-sheet structure: Raw Data, Analysis, Dashboard, Data Dictionary)  
* Translating structured data into actionable business insights  
* End-to-end analytical workflow: Cleaning → SQL Analysis → Visualization  

---

## 🚀 Business Impact

This analysis enables:

* Clear visibility into salary distribution across ~32,000 employees  
* Identification of departments with disproportionately high average salary levels  
* Detection of top-paying roles using ranking and percentile-based analysis  
* Understanding of workforce concentration across departments for better resource planning  
* Insight into hierarchical pay structure using salary ranking within departments  
* Data-driven support for compensation benchmarking and budgeting decisions  

---

## 📬 Contact

Open to Data Analyst opportunities — feel free to connect.
