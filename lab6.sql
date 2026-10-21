CREATE DATABASE CollegeDB;
USE CollegeDB;

CREATE TABLE Department (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50) NOT NULL,
    Location VARCHAR(50)
);

CREATE TABLE Student (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(50) NOT NULL,
    Age INT,
    Gender VARCHAR(10),
    Marks DECIMAL(5,2),
    DeptID INT,
    Email VARCHAR(100),
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID)
);

CREATE TABLE Course (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(50) NOT NULL,
    Credits INT
);

INSERT INTO Department VALUES
(101, 'Computer Science', 'Block A'),
(102, 'Pharmacy', 'Block B'),
(103, 'Commerce', 'Block C'),
(104, 'Mathematics', 'Block D');

INSERT INTO Student VALUES
(1, 'Amit', 20, 'Male', 85.50, 101, 'amit@gmail.com'),
(2, 'Priya', 21, 'Female', 92.00, 102, 'priya@gmail.com'),
(3, 'Rahul', 19, 'Male', 76.50, 101, 'rahul@gmail.com'),
(4, 'Neha', 22, 'Female', 88.00, 103, 'neha@gmail.com'),
(5, 'Arjun', 20, 'Male', 69.50, 104, 'arjun@gmail.com'),
(6, 'Sneha', 21, 'Female', 95.00, 102, 'sneha@gmail.com'),
(7, 'Rohit', 23, 'Male', 72.00, 103, 'rohit@gmail.com'),
(8, 'Pooja', 20, 'Female', 81.00, 104, 'pooja@gmail.com');

INSERT INTO Course VALUES
(201, 'Database Management System', 4),
(202, 'Python Programming', 4),
(203, 'Mathematics', 3),
(204, 'Computer Networks', 3),
(205, 'Data Structures', 4);

DELIMITER //

CREATE PROCEDURE ShowStudents()
BEGIN
    SELECT * FROM Student;
END //

CREATE PROCEDURE ShowDepartments()
BEGIN
    SELECT * FROM Department;
END //

CREATE PROCEDURE ShowCourses()
BEGIN
    SELECT * FROM Course;
END //

CREATE PROCEDURE GetStudent(IN sid INT)
BEGIN
    SELECT * FROM Student WHERE StudentID = sid;
END //

CREATE PROCEDURE GetStudentsByDept(IN did INT)
BEGIN
    SELECT * FROM Student WHERE DeptID = did;
END //

CREATE PROCEDURE StudentsAboveMarks(IN m DECIMAL(5,2))
BEGIN
    SELECT * FROM Student WHERE Marks > m;
END //

CREATE PROCEDURE TotalStudents()
BEGIN
    SELECT COUNT(*) AS TotalStudents FROM Student;
END //

CREATE PROCEDURE CheckResult(IN sid INT)
BEGIN
    SELECT StudentName, Marks,
    IF(Marks >= 50, 'Pass', 'Fail') AS Result
    FROM Student
    WHERE StudentID = sid;
END //

CREATE PROCEDURE GetStudentsByGender(IN g VARCHAR(10))
BEGIN
    SELECT * FROM Student WHERE Gender = g;
END //

CREATE PROCEDURE StudentsBetweenMarks(
    IN m1 DECIMAL(5,2),
    IN m2 DECIMAL(5,2)
)
BEGIN
    SELECT * FROM Student WHERE Marks BETWEEN m1 AND m2;
END //

CREATE FUNCTION AddTwoNumbers(a INT, b INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN a + b;
END //

CREATE FUNCTION FindSquare(n INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN n * n;
END //

CREATE FUNCTION ResultStatus(m DECIMAL(5,2))
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    IF m >= 50 THEN
        RETURN 'Pass';
    ELSE
        RETURN 'Fail';
    END IF;
END //

CREATE FUNCTION StudentGrade(m DECIMAL(5,2))
RETURNS VARCHAR(2)
DETERMINISTIC
BEGIN
    IF m >= 90 THEN
        RETURN 'A';
    ELSEIF m >= 75 THEN
        RETURN 'B';
    ELSEIF m >= 60 THEN
        RETURN 'C';
    ELSE
        RETURN 'D';
    END IF;
END //

CREATE FUNCTION AgeCategory(a INT)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    IF a >= 18 THEN
        RETURN 'Adult';
    ELSE
        RETURN 'Minor';
    END IF;
END //

CREATE FUNCTION CalculateBonus(m DECIMAL(5,2))
RETURNS INT
DETERMINISTIC
BEGIN
    IF m >= 90 THEN
        RETURN 1000;
    ELSEIF m >= 75 THEN
        RETURN 500;
    ELSE
        RETURN 200;
    END IF;
END //

CREATE FUNCTION HigherNumber(a INT, b INT)
RETURNS INT
DETERMINISTIC
BEGIN
    IF a > b THEN
        RETURN a;
    ELSE
        RETURN b;
    END IF;
END //

CREATE FUNCTION DoubleMarks(m DECIMAL(5,2))
RETURNS DECIMAL(6,2)
DETERMINISTIC
BEGIN
    RETURN m * 2;
END //

CREATE FUNCTION AgeAfterFiveYears(a INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN a + 5;
END //

DELIMITER ;

CALL ShowStudents();
CALL ShowDepartments();
CALL ShowCourses();
CALL GetStudent(3);
CALL GetStudentsByDept(102);
CALL StudentsAboveMarks(80);
CALL TotalStudents();
CALL CheckResult(3);
CALL GetStudentsByGender('Female');
CALL StudentsBetweenMarks(70, 90);

SELECT AddTwoNumbers(10, 20);
SELECT FindSquare(5);
SELECT ResultStatus(75);
SELECT StudentGrade(85);
SELECT AgeCategory(20);
SELECT CalculateBonus(85);
SELECT HigherNumber(10, 20);
SELECT DoubleMarks(40);
SELECT AgeAfterFiveYears(20);

SELECT StudentName, Marks, StudentGrade(Marks) AS Grade
FROM Student;