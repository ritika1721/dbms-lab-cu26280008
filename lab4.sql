use sql_lab4

CREATE TABLE Department ( 
DeptID INT PRIMARY KEY, 
DeptName VARCHAR(50) NOT NULL ); 
CREATE TABLE Student ( 
StudentID INT PRIMARY KEY,
 Name VARCHAR(100) NOT NULL, 
 Email VARCHAR(100), 
 Age INT, DeptID INT, 
 JoiningDate DATE ); 
 CREATE TABLE Enrollment ( 
 EnrollmentID INT PRIMARY KEY,
 StudentID INT, 
 CourseName VARCHAR(100) ); 
 
 INSERT INTO Department VALUES
 (10,'Computer Science'), 
 (20,'Information Technology'), 
 (30,'Pharmacy'), 
 (40,'Management'); 
INSERT INTO Student VALUES
 (101,'Amit Sharma','amit@example.com',20,10,'2026-07-01'), 
 (102,'Priya Singh','priya@example.com',21,20,'2026-07-03'),
 
 (103,'Rahul Verma','rahul@example.com',22,30,'2026-07-05'), 
 (104,'Neha Gupta','neha@example.com',20,10,'2026-07-08'), 
(105,'Arjun Mehta','arjun@example.com',23,40,'2026-07-10');
INSERT INTO Enrollment VALUES
 (1,101,'DBMS'), 
 (2,102,'Operating Systems'),
 (3,103,'Pharmacology'),
 (4,104,'Python'); 
 
  INSERT INTO Enrollment VALUES (1,105,'Data Mining'); 
ALTER TABLE Enrollment ADD CONSTRAINT fk_enrollment_student FOREIGN KEY (StudentID) REFERENCES Student(StudentID); 
;
INSERT INTO Student VALUES (106,'Riya Das','riya@example.com',21,99,'2026-08-01'); 
SELECT s.StudentID, s.Name, d.DeptName FROM Student s INNER JOIN Department d ON s.DeptID = d.DeptID;
 SELECT e.EnrollmentID, s.Name, e.CourseName FROM Enrollment e INNER JOIN Student s ON e.StudentID = s.StudentID
 
 CREATE TABLE Department2
 ( DeptID INT PRIMARY KEY, 
 DeptName VARCHAR(50) NOT NULL ); 
 INSERT INTO Department2 VALUES (50,NULL); 
 
 INSERT INTO Student 
 (StudentID, Email, Age, DeptID)
 VALUES (106,'riya@example.com',21,20);
 
 ALTER TABLE Student 
 ADD CONSTRAINT uq_student_email UNIQUE (Email); 
 INSERT INTO Student VALUES
 (106,'Riya Das','amit@example.com',21,20,'2026-08-01'); 
 
 CREATE TABLE Library (
 BookID INT UNIQUE, 
 Title VARCHAR(150) NOT NULL );
 INSERT INTO Library VALUES
 (1,'Database Systems'), 
 (2,'Operating Systems'), 
 (3,'Computer Networks'), 
 (4,'Python Programming'),
 (5,'Data Mining'); 
 
 ALTER TABLE Student ADD CONSTRAINT chk_student_age CHECK (Age > 18); 
 INSERT INTO Student VALUES
 (106,'Riya Das','riya@example.com',17,20,'2026-08-01'); 
 
 CREATE TABLE Course ( 
 CourseID INT PRIMARY KEY, 
 CourseName VARCHAR(100),
 Credits INT CHECK (Credits BETWEEN 1 AND 6) ); 
 INSERT INTO Course VALUES (1,'DBMS',8); 
 
 ALTER TABLE Student ADD COLUMN JoiningDate2 DATE DEFAULT (CURRENT_DATE);
 INSERT INTO Student (StudentID,Name,Email,Age,DeptID) 
 VALUES (106,'Riya Das','riya@example.com',21,20);
 SELECT * FROM Student;
 
 CREATE TABLE Faculty (
 FacultyID INT PRIMARY KEY,
 FacultyName VARCHAR(100) NOT NULL, 
 Designation VARCHAR(50) DEFAULT 'Lecturer' );
 INSERT INTO Faculty (FacultyID, FacultyName) 
 VALUES (1,'Dr. Meera Sharma'); 
 SELECT * FROM Faculty;
 
 CREATE TABLE employees (
 emp_id INT PRIMARY KEY, 
 name VARCHAR(80), 
 department VARCHAR(50),
 salary DECIMAL(10,2), 
 hire_date DATE );
 
 INSERT INTO employees VALUES (101,'John Smith','IT',55000,'2024-01-15'); 
 
 INSERT INTO employees VALUES
 (102,'Sarah Johnson','HR',48000,'2024-02-10'),
 (103,'Mike Davis','Finance',52000,'2024-01-20'),
 (104,'Lisa Wilson','Marketing',45000,'2024-03-01'); 
 
 INSERT INTO employees (emp_id,name,department) VALUES (107,'David Clark','Sales');
 SELECT * FROM employees; 
 
 SELECT name, salary FROM employees;
 
 SELECT * FROM employees WHERE department = 'IT';
 
 SELECT * FROM employees WHERE salary > 50000;
 
 SELECT * FROM employees WHERE hire_date BETWEEN '2024-01-01' AND '2024-01-31';
 
 SELECT DISTINCT department FROM employees;
 
 SELECT COUNT(*) AS total_employees FROM employees;
 
 set sql_safe_updates = 0;
 
 UPDATE employees SET salary = 58000 WHERE name = 'John Smith'; 
 
 UPDATE employees SET salary = salary * 1.05 WHERE department = 'HR'; 
 
 UPDATE employees SET salary = 47000, hire_date = '2024-03-05' WHERE name = 'Lisa Wilson';
 
