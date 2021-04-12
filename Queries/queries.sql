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
DROP TABLE titles CASCADE

SELECT*FROM employees

SELECT first_name,last_name
FROM employees
WHERE birth_date BETWEEN '2052-01-01' AND '2052-12-31'

SELECT first_name,last_name
FROM employees
WHERE birth_date BETWEEN '2053-01-01' AND '2053-12-31'

SELECT first_name,last_name
FROM employees
WHERE birth_date BETWEEN '2054-01-01' AND '2054-12-31'

SELECT first_name,last_name
FROM employees
WHERE birth_date BETWEEN '2055-01-01' AND '2055-12-31'


--Retirement eligibility, create a new table: retirement_info
SELECT first_name,last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '2052-01-01' AND '2055-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
SELECT*FROM retirement_info

--Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '2052-01-01' AND '2055-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
