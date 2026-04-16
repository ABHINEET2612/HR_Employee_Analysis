CREATE DATABASE hr_project ;
USE hr_project;

CREATE TABLE employee_data (
	emp_name TEXT,
    job_title TEXT,
    department TEXT,
	full_or_part_time TEXT,
    salary_or_hourly TEXT,
    typical_hours DOUBLE,
    annual_salary DOUBLE,
    hourly_rate DOUBLE,
    final_pay DOUBLE,
    job_title_clean TEXT,
    annualized_pay DOUBLE
);

DROP TABLE employee_data;

-- ------------------------------------------- SANITY CHECK  ------------------------------------------

SELECT *
FROM employee_data   # department are still in ALL CAPS 
LIMIT 50;

/*
 ==============================================================================================================================================================
																	A N A L Y S I S 
 ==============================================================================================================================================================
*/

-- ---------------------------------------------------- HIGHEST PAID EMPLOYEES --------------------------------------------
SELECT 
	emp_name, 
    job_title, 
    department, 
    annualized_pay
FROM employee_data
ORDER BY annualized_pay DESC
LIMIT 10;
/*
- The highest-paid employees are senior leadership roles such as commissioners and department heads, 
  indicating a top-heavy salary structure concentrated in executive positions
*/

-- ---------------------------------------------------- TOP EMPLOYEES per DEPARTMENT ----------------------------------------
SELECT *
FROM(
SELECT
	emp_name,
    department,
    job_title,
    annualized_pay,
    RANK() OVER (PARTITION BY department ORDER BY annualized_pay DESC ) AS DEPT_RANK
FROM employee_data) AS ranked
WHERE dept_rank <=5;
/*
- Top earners across departments are consistently leadership roles (Commissioners, Directors, Chiefs), confirming a strong hierarchical pay structure.
- Several departments show tied ranks, indicating standardized salaries for similar senior positions. 
- Pay distribution at the top is relatively uniform across departments, suggesting consistent compensation policies for executive roles.
*/

-- --------------------------------------------------- AVERAGE SALARY per DEPARTMENT -----------------------------------------
SELECT 
    department,
    ROUND(AVG(annualized_pay),0) AS AVG_SALARY,
    COUNT(*) AS total_employee
FROM employee_data
GROUP BY department
ORDER BY AVG_SALARY DESC;
/*
- Departments like Buildings, Technology, and Fire have the highest average salaries, indicating a concentration of high-paying technical and leadership roles. 
- Larger departments such as POLICE and FIRE maintain HIGH AVERAGES despite workforce size, showing strong overall compensation structures. 
- In contrast, departments like Family & Support Services and Library have lower averages, reflecting more operational or support-focused roles.
*/

-- --------------------------------------------------- DEPARTMENT-WISE SALARY DISTRIBUTION  -------------------------------------
SELECT
	department,
    ROUND(MIN(annualized_pay),0) AS MINIMUM_SALARY,
    ROUND(MAX(annualized_pay),0) AS MAXIMUM_SALARY,
    ROUND(AVG(annualized_pay),0) AS AVG_SALARY
FROM employee_data
GROUP BY department
ORDER BY MAXIMUM_SALARY DESC;
/*
- There is a SIGNIFICANT SALARY GAP within most departments, with very LOW MINIMUMS and extremely HIGH MAXIMUMS, indicating wide pay dispersion. 
- Departments like AVIATION and POLICE show especially large ranges, suggesting a mix of ENTRY-level and top EXECUTIVE roles. 
- This highlights strong pay inequality within departments, with compensation HEAVILY SKEWED toward HIGHER POSITIONS.
*/

-- ----------------------------------------------------- DEPARMENT-WISE SALARY GAP ANALYSIS ---------------------------------------------
SELECT
	department,
    ROUND(MAX(annualized_pay)-MIN(annualized_pay),0) AS SALARY_GAP
