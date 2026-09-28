CREATE DATABASE IF NOT EXISTS company_db;

USE company_db;

CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL,
    location VARCHAR(50),
    budget DECIMAL(12,2)
) ENGINE=InnoDB;

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    dept_id INT,
    salary DECIMAL(10,2),
    hire_date DATE,
    is_active BOOLEAN,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
) ENGINE=InnoDB;

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    order_date DATE,
    total_amount DECIMAL(10,2),
    status VARCHAR(20)
) ENGINE=InnoDB;
CREATE USER IF NOT EXISTS 'johnn'@'localhost'
IDENTIFIED BY 'JohnPass2026!';

CREATE USER IF NOT EXISTS 'alice'@'localhost'
IDENTIFIED BY 'AlicePass2026!';

CREATE USER IF NOT EXISTS 'intern_user'@'localhost'
IDENTIFIED BY 'InternPass2026!';

CREATE USER IF NOT EXISTS 'temp_user'@'localhost'
IDENTIFIED BY 'TempPass2026!';

CREATE USER IF NOT EXISTS 'sec_user'@'localhost'
IDENTIFIED BY 'SecPass2026!';

CREATE USER IF NOT EXISTS 'admin_user'@'%'
IDENTIFIED BY 'AdminPass2026!';

CREATE USER IF NOT EXISTS 'auditor'@'localhost'
IDENTIFIED BY 'AuditPass2026!';

CREATE USER IF NOT EXISTS 'analyst'@'localhost'
IDENTIFIED BY 'AnalystPass2026!';

CREATE USER IF NOT EXISTS 'manager'@'localhost'
IDENTIFIED BY 'MgrPass2026!';

CREATE USER IF NOT EXISTS 'dev_user'@'localhost'
IDENTIFIED BY 'DevPass2026!';

CREATE USER IF NOT EXISTS 'hr_assistant'@'localhost'
IDENTIFIED BY 'HrPass2026!';

CREATE USER IF NOT EXISTS 'finance_user'@'localhost'
IDENTIFIED BY 'FinPass2026!';

CREATE USER IF NOT EXISTS 'team_lead'@'localhost'
IDENTIFIED BY 'LeadPass2026!';

FLUSH PRIVILEGES;
GRANT SELECT ON company_db.* TO 'johnn'@'localhost';
GRANT SELECT, INSERT
ON company_db.employees
TO 'alice'@'localhost';

REVOKE INSERT
ON company_db.employees
FROM 'alice'@'localhost';

START TRANSACTION;

COMMIT;

START TRANSACTION;

DELETE FROM company_db.employees
WHERE emp_id = 105;

ROLLBACK;

START TRANSACTION;

SAVEPOINT sp_before_update;

GRANT ALL PRIVILEGES
ON *.*
TO 'admin_user'@'%';

FLUSH PRIVILEGES;

REVOKE ALL PRIVILEGES, GRANT OPTION
FROM 'intern_user'@'localhost';

GRANT DELETE
ON company_db.orders
TO 'dev_user'@'localhost';

START TRANSACTION;

UPDATE company_db.employees
SET salary = 80000
WHERE emp_id = 101;

SAVEPOINT sp_first;

UPDATE company_db.employees
SET salary = 95000
WHERE emp_id = 102;

ROLLBACK TO SAVEPOINT sp_first;

COMMIT;

GRANT SELECT, UPDATE
ON company_db.employees
TO 'hr_assistant'@'localhost';

REVOKE UPDATE
ON company_db.employees
FROM 'hr_assistant'@'localhost';


SET SESSION TRANSACTION READ ONLY;

START TRANSACTION;

UPDATE company_db.employees
SET salary = 85000
WHERE emp_id = 101;

ALTER TABLE company_db.employees
ADD COLUMN temp_col INT;

ROLLBACK;
SELECT @@transaction_read_only;
START TRANSACTION;

UPDATE company_db.departments
SET budget = budget - 10000
WHERE dept_id = 10;

UPDATE company_db.departments
SET budget = budget + 10000
WHERE dept_id = 20;

COMMIT;
SHOW GRANTS FOR 'team_lead'@'localhost';

