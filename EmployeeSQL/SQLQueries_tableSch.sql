--Create tables for each csv file and import them to the tables 

CREATE TABLE departments(
	dept_no VARCHAR PRIMARY KEY,
	dept_name VARCHAR
);

CREATE TABLE titles(
	title_id VARCHAR PRIMARY KEY,
	title VARCHAR
);

CREATE TABLE employees(
	emp_no INTEGER PRIMARY KEY,
	emp_title_id VARCHAR NOT NULL,
	birth_date VARCHAR NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	sex VARCHAR NOT NULL,
	hire_date VARCHAR NOT NULL,
	FOREIGN KEY (emp_title_id) REFERENCES titles(title_id)
);

CREATE TABLE dept_emp(
	emp_no INTEGER NOT NULL,
	dept_no VARCHAR NOT NULL,
	PRIMARY KEY (emp_no, dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);

CREATE TABLE dept_manager(
	dept_no VARCHAR NOT NULL,
	emp_no INTEGER NOT NULL,
	PRIMARY KEY (dept_no, emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
	--FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

CREATE TABLE salaries(
	emp_no INTEGER PRIMARY KEY,
	salary INTEGER NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

--Check all csv files correctly import to the tables
SELECT * FROM departments LIMIT(10);
SELECT * FROM titles LIMIT(10);
SELECT * FROM employees LIMIT(10);
SELECT * FROM dept_emp LIMIT(10);
SELECT * FROM dept_manager LIMIT(10);
SELECT * FROM salaries LIMIT(10);


--DATA ANALYSIS
--1 List the employee number, last name, first name, sex, and salary of each employee

CREATE VIEW emploees_and_salary AS
SELECT employees.emp_no, employees.last_name, employees.first_name, employees.sex, salaries.salary
FROM employees 
JOIN salaries ON employees.emp_no = salaries.emp_no;

SELECT * FROM emploees_and_salary;

--2 List the first name, last name, and hire date for the employees who were hired in 1986 

CREATE VIEW emp_hired_1986 AS
SELECT employees.first_name, employees.last_name, employees.hire_date
FROM employees WHERE hire_date LIKE '%1986';


SELECT * FROM emp_hired_1986;


--3 List the manager of each department along with their department number, 
--department name, employee number, last name, and first name

CREATE VIEW Department_Manager_Info AS
SELECT dept_manager.dept_no, departments.dept_name, dept_manager.emp_no, employees.last_name, employees.first_name
FROM dept_manager
JOIN departments ON dept_manager.dept_no = departments.dept_no
JOIN employees ON dept_manager.emp_no = employees.emp_no;

SELECT * FROM Department_Manager_Info;


--4 List the department number for each employee along with that employee’s employee number, last name, 
--first name, and department name

CREATE VIEW Emp_and_Department AS
SELECT employees.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM employees
JOIN dept_emp ON employees.emp_no = dept_emp.emp_no
JOIN departments ON dept_emp.dept_no = departments.dept_no; 

SELECT * FROM Emp_and_Department;

--5 List first name, last name, and sex of each employee whose first name is Hercules 
--and whose last name begins with the letter B

SELECT employees.first_name, employees.last_name, employees.sex
FROM employees WHERE first_name = 'Hercules' AND last_name LIKE 'B%';


--6 List each employee in the Sales department, including their employee number, last name, and first name

SELECT employees.emp_no, employees.last_name, employees.first_name
FROM employees
JOIN dept_emp ON employees.emp_no = dept_emp.emp_no
JOIN departments ON dept_emp.dept_no = departments.dept_no
WHERE dept_name = 'Sales'; 


--7 List each employee in the Sales and Development departments, including their employee number, 
--last name, first name, and department name 

CREATE VIEW Emp_in_Sales_Dev AS
SELECT employees.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM employees
JOIN dept_emp ON employees.emp_no = dept_emp.emp_no
JOIN departments ON dept_emp.dept_no = departments.dept_no
WHERE dept_name = 'Sales' OR dept_name = 'Development';

--8 List the frequency counts, in descending order, of all the employee last names 
--(that is, how many employees share each last name)
--Created alias 'Surname Count' for readability 
SELECT employees.last_name, COUNT(last_name) AS "Lastname Count"
FROM employees
GROUP BY last_name
ORDER BY "Lastname Count" DESC;