FROM employee_data
GROUP BY department
ORDER BY SALARY_GAP DESC;
/*
- Departments like AVIATION and POLICE show the HIGHEST SALARY GAP, indicating significant pay inequality between entry-level and top executive roles. 
- Large gaps suggest a wide hierarchy with diverse job levels within the same department. 
- Smaller gaps in other departments indicate more uniform pay structures with less variation in roles.
*/

-- --------------------------------------------------- TOP-PAYED DEPARTMENTS (TOTAL SPEND) ---------------------------------------------------- 
SELECT
	department,
    ROUND(SUM(annualized_pay),0) AS TOTAL_SALARY_SPEND
FROM employee_data
GROUP BY department
ORDER BY TOTAL_SALARY_SPEND DESC;
/*
- Departments like PLOICE and FIRE account for the HIGHEST TOTAL SALARY SPEND, driven by both large workforce size and relatively high average salaries. 
- Infrastructure-heavy departments (Water, Streets, Aviation) also show significant expenditure, reflecting operational scale. 
- Smaller departments contribute minimally, indicating budget concentration in core public service areas.
*/

-- -------------------------------------------------- EMPLOYEES WITH DUPLICATE SALARY IN EACH DEPARTMENT ---------------------------------------
SELECT
	emp_name,
    department,
    annualized_pay,
    RANK() OVER(PARTITION BY department ORDER BY annualized_pay DESC) AS EMP_RANK,
    DENSE_RANK() OVER(PARTITION BY department ORDER BY annualized_pay DESC) AS EMP_DENSE_RANK,
    ROW_NUMBER() OVER(PARTITION BY department ORDER BY annualized_pay DESC) AS EMP_ROW_NUM
FROM employee_data
WHERE department = 'CHICAGO DEPARTMENT OF AVIATION';
/*
- Employees with identical salaries receive the same rank using RANK() and DENSE_RANK(), while ROW_NUMBER() assigns unique sequential values.
- RANK() introduces gaps after ties, whereas DENSE_RANK() maintains continuous ranking.
- This highlights how different ranking functions impact ordering and grouping in salary-based analysis.
*/

-- -------------------------------------------------- WORKFORCE COMPOSITION ---------------------------------------------------------------------
SELECT
	CASE
		WHEN full_or_part_time = 'F' THEN 'FULL-TIME'
        WHEN full_or_part_time = 'P' THEN 'PART-TIME'
        ELSE 'UNKNOWN'
	END AS EMPLOYMENT_TYPE,
	COUNT(full_or_part_time) AS TOTAL_EMPs,
    ROUND(AVG(annualized_pay),0) AS AVG_PAY
FROM employee_data
GROUP BY full_or_part_time;
/*
- The Chicago city workforce is heavily full-time — 96.8% of employees (30,807) are full-time vs 3.2% part-time (1,005). 
- The average annualized pay gap is significant: full-time employees earn $113,459 on average compared to $20,154 for part-time — a 5.6x difference.
- This suggests part-time roles are concentrated in lower-pay, likely operational or seasonal positions.
*/

-- ------------------------------------------------- SALARY vs HOURLY EMPLOYEE BREAKDOWN ----------------------------------------------------------
SELECT
	CASE
		WHEN salary_or_hourly = 'Salary' THEN 'SALARY'
		WHEN salary_or_hourly = 'Hourly' THEN 'HOURLY'
		ELSE 'UNKNOWN'
	END AS EMP_BAND,
	COUNT(salary_or_hourly) AS TOTAL_EMP,
	ROUND(AVG(annualized_pay),0) AS AVG_PAY
FROM employee_data
GROUP BY salary_or_hourly
ORDER BY TOTAL_EMP DESC; 
/*
- The workforce is predominantly salaried — 78.1% of employees (24,837) are on salary compared to 21.9% hourly (6,975).
- The average annualized pay gap is notable: salaried employees earn $115,566 on average vs $92,512 for hourly employees — a ~1.25x difference.
- This suggests salaried roles are likely concentrated in higher-skilled or managerial positions,  
  while hourly roles may represent operational or support functions with comparatively lower compensation.
*/

-- --------------------------------------------------- FULL-TIME vs PART-TIME per DEPARTMENT -------------------------------------------------------
SELECT 
	department,
    SUM(CASE WHEN full_or_part_time = 'F' THEN 1 ELSE 0 END) AS FULLTIME,
    SUM(CASE WHEN full_or_part_time = 'P' THEN 1 ELSE 0 END) AS PARTTIME,
    COUNT(*) AS TOTAL_EMPS,
    ROUND(AVG(annualized_pay),0) AS AVG_PAY
FROM employee_data
GROUP BY department
ORDER BY TOTAL_EMPS DESC;
/*
- The workforce across departments is overwhelmingly full-time, with most departments having near 100% full-time employees, 
	especially large ones like Police (12,256/12,294) and Fire (100% full-time).
- Part-time presence is concentrated in specific departments such as Public Library (26.5%), Family & Support Services (41.5%), 
	and Emergency Management (19.5%), indicating reliance on flexible or service-based roles.
- Despite smaller headcounts, departments like Buildings ($132,694) and Technology & Innovation ($131,948) have the highest average pay, 
	suggesting more specialized and high-skill roles compared to larger operational departments.
*/

-- ---------------------------------------------------- EMPLOYEE PAY-BAND ------------------------------------------------------------------------
SELECT 
	emp_name,
    department,
    annualized_pay,
    CASE
		WHEN annualized_pay < 50000 THEN 'ENTRY'
        WHEN annualized_pay BETWEEN 50000 AND 100000 THEN 'MID'
        WHEN annualized_pay BETWEEN 100000 AND 200000 THEN 'SENIOR'
        ELSE 'EXECUTIVE'
	END AS PAY_BAND
FROM employee_data;
/*
- The Chicago workforce is leans heavily toward higher experience levels, with the vast majority of employees falling into the Senior pay band. 
	Only a small fraction of employees appear in the Entry and Mid categories, indicating a workforce dominated by experienced personnel.
    
- Senior-level employees are particularly concentrated in core operational departments such as the Chicago Police Department and Chicago Fire Department, 
	suggesting that these departments rely heavily on experienced staff, likely due to the critical nature of their roles.

- The presence of very few Entry-level employees and occasional Executive roles highlights a top-heavy structure, 
	where career progression appears to move quickly into Senior bands, or hiring is focused on experienced professionals rather than fresh entrants.

- Additionally, the wide salary spread within the Senior band (ranging roughly from ~$100K to $160K+) indicates pay variation within the same band, 
	likely driven by tenure, role specialization, or departmental differences.
*/

-- ---------------------------------------------------- PAY-BAND EMPLOYEES COUNT per DEPARTMENT ------------------------------------------------------------
WITH pay_band_cte AS(
	SELECT
		department,
        CASE
			WHEN annualized_pay < 50000 THEN 'ENTRY'
            WHEN annualized_pay BETWEEN 50000 AND 100000 THEN 'MID'
            WHEN annualized_pay BETWEEN 100000 AND 200000 THEN 'SENIOR'
            ELSE 'EXECUTIVE'
		END AS PAY_BAND
	FROM employee_data
)
SELECT 
	department,
    SUM(CASE WHEN PAY_BAND = 'ENRTY' THEN 1 ELSE 0 END) AS ENTRY_COUNT,
    SUM(CASE WHEN PAY_BAND = 'MID' THEN 1 ELSE 0 END) AS MID_COUNT,
    SUM(CASE WHEN PAY_BAND = 'SENIOR' THEN 1 ELSE 0 END) AS SENIOR_COUNT,
    SUM(CASE WHEN PAY_BAND = 'EXECUTIVE' THEN 1 ELSE 0 END) AS EXECUTIVE_COUNT,
    COUNT(*) AS TOTAL_EMPS
FROM pay_band_cte
GROUP BY department
ORDER BY TOTAL_EMPS DESC;
/*
- The workforce is heavily concentrated in Mid and Senior pay bands, 
  with Senior roles dominating across major departments like Police, Fire, and Water Management. 

- Entry-level counts appear as zero due to pay band classification thresholds, 
  not absence of such roles in the dataset. Executive positions remain minimal,
  indicating a narrow leadership layer compared to the overall workforce.
*/

