-- Search for entries based on birthday for retirment age
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

-- Search by each year in the range
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

-- Retirement eligibility based on hiring date
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') 
	AND (hire_date BETWEEN '1985-01-01'AND '1988-12-31');
	
-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Create a new table based on query
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') 
	AND (hire_date BETWEEN '1985-01-01'AND '1988-12-31');

SELECT * FROM retirement_info;

--Create a Department table with full info on INNER JOIN
SELECT departments.dept_name, 
		dept_manager.emp_no, 
		dept_manager.from_date, 
		dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

SELECT retirement_info.emp_no,
		retirement_info.first_name,
		retirement_info.last_name,
		dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

--Create a new table with aliases
SELECT ri.emp_no,
		ri.first_name,
		ri.last_name,
		de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

SELECT * FROM current_emp;


-- Employee count by department number with a groupby
SELECT COUNT(ce.emp_no), de.dept_no
INTO retirement_counts
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

--Create a temp table to join with the salary table
SELECT e.emp_no, e.last_name, e.first_name, e.birth_date, e.hire_date, e.gender, de.to_date
INTO temp_ede
FROM employees as e
LEFT JOIN dept_emp as de
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31') 
	AND (e.hire_date BETWEEN '1985-01-01'AND '1988-12-31')
	AND de.to_date = '9999-01-01'
ON e.emp_no = de.emp_no;

--Create a table of current employees and salaries
SELECT t.emp_no, t.last_name, t.first_name, t.gender, s.salary
INTO emp_info 
FROM temp_ede as t
LEFT JOIN salaries as s
ON t.emp_no = s.emp_no;

SELECT * FROM emp_info;

--Create a table with current managers
SELECT d.dept_no, d.dept_name, e.first_name, e.last_name, m.from_date, m.to_date
INTO manager_info
FROM departments as d
LEFT JOIN dept_manager as m
	ON d.dept_no = m.dept_no
INNER JOIN current_emp as e
	ON e.emp_no = m.emp_no;

--Create a table to add department names with current employees
SELECT e.emp_no, e.first_name, e.last_name, d.dept_name
INTO dept_info
FROM current_emp as e
JOIN dept_emp
	ON dept_emp.emp_no = e.emp_no
JOIN departments as d
	ON dept_emp.dept_no = d.dept_no;

	--Create a list that returns only employees in Sales or Development
SELECT * FROM dept_info
WHERE dept_name IN ('Sales', 'Development');