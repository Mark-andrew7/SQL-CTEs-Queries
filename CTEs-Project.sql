CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(50),
    department_id INT,
	salary INT
);

-- Insert sample data into the employees table
INSERT INTO employees (employee_id, employee_name, department_id, salary)
VALUES 
    (1, 'John', 1, 100000),
    (2, 'Jane', 6, 30000),
    (3, 'Alice', 4, 60000),
    (4, 'Bob', 3, 17500),
	(5, 'Emily', 6, 50000),
    (6, 'Michael', 3, 45000),
    (7, 'Jessica', 5, 75000),
    (8, 'David', 2, 85000),
    (9, 'Sarah', 5, 150000),
    (10, 'Christopher', 4, 60000),
    (11, 'Laura', 1, 36000),
    (12, 'Matthew', 2, 95000)

-- Create the departments table
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50)
);

-- Insert sample data into the departments table
INSERT INTO departments (department_id, department_name)
VALUES 
    (1, 'Engineering'),
    (2, 'Marketing'),
    (3, 'Finance'),
	(4, 'Human Resources'),
    (5, 'Sales'),
    (6, 'Operations');

-- Display of information in both employees and departments table
SELECT *
FROM Information..employees

SELECT *
FROM Information..departments

-- Returns average salary of each department
WITH AverageSalary AS(
SELECT department_id, AVG(salary) AS DeptAverageSalary
FROM Information..employees
GROUP BY department_id
)

SELECT *
FROM AverageSalary

-- Finding out departments with more than one employee along department names
WITH DeptCount AS(
SELECT department_id, COUNT(*) AS NumEmployees
FROM employees 
GROUP BY department_id
HAVING COUNT(*) > 1
)

SELECT department_name, Dep.department_id, NumEmployees
FROM departments Dep
JOIN DeptCount Dtc
ON Dep.department_id = Dtc.department_id

-- Employees with highest salary in each department
WITH HighestSalary AS(
SELECT employee_id, employee_name, department_id ,salary,
ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary desc) AS MaxSalaryPerDepartment
FROM employees
)

SELECT Dep.department_id, Dep.department_name, employee_id, employee_name, salary
FROM departments Dep
JOIN HighestSalary Hig
ON Dep.department_id = Hig.department_id
WHERE MaxSalaryPerDepartment = 1

-- Employees with a greater salary than the average salary in their respective departments
WITH SalaryAboveAverage AS(
SELECT employee_id, employee_name, department_id, salary,
AVG(salary) OVER (PARTITION BY department_id) AS AverageSalaryPerDepartment
FROM employees
)

SELECT Dep.department_id, department_name, employee_id, employee_name, salary, AverageSalaryPerDepartment
FROM departments Dep
JOIN SalaryAboveAverage Sal
ON Dep.department_id = Sal.department_id
WHERE salary > AverageSalaryPerDepartment

-- Department with the highest salary expense
WITH HighestTotalSalary AS(
SELECT department_id, SUM(salary) AS TotalSalary
FROM employees
GROUP BY department_id
)

SELECT Dep.department_id, Dep.department_name,TotalSalary
FROM departments Dep
JOIN HighestTotalSalary Htc
ON Dep.department_id = Htc.department_id
ORDER BY TotalSalary DESC
OFFSET 0 ROWS
FETCH FIRST 1 ROW ONLY

-- Departments whose total salary is greater than 100000
WITH SalaryLimit AS(
SELECT department_id, SUM(salary) AS TotalSalary
FROM employees
GROUP BY department_id
HAVING MAX(salary) > 100000
)

SELECT Dep.department_id, Dep.department_name, TotalSalary
FROM departments Dep
JOIN SalaryLimit Sal
ON Dep.department_id = Sal.department_id







