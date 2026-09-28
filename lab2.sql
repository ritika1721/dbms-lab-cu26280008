create database labsheet2;
use labsheet2;

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    dept_id INT,
    salary DECIMAL(10,2),
    hire_date DATE,
    is_active BOOLEAN
);
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(100),
    location VARCHAR(50),
    budget DECIMAL(12,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    order_date DATE,
    total_amount DECIMAL(10,2),
    status VARCHAR(20)
);

-- Q1
INSERT INTO employees
(emp_id, first_name, last_name, dept_id, salary, hire_date, is_active)
VALUES
(106, 'Fiona', 'Gallagher', 10, 65000.00, '2024-02-01', TRUE);

-- Q2
INSERT INTO departments
(dept_id, dept_name, location, budget)
VALUES
(60, 'Quality Assurance', 'Building B', 250000.00);

-- Q3
INSERT INTO orders
(order_id, customer_name, order_date, total_amount, status)
VALUES
(5006, 'Delta Retail', '2024-01-28', 2100.00, 'Pending');

-- Q4
SELECT * FROM employees;

-- Q5
SELECT first_name, last_name, salary
FROM employees;

-- Q6
SELECT *
FROM employees
WHERE dept_id = 10;

-- Q7
SELECT *
FROM orders
WHERE status = 'Completed';

-- Q8
UPDATE employees
SET salary = 55000.00
WHERE emp_id = 102;

-- Q9
UPDATE orders
SET status = 'Shipped'
WHERE order_id = 5002;

-- Q10
UPDATE departments
SET budget = budget + 20000.00
WHERE dept_id = 20;

-- Q11
DELETE FROM orders
WHERE order_id = 5004;

-- Q12
DELETE FROM employees
WHERE emp_id = 104
  AND first_name = 'Diana'
  AND last_name = 'Prince';

-- Q13
SELECT *
FROM employees
WHERE salary > 60000.00;

-- Q14
SELECT *
FROM orders
WHERE order_date BETWEEN '2024-01-15' AND '2024-01-20';

-- Q15
SELECT *
FROM departments
WHERE location IN ('Building A', 'Building B');

-- Q16
SELECT *
FROM employees
WHERE last_name LIKE 'S%';

-- Q17
SELECT *
FROM employees
ORDER BY salary DESC;

-- Q18
SELECT *
FROM departments
ORDER BY dept_name ASC;

-- Q19
SELECT COUNT(*) AS total_employees
FROM employees;

-- Q20
SELECT AVG(total_amount) AS average_order_amount
FROM orders;

-- Q21
INSERT INTO employees
(emp_id, first_name, last_name, dept_id, salary, hire_date, is_active)
VALUES
(107, 'George', 'Clark', 30, 50000.00, '2024-02-05', TRUE),
(108, 'Hannah', 'Abbott', 10, 71000.00, '2024-02-10', TRUE);

-- Q22
UPDATE employees
SET salary = salary * 1.10
WHERE dept_id = 10;

-- Q23
UPDATE employees
SET is_active = FALSE
WHERE hire_date < '2021-01-01';

-- Q24
SELECT *
FROM employees
WHERE is_active = TRUE
  AND salary > 60000.00;

-- Q25
SELECT *
FROM orders
WHERE status = 'Cancelled'
   OR total_amount > 2000.00;

-- Q26
SELECT *
FROM employees
WHERE dept_id NOT IN (10, 30);

-- Q27
SELECT *
FROM employees
WHERE LOWER(first_name) LIKE '%a%';

-- Q28
SELECT dept_id, SUM(salary) AS total_salary
FROM employees
GROUP BY dept_id;

-- Q29
SELECT dept_id, COUNT(*) AS total_employees
FROM employees
GROUP BY dept_id;

-- Q30
SELECT dept_id, SUM(salary) AS total_salary
FROM employees
GROUP BY dept_id
HAVING SUM(salary) > 100000.00;

-- Q31
SELECT status,
       MAX(total_amount) AS maximum_amount,
       MIN(total_amount) AS minimum_amount
FROM orders
GROUP BY status;

-- Q32
SELECT *
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);

-- Q33
SELECT *
FROM employees
WHERE dept_id IN (
    SELECT dept_id
    FROM departments
    WHERE location = 'Building A'
);

-- Q34
DELETE FROM orders
WHERE customer_name IN (
    SELECT customer_name
    FROM (
        SELECT customer_name
        FROM orders
        WHERE status = 'Cancelled'
    ) AS cancelled_customers
);

-- Q35
SELECT *
FROM employees
WHERE last_name IS NULL;

-- Q36
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM employees;

-- Q37
SELECT *
FROM employees
ORDER BY salary DESC
LIMIT 3;

-- Q38
SELECT *
FROM employees
ORDER BY dept_id ASC, salary DESC;

-- Q39
DELETE FROM departments
WHERE budget < 200000.00;

-- Q40
UPDATE orders
SET status = 'Cancelled'
WHERE total_amount < 200.00;

-- Q41
UPDATE employees
SET salary = salary * 1.15
WHERE dept_id = (
    SELECT dept_id
    FROM departments
    WHERE budget = (
        SELECT MAX(budget)
        FROM departments
    )
);

-- Q42
SELECT dept_id, AVG(salary) AS average_salary
FROM employees
GROUP BY dept_id
HAVING AVG(salary) > (
    SELECT AVG(salary)
    FROM employees
);

-- Q43
SELECT e.*
FROM employees e
JOIN departments d
ON e.dept_id = d.dept_id
WHERE d.budget > 300000.00;

-- Q44
SELECT *
FROM employees
ORDER BY salary DESC
LIMIT 1 OFFSET 2;

-- Q45
UPDATE employees
SET salary = CASE
    WHEN salary < 60000 THEN salary * 1.10
    ELSE salary * 1.05
END;

-- Q46
DELETE FROM employees
WHERE is_active = FALSE
AND salary < (
    SELECT avg_salary
    FROM (
        SELECT dept_id, AVG(salary) AS avg_salary
        FROM employees
        GROUP BY dept_id
    ) AS dept_avg
    WHERE dept_avg.dept_id = employees.dept_id
);

-- Q47
SELECT d.dept_name,
       (
           SELECT COUNT(*)
           FROM employees e
           WHERE e.dept_id = d.dept_id
       ) AS total_employees
FROM departments d;

-- Q48
SELECT customer_name
FROM orders
GROUP BY customer_name
HAVING COUNT(*) > 1
    OR SUM(total_amount) > 1000.00;

-- Q49
INSERT INTO employees
(emp_id, first_name, last_name, dept_id, salary, hire_date, is_active)
SELECT
    emp_id + 500,
    first_name,
    last_name,
    50,
    salary,
    hire_date,
    is_active
FROM employees
WHERE dept_id = 10;

-- Q50
UPDATE orders
SET status = CASE
    WHEN total_amount > 1000 THEN 'Completed'
    WHEN total_amount BETWEEN 500 AND 1000 THEN 'Shipped'
    ELSE 'Pending'
END;