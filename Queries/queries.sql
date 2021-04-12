-- Creating tables for PH-EmployeeDB
CREATE TABLE departments(dept_no VARCHAR(4) NOT NULL,
						dept_name VARCHAR(40) NOT NULL,
						PRIMARY KEY (dept_no),
						UNIQUE(dept_name));
						
CREATE TABLE employees(emp_no INT NOT NULL,
					birth_date DATE NOT NULL,
					first_name VARCHAR NOT NULL,
					last_name VARCHAR NOT NULL,
					gender VARCHAR NOT NULL,
					hire_date DATE NOT NULL,
					PRIMARY KEY (emp_no));
					
						
CREATE TABLE dept_manager(dept_no VARCHAR(4) NOT NULL,
						  emp_no INT NOT NULL,
						  from_date DATE NOT NULL,
						  to_date DATE NOT NULL,
						  PRIMARY KEY (emp_no,dept_no),
						 FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
						 FOREIGN KEY (dept_no) REFERENCES departments(dept_no));

CREATE TABLE salaries(emp_no INT NOT NULL,
					  salary INT NOT NULL,
					  from_date DATE NOT NULL,
					  to_date DATE NOT NULL,
					  PRIMARY KEY (emp_no),
					FOREIGN KEY (emp_no) REFERENCES employees(emp_no));
					

CREATE TABLE dept_emp(emp_no INT NOT NULL,
					  dept_no VARCHAR(4) NOT NULL,
					  from_date DATE NOT NULL,
					  to_date DATE NOT NULL,
					  FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
					  FOREIGN KEY (dept_no) REFERENCES departments(dept_no));
					 
CREATE TABLE titles(emp_no INT NOT NULL,
					title VARCHAR NOT NULL,
					from_date DATE NOT NULL,
					to_date DATE NOT NULL,
					FOREIGN KEY (emp_no) REFERENCES employees(emp_no));
					
					
					
-- "*" tells Postgres that we are looking for every column in a table
SELECT*FROM departments;
SELECT*FROM dept_emp;
DROP TABLE titles CASCADE;

SELECT*FROM employees;

SELECT first_name,last_name
FROM employees
WHERE birth_date BETWEEN '2052-01-01' AND '2052-12-31';

SELECT first_name,last_name
FROM employees
WHERE birth_date BETWEEN '2053-01-01' AND '2053-12-31';

SELECT first_name,last_name
FROM employees
WHERE birth_date BETWEEN '2054-01-01' AND '2054-12-31';

SELECT first_name,last_name
FROM employees
WHERE birth_date BETWEEN '2055-01-01' AND '2055-12-31';


--Retirement eligibility, create a new table: retirement_info
SELECT first_name,last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '2052-01-01' AND '2055-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
SELECT*FROM retirement_info;

--Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '2052-01-01' AND '2055-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

DROP TABLE retirement_info;
--Create new table for retiring employees
SELECT emp_no,first_name,last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '2052-01-01' AND '2055-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
--Check the table
SELECT*FROM retirement_info


-- Joining departments and dept_manager tables
SELECT d.dept_name,
	dm.emp_no,
	dm.from_date,
	dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no=dm.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
	retirement_info.first_name,
	retirement_info.last_name,
	dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no=dept_emp.emp_no;

-- Create a table for retire employees that current works
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no=de.emp_no
WHERE de.to_date=('9999-01-01');

SELECT*FROM current_emp;

-- Employee count by department number
SELECT COUNT(ce.emp_no),de.dept_no
INTO current_count
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no=de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT*FROM current_count;

SELECT*FROM salaries
ORDER BY to_date DESC;

SELECT e.emp_no,
	e.first_name,
	e.last_name,
	e.gender,
	s.salary,
	de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON e.emp_no=s.emp_no
INNER JOIN dept_emp as de
ON e.emp_no=de.emp_no
WHERE (birth_date BETWEEN '2052-01-01' AND '2055-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date='9999-01-01');

-- list of managers per department
SELECT dm.from_date,
	dm.to_date,
	dm.dept_no,
	d.dept_name,
	ce.first_name,
	ce.last_name,
	dm.emp_no
INTO manager_info
FROM dept_manager as dm
	INNER JOIN departments as d
		ON dm.dept_no=d.dept_no
	INNER JOIN current_emp as ce
		ON dm.emp_no=ce.emp_no;
		
-- department retirements table
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name
INTO dept_info
FROM current_emp as ce
	INNER JOIN dept_emp as de
		ON ce.emp_no=de.emp_no
	INNER JOIN departments as d
		ON de.dept_no=d.dept_no;
		
SELECT*FROM retirement_info;

-- Create a table for sales and development team
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	d.dept_name
FROM retirement_info as ri
	INNER JOIN dept_emp as de
		ON ri.emp_no=de.emp_no
	INNER JOIN departments as d
		ON de.dept_no=d.dept_no
WHERE d.dept_name IN ('Sales','Development')