GRANT SELECT
ON company_db.*
TO 'team_lead'@'localhost'
WITH GRANT OPTION;
REVOKE GRANT OPTION
ON company_db.*
FROM 'team_lead'@'localhost';

START TRANSACTION;
UPDATE company_db.orders
SET status = 'Shipped'
WHERE order_id = 5002;
SELECT total_amount
FROM company_db.orders
WHERE order_id = 5002;
ROLLBACK;



CREATE ROLE IF NOT EXISTS 'reporter_role';
GRANT SELECT
ON company_db.*
TO 'reporter_role';
GRANT 'reporter_role'
TO 'analyst'@'localhost';
SET DEFAULT ROLE 'reporter_role'
TO 'analyst'@'localhost';



START TRANSACTION;
UPDATE company_db.employees
SET salary = salary * 1.15
WHERE dept_id = 10;
SAVEPOINT sp_salary_done;
UPDATE company_db.departments
SET budget = budget + 50000
WHERE dept_id = 10;
SELECT budget
FROM company_db.departments
WHERE dept_id = 10;
ROLLBACK TO SAVEPOINT sp_salary_done;
COMMIT;



START TRANSACTION;
SELECT *
FROM company_db.employees
WHERE emp_id = 101
FOR UPDATE;
UPDATE company_db.employees
SET salary = 88000
WHERE emp_id = 101;
COMMIT;



START TRANSACTION;
SELECT *
FROM company_db.departments
WHERE dept_id = 10
FOR SHARE;

SELECT *
FROM company_db.departments
WHERE dept_id = 10;
COMMIT;



ALTER USER 'auditor'@'localhost'
WITH MAX_QUERIES_PER_HOUR 100
MAX_USER_CONNECTIONS 2;



START TRANSACTION;
UPDATE company_db.orders
SET status = 'Cancelled'
WHERE order_id = 5002
AND status = 'Pending';
UPDATE company_db.departments
SET budget = budget + 450
WHERE dept_id = 20;
COMMIT;



CREATE ROLE IF NOT EXISTS 'read_role';
CREATE ROLE IF NOT EXISTS 'write_role';
CREATE ROLE IF NOT EXISTS 'admin_role';
GRANT SELECT
ON company_db.*
TO 'read_role';
GRANT INSERT, UPDATE, DELETE
ON company_db.*
TO 'write_role';
GRANT 'read_role'
TO 'write_role';
GRANT 'write_role'
TO 'admin_role';
CREATE USER IF NOT EXISTS 'super_dev'@'localhost'
IDENTIFIED BY 'SuperDevPass2026!';
GRANT 'admin_role'
TO 'super_dev'@'localhost';
SET DEFAULT ROLE 'admin_role'
TO 'super_dev'@'localhost';

CREATE USER IF NOT EXISTS 'cloud_user'@'%'
IDENTIFIED BY 'CloudPass2026!'
REQUIRE SSL;
GRANT SELECT, INSERT
ON company_db.*
TO 'cloud_user'@'%';



START TRANSACTION;
INSERT INTO company_db.orders
VALUES
(5008, 'Customer 8', '2024-02-01', 600.00, 'Pending');
SAVEPOINT sp_5008;
INSERT INTO company_db.orders
VALUES
(5009, 'Customer 9', '2024-02-02', 700.00, 'Pending');
SAVEPOINT sp_5009;
ROLLBACK TO SAVEPOINT sp_5008;
COMMIT;



CREATE USER IF NOT EXISTS 'test_maint'@'localhost'
IDENTIFIED BY 'TestMaintPass2026!';
GRANT SELECT, INSERT, UPDATE
ON company_db.*
TO 'test_maint'@'localhost';

START TRANSACTION;

UPDATE company_db.employees
SET is_active = TRUE
WHERE emp_id = 104;
ROLLBACK;
SHOW GRANTS FOR 'test_maint'@'localhost';
REVOKE SELECT, INSERT, UPDATE
ON company_db.*
FROM 'test_maint'@'localhost';
ALTER USER 'test_maint'@'localhost'
ACCOUNT LOCK;

