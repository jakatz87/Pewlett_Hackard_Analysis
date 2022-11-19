# Pewlett Hackard Analysis
## Overview
The purpose of this analysis is to aid a large company as it prepares for a "silver tsunami" of retirement.  With several thousand current employees, the company must prepare for recruitment, training, and the financial impact of retirement benefits.  This project can help the C-suite leadership make good strategic decisions.

## Resources
**Data Sources**: departments.csv, dept_emp.csv, dept_manager.csv, employees.csv, salaries.csv, titles.csv

**Software**: SQL (PostgreSQL11, pgAdmin)

## Results
Using SQL queries from the available data, I found that the company can expect over 30,000 employees nearing retirement.

I found that the Development, Production, and Sales departments can expect the biggest impacts.  
```
SELECT DISTINCT ON (e.emp_no) e.emp_no, t.title, d.dept_name, de.to_date
FROM employees as e
JOIN titles as t
	ON e.emp_no = t.emp_no
JOIN dept_emp as de
	ON e.emp_no = de.emp_no
JOIN departments as d
	ON de.dept_no = d.dept_no
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	AND (e.hire_date BETWEEN '1985-01-01'AND '1988-12-31')
	AND de.to_date = '9999-01-01'
ORDER BY e.emp_no;
```
![image](https://github.com/jakatz87/Pewlett_Hackard_Analysis/blob/main/Retirement_by_department.png)

I also found the largest number of positions to be impacted were Senior Engineer and Senior Staff.
```
--Create a table of retiring employees by title
SELECT e.emp_no, e.first_name, e.last_name, t.title, t.from_date, t.to_date
INTO retriement_titles
FROM employees as e
JOIN titles as t
	ON e.emp_no = t.emp_no
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

--Keep only the most recent titles of current employees ready to retire
SELECT DISTINCT ON (rt.emp_no)rt.emp_no, rt.first_name, rt.last_name, rt.title
INTO unique_titles
FROM retirement_titles as rt
WHERE rt.to_date = '9999-01-01'
ORDER BY rt.emp_no, rt.to_date DESC;

--Track the number of retiring employyes by title
SELECT COUNT(title), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY COUNT(title) DESC;
```
![image](https://github.com/jakatz87/Pewlett_Hackard_Analysis/blob/main/Retirement_by_titles.png)

The good news is that the company is preparing a mentorship program in order to fill the void from the potential wave of retirement.  Looking at the current employees who should be 10 years away from retirement, the company can plan to grow the departments most impacted.

```
--Create a list of employees eligible for a mentorship program based on birthday
SELECT DISTINCT ON (e.emp_no) e.emp_no, e.first_name, e.last_name, e.birth_date, de.from_date, de.to_date, t.title
INTO mentorship_eligibility
FROM employees as e
JOIN dept_emp as de
	ON e.emp_no = de.emp_no
JOIN titles as t
	ON e.emp_no = t.emp_no
WHERE (de.to_date = '9999-01-01') 
	AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no;
```

![image](https://github.com/jakatz87/Pewlett_Hackard_Analysis/blob/main/Mentorship.png)

Fortunately, the employees eligible for the mentorship program correlate well with the impacted departments.

## Summary
The leadership in the Development, Production, and Sales departments should begin working on the mentorship program as soon as possible.  The CFO should begin several forecasting models that include the impact of retirement benefits packages, pay increases for upcoming leadership, and the recruitment and training of new employees to fill the gap of the "silver tsunami".  It seems like the company is prepared for the future.
