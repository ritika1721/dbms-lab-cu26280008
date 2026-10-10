
DROP DATABASE IF EXISTS CollegeJoinDB;
CREATE DATABASE CollegeJoinDB;
USE CollegeJoinDB;

-- Create tables
CREATE TABLE Departments (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50),
    Location VARCHAR(50)
);

CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50),
    DeptID INT,
    Salary DECIMAL(10,2),
    City VARCHAR(50)
);

CREATE TABLE SalaryGrades (
    Grade CHAR(2) PRIMARY KEY,
    MinSalary DECIMAL(10,2),
    MaxSalary DECIMAL(10,2)
);

-- Insert sample data
INSERT INTO Departments VALUES
(10,'Computer Science','Block A'),
(20,'Pharmacy','Block B'),
(30,'Management','Block C'),
(40,'Civil Engineering','Block D');

INSERT INTO Employees VALUES
(101,'Aarav',10,65000,'Delhi'),
(102,'Priya',20,72000,'Mumbai'),
(103,'Rahul',10,48000,'Delhi'),
(104,'Sneha',30,91000,'Pune'),
(105,'Vikram',20,55000,'Jaipur'),
(106,'Neha',50,80000,'Bengaluru'),
(107,'Kabir',30,43000,'Pune');

INSERT INTO SalaryGrades VALUES
('G1',0,49999),
('G2',50000,69999),
('G3',70000,89999),
('G4',90000,120000);

-- Verify setup
SHOW TABLES;
SELECT * FROM Departments;
SELECT * FROM Employees;
SELECT * FROM SalaryGrades;

-- Q1. Basic Inner Join
SELECT e.EmpName, d.DeptName, d.Location
FROM Employees e
INNER JOIN Departments d ON e.DeptID = d.DeptID;

-- Q2. Employee and Department IDs
SELECT e.EmpID, e.EmpName, e.DeptID, d.DeptName
FROM Employees e
INNER JOIN Departments d ON e.DeptID = d.DeptID;

-- Q3. Pharmacy Employees
SELECT e.EmpID, e.EmpName, e.DeptID, e.Salary, e.City
FROM Employees e
INNER JOIN Departments d ON e.DeptID = d.DeptID
WHERE d.DeptName = 'Pharmacy';

-- Q4. Matched Employees with Salary Greater Than 60000
SELECT e.EmpName, d.DeptName, e.Salary
FROM Employees e
INNER JOIN Departments d ON e.DeptID = d.DeptID
WHERE e.Salary > 60000;

-- Q5. Equi Join Using DeptID
SELECT e.EmpID, e.EmpName, e.DeptID, d.DeptName
FROM Employees e
INNER JOIN Departments d ON e.DeptID = d.DeptID;

-- Q6. Equi Join with Multiple Display Columns
SELECT e.EmpName, e.City, d.DeptName, d.Location
FROM Employees e
INNER JOIN Departments d ON e.DeptID = d.DeptID;

-- Q7. Computer Science Employees
SELECT e.EmpName, d.DeptName
FROM Employees e
INNER JOIN Departments d ON e.DeptID = d.DeptID
WHERE d.DeptName = 'Computer Science';

-- Q8. Theta Join: Salary Greater Than a Grade's Minimum Salary
SELECT e.EmpName, e.Salary, g.Grade, g.MinSalary
FROM Employees e
INNER JOIN SalaryGrades g ON e.Salary > g.MinSalary;

-- Q9. Theta Join: Assign Employees to Their Salary Grade
SELECT e.EmpName, e.Salary, g.Grade
FROM Employees e
INNER JOIN SalaryGrades g
ON e.Salary >= g.MinSalary AND e.Salary <= g.MaxSalary;

-- Q10. Theta Join: Salary Less Than a Grade's Maximum Salary
SELECT e.EmpName, e.Salary, g.Grade, g.MaxSalary
FROM Employees e
INNER JOIN SalaryGrades g ON e.Salary < g.MaxSalary;

-- Q11. Theta Join: Salary Greater Than or Equal to Grade Minimum
SELECT e.EmpName, e.Salary, g.Grade, g.MinSalary
FROM Employees e
INNER JOIN SalaryGrades g ON e.Salary >= g.MinSalary;

-- Q12. Natural Join: Employee Names, DeptID, and Department Names
SELECT EmpName, DeptID, DeptName
FROM Employees
NATURAL JOIN Departments;

-- Q13. Natural Join: Employees in Block B
SELECT EmpName, DeptName, Location
FROM Employees
NATURAL JOIN Departments
WHERE Location = 'Block B';

-- Q14. Natural Join: Employees with Salary at Least 70000
SELECT EmpName, DeptName, Salary
FROM Employees
NATURAL JOIN Departments
WHERE Salary >= 70000;

-- Q15. Inner Join Ordered by Salary, Highest First
SELECT e.EmpName, d.DeptName, e.Salary
FROM Employees e
INNER JOIN Departments d ON e.DeptID = d.DeptID
ORDER BY e.Salary DESC;

-- Q16. Distinct Departments with at Least One Matching Employee
SELECT DISTINCT d.DeptName
FROM Employees e
INNER JOIN Departments d ON e.DeptID = d.DeptID;

-- Q17. Employee Count in Each Matched Department
SELECT d.DeptName, COUNT(e.EmpID) AS EmployeeCount
FROM Employees e
INNER JOIN Departments d ON e.DeptID = d.DeptID
GROUP BY d.DeptID, d.DeptName;

-- Q18. Average Salary for Each Matched Department
SELECT d.DeptName, AVG(e.Salary) AS AverageSalary
FROM Employees e
INNER JOIN Departments d ON e.DeptID = d.DeptID
GROUP BY d.DeptID, d.DeptName;

-- Q19. Departments with Average Employee Salary Greater Than 60000
SELECT d.DeptName, AVG(e.Salary) AS AverageSalary
FROM Employees e
INNER JOIN Departments d ON e.DeptID = d.DeptID
GROUP BY d.DeptID, d.DeptName
HAVING AVG(e.Salary) > 60000;

-- Q20. Highest-Paid Employee Among Matched Employees
SELECT e.EmpName, d.DeptName, e.Salary
FROM Employees e
INNER JOIN Departments d ON e.DeptID = d.DeptID
ORDER BY e.Salary DESC
LIMIT 1;

-- Q21. Employees in Computer Science or Pharmacy
SELECT e.EmpName, d.DeptName
FROM Employees e
INNER JOIN Departments d ON e.DeptID = d.DeptID
WHERE d.DeptName IN ('Computer Science', 'Pharmacy');

-- Q22. Employees from Delhi or Pune with Salary at Least 50000
SELECT e.EmpName, e.City, e.Salary, d.DeptName
FROM Employees e
INNER JOIN Departments d ON e.DeptID = d.DeptID
WHERE e.City IN ('Delhi', 'Pune') AND e.Salary >= 50000;

-- Q23. All Matched Employees (EmpID 106 is excluded because DeptID 50 is unmatched)
SELECT e.EmpID, e.EmpName, e.DeptID, d.DeptName
FROM Employees e
INNER JOIN Departments d ON e.DeptID = d.DeptID;

-- Q24. Natural Join: Count Employees in Each Department
SELECT DeptName, COUNT(EmpID) AS EmployeeCount
FROM Employees
NATURAL JOIN Departments
GROUP BY DeptID, DeptName;

-- Q25. Departments Whose Total Employee Salary Is Greater Than 100000
SELECT d.DeptName, SUM(e.Salary) AS TotalSalary
FROM Employees e
INNER JOIN Departments d ON e.DeptID = d.DeptID
GROUP BY d.DeptID, d.DeptName
HAVING SUM(e.Salary) > 100000;