-- ------------------------------------------------- EMPLOYEES EARNING ABOVE DEPARTMENT AVERAGE ---------------------------------------------------------
SELECT 	
	ED.emp_name,
    ED.department,
    ED.annualized_pay
FROM employee_data AS ED
WHERE annualized_pay >(
	SELECT AVG(annualized_pay)
    FROM employee_data
    WHERE department = ED.department
);
                      -- -------- The above Correlated subquery version works, but is slow (runs AVG per row) -------------
                      -- -------- Optimized version of the above query is written below -----------------------------------
WITH dept_avg AS(
	SELECT
		department,
        AVG(annualized_pay) AS avg_salary
	FROM employee_data
    GROUP BY department
)
SELECT
	ED.emp_name,
    ED.department,
    ED.annualized_pay,
    ROUND(DA.avg_salary,0) AS dept_avg_salary
FROM employee_data AS ED
JOIN dept_avg AS DA
	ON DA.department = ED.department
WHERE ED.annualized_pay > DA.AVG_SALARY AND ED.department = 'CHICAGO DEPARTMENT OF AVIATION'
ORDER BY ED.annualized_pay DESC; 
/*
- Employees earning above their department average are concentrated in senior 
  and specialist roles — confirming that pay inequality exists within departments, 
  not just across them.
  
- In Chicago Department of Aviation, the top earner 
  (MC MURRAY, MICHAEL J) at $350,000 earns nearly 3.6x the department average 
  of $97,530 — a significant outlier suggesting executive-level compensation 
  far exceeds peers.
  
- The majority of above-average earners sit in a tight band 
  just above the department mean, indicating a small but highly paid leadership 
  tier driving up averages across most departments.
*/

-- ------------------------------------------------- AVERAGE PAY EXCEEDING CITY-WIDE AVERAGE [per DEPARTMENT] ---------------------------------------------------------
SELECT
	department,
    ROUND(AVG(annualized_pay),0) AS dept_avg,
    ROUND(
		(SELECT AVG(annualized_pay) FROM employee_data),0) AS citywide_avg
FROM employee_data OG
GROUP BY department
HAVING dept_avg > (
	SELECT 
		AVG(annualized_pay) 
	FROM employee_data
    
)
ORDER BY dept_avg DESC;
/*
- 18 of 38 departments exceed the citywide average of $110,511, indicating 
  that above-average pay is concentrated in roughly half the city's workforce.

- Department of Buildings leads at $132,694 — 20% above citywide average — 
  followed by Technology & Innovation ($131,948) and Fire ($129,682).
  
- These results suggest pay inequality exists at the departmental level, 
  with technical, infrastructure, and public safety departments consistently 
  compensating above the city benchmark.
*/

-- ------------------------------------------------- CITY-WIDE COMMON JOB TITLE ---------------------------------------------------------
SELECT 
	job_title_clean,
	COUNT(*) AS EMP_per_TITLE  /* Using column name - job_title_clean - extracts only the first word - Too Granular */
FROM employee_data
GROUP BY job_title_clean
ORDER BY EMP_per_TITLE DESC;
                            -- ----------------------- Using column name job_title[Original]-BELOW ----------------------
    
SELECT 
	job_title,
	COUNT(*) AS EMP_per_TITLE  
FROM employee_data
GROUP BY job_title
ORDER BY EMP_per_TITLE DESC
LIMIT 10;
/*
- Police Officer is the single most common job title in Chicago city government, 
  accounting for 7,968 employees — nearly 25% of the entire workforce.

- The top 3 titles (Police Officer, Firefighter-EMT, Sergeant) are all public safety roles, 
  confirming that Chicago's largest workforce investment is in emergency and law 
  enforcement services.
  
- The first non-public-safety role appears at rank 4 
  (Motor Truck Driver — 908), highlighting a clear divide between the city's 
  core service priorities and operational support functions.
*/

-- ------------------------------------------------- HIGHEST PAYING JOB TITLES [MIN. 10 EMPLOYEES] ---------------------------------------------------------
SELECT
	job_title,
    ROUND(AVG(annualized_pay),0) AS AVG_PAY,
    COUNT(*) AS EMP_per_TITLE
FROM employee_data
GROUP BY job_title
HAVING EMP_per_TITLE >= 10 
ORDER BY AVG_PAY DESC
LIMIT 15;
/*
- The highest paying job titles in Chicago city government are dominated by 
  senior public safety leadership — Battalion Chief-Paramedic leads at $204,654, 
  followed closely by Deputy Chief ($201,048) and Battalion Chief-EMT ($197,645). 

- Notably, Captain-EMT commands $178,129 across 172 employees, making it the 
  largest high-paying role by headcount. 

- All 15 titles are either senior public safety commanders or legal counsel roles — confirming that the city's top 
  compensation is concentrated entirely in emergency services leadership and law, 
  with no technical or administrative roles appearing in the top tier.
*/

-- -------------------------------------------------- PAY-GAP BETWEEN EMPLOYEES --------------------------------------------------------------------------
SELECT
	emp_name,
    department,
    job_title,
    ROUND(annualized_pay,0) AS annual_pay,
	ROUND(LAG(annualized_pay) OVER (PARTITION BY department
    ORDER BY annualized_pay DESC ),0) AS prev_emp_pay,
    ROUND(annualized_pay - LAG(annualized_pay) OVER(
		PARTITION BY department
        ORDER BY annualized_pay DESC),0) AS pay_gap
FROM employee_data;			
/*
- The salary structure within Chicago city departments shows a clear hierarchical pay distribution with sharp drop-offs at the top levels. 
  In each department, the highest-paid employee stands significantly above the rest,
  with the first few pay gaps being the largest — indicating EXECUTIVE or leadership roles commanding premium compensation.
  
- As we move down the salary ladder, the pay gaps become progressively smaller and often stabilize, 
  suggesting standardized pay bands for MID and ENTRY-level employees. 
  In several cases, identical salaries result in zero pay gaps, highlighting structured compensation tiers or unionized pay scales.
  
- Overall, this pattern confirms that pay inequality is most pronounced at the top, while the majority of employees fall 
  into tightly grouped salary brackets — reflecting a top-heavy compensation model with controlled mid-level pay variation.
*/

-- -------------------------------------------------- SALARY PERCENTILE RANKING --------------------------------------------------------------------------
SELECT 
	emp_name,
    department,
    job_title,
    ROUND(annualized_pay,0) AS annual_pay,
    CASE NTILE(4) OVER (ORDER BY annualized_pay)
		WHEN 1 THEN 'BOTTOM 25%'
        WHEN 2 THEN 'LOWER MID 25%'
        WHEN 3 THEN 'UPPER MID 25%'
        WHEN 4 THEN 'UPPER 25%'
	END AS pay_quartile_label,
    ROUND(PERCENT_RANK() OVER (ORDER BY annualized_pay)*100,1) AS percentile_rank
FROM employee_data
ORDER BY annual_pay DESC;
/*
- Chicago city employees fall into clearly defined pay tiers. The Top 25% 
  begins at approximately $127,000+ — dominated by senior commissioners, 
  superintendents, and department heads, all scoring at the 100th percentile. 
  
- The Upper Mid 25% (72nd percentile) is largely occupied by Firefighter/Paramedic 
  roles at $126,672 — showing that experienced frontline public safety staff 
  sit just below the executive tier.
  
- The Lower Mid 25% (~42nd percentile) clusters around $108,576, comprising 
  administrative and operational support roles across multiple departments.
  
- The Bottom 25% includes entry-level Police Officers and 
  Firefighter-EMT Recruits at $90,816 — confirming that even 
  Chicago's lowest-paid city employees earn above $90K annually, reflecting 
  strong union-negotiated base salaries across the board.
*/