UPDATE employees SET department = 'Operations' WHERE salary < 50000; 

UPDATE employees SET salary = salary + 2000 WHERE department = 'Finance'; 

UPDATE employees SET department = 'Senior Staff' WHERE hire_date < '2024-02-01';

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(30),
    price DECIMAL(10,2),
    stock_quantity INT
);
INSERT INTO products
(product_id, product_name, category, price, stock_quantity)
VALUES
(1, 'Laptop', 'Electronics', 999.99, 5),
(2, 'Mouse', 'Electronics', 25.50, 0),
(3, 'Desk Chair', 'Furniture', 150.00, 3),
(4, 'Monitor', 'Electronics', 1200.00, 2),
(5, 'Keyboard', 'Electronics', 75.00, 0),
(6, 'Coffee Mug', 'Office', 12.99, 10),
(7, 'Notebook', 'Office', 5.99, 8),
(8, 'Smartphone', 'Electronics', 500.00, 6);

DELETE FROM products WHERE stock_quantity = 0; 
DELETE FROM products WHERE category = 'Electronics' AND price > 1000;
DELETE FROM products WHERE product_name = 'Desk Chair';
DELETE FROM products WHERE price < 100; 

CREATE TABLE students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50),
    course VARCHAR(50),
    marks INT,
    city VARCHAR(30)
);
INSERT INTO students
(student_id, student_name, course, marks, city)
VALUES
(1, 'Alice Brown', 'Computer Science', 85, 'Mumbai'),
(2, 'Bob Wilson', 'Mathematics', 78, 'Delhi'),
(3, 'Carol Davis', 'Computer Science', 92, 'Mumbai'),
(4, 'David Miller', 'Physics', 88, 'Chennai'),
(5, 'Eva Garcia', 'Mathematics', 82, 'Bangalore'),
(6, 'Frank Johnson', 'Computer Science', 95, 'Delhi'),
(7, 'Grace Lee', 'Physics', 90, 'Mumbai'),
(8, 'Henry Smith', 'Mathematics', 76, 'Chennai'),
(9, 'Ivy Chen', 'Computer Science', 89, 'Delhi'),
(10, 'Jack Taylor', 'Physics', 84, 'Mumbai');

SELECT * FROM students ORDER BY marks DESC;

SELECT * FROM students ORDER BY marks DESC LIMIT 5; 
SELECT * FROM students WHERE course = 'Computer Science' ORDER BY student_name ASC; 

SELECT * FROM students ORDER BY marks ASC LIMIT 3;

SELECT * FROM students WHERE marks BETWEEN 80 AND 90;
SELECT * FROM students WHERE student_name LIKE 'A%';

SELECT * FROM students WHERE city IN ('Mumbai','Delhi'); 