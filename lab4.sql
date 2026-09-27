CREATE DATABASE sql_lab; 
USE sql_lab; 
CREATE TABLE Department (
 DeptID INT PRIMARY KEY, 
 DeptName VARCHAR(50) NOT NULL
 ); 
CREATE TABLE Student (
 StudentID INT PRIMARY KEY, 
 Name VARCHAR(100) NOT NULL,
 Email VARCHAR(100), 
 Age INT,
 DeptID INT, 
 JoiningDate DATE ); 
CREATE TABLE Enrollment (
 EnrollmentID INT PRIMARY KEY,
 StudentID INT,
 CourseName VARCHAR(100) 
 ); 
INSERT INTO Department
 VALUES (10,'Computer Science'), (20,'Information Technology'), (30,'Pharmacy'), (40,'Management'); 
INSERT INTO Student VALUES 
(101,'Amit Sharma','amit@example.com',20,10,'2026-07-01'), (102,'Priya Singh','priya@example.com',21,20,'2026-07-03'), (103,'Rahul Verma','rahul@example.com',22,30,'2026-07-05'), (104,'Neha Gupta','neha@example.com',20,10,'2026-07-08'), (105,'Arjun Mehta','arjun@example.com',23,40,'2026-07-10');
 INSERT INTO Enrollment VALUES
 (1,101,'DBMS'), (2,102,'Operating Systems'), (3,103,'Pharmacology'), (4,104,'Python');

