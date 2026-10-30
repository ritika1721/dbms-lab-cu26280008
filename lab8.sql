
-- DATABASE SETUP

CREATE DATABASE IF NOT EXISTS Hospital_Functions_Lab;
USE Hospital_Functions_Lab;

-- Remove old tables and routines if they exist
DROP PROCEDURE IF EXISTS patient_by_gender;
DROP PROCEDURE IF EXISTS patients_above_age;
DROP PROCEDURE IF EXISTS update_medicine_stock;
DROP PROCEDURE IF EXISTS medicine_count;
DROP PROCEDURE IF EXISTS patient_report;
DROP PROCEDURE IF EXISTS medicine_report;

DROP FUNCTION IF EXISTS bmi;
DROP FUNCTION IF EXISTS age_category;
DROP FUNCTION IF EXISTS consultation_with_tax;
DROP FUNCTION IF EXISTS medicine_stock_value;

DROP TABLE IF EXISTS Patients;
DROP TABLE IF EXISTS Medicines;

-- CREATE PATIENTS TABLE

CREATE TABLE Patients (
    PatientID INT PRIMARY KEY,
    PatientName VARCHAR(50),
    Age INT,
    Gender VARCHAR(10),
    WeightKg DECIMAL(5,2),
    ConsultationFee DECIMAL(10,2)
);

-- CREATE MEDICINES TABLE

CREATE TABLE Medicines (
    MedicineID INT PRIMARY KEY,
    MedicineName VARCHAR(50),
    UnitPrice DECIMAL(10,2),
    Stock INT
);

-- INSERT PATIENT DATA

INSERT INTO Patients VALUES
(201,'Asha',24,'F',55.5,600),
(202,'Rohan',35,'M',72.0,800),
(203,'Meera',29,'F',61.5,700),
(204,'Vivek',46,'M',85.0,1000),
(205,'Nitin',17,'M',58.0,500),
(206,'Kavya',52,'F',68.0,900);

-- INSERT MEDICINE DATA

INSERT INTO Medicines VALUES
(301,'Paracetamol',25,100),
(302,'Amoxicillin',80,50),
(303,'Cetirizine',35,75),
(304,'Omeprazole',60,40),
(305,'Azithromycin',120,25);

-- VERIFY DATA

SELECT * FROM Patients;
SELECT * FROM Medicines;


-- Q1. BMI FUNCTION

DELIMITER //

CREATE FUNCTION bmi(
    weight_kg DECIMAL(5,2),
    height_m DECIMAL(5,2)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN weight_kg / (height_m * height_m);
END //

DELIMITER ;

SELECT bmi(60,1.70) AS BMI;


-- Q2. AGE CATEGORY FUNCTION

DELIMITER //

CREATE FUNCTION age_category(age INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    IF age < 18 THEN
        RETURN 'Child';
    ELSEIF age < 60 THEN
        RETURN 'Adult';
    ELSE
        RETURN 'Senior';
    END IF;
END //

DELIMITER ;

SELECT PatientName, Age, age_category(Age) AS Category
FROM Patients;


-- Q3. CONSULTATION FEE WITH TAX FUNCTION

DELIMITER //

CREATE FUNCTION consultation_with_tax(
    fee DECIMAL(10,2),
    tax_percent DECIMAL(5,2)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN fee + (fee * tax_percent / 100);
END //

DELIMITER ;

SELECT consultation_with_tax(600,18) AS TotalFee;


-- Q4. MEDICINE STOCK VALUE FUNCTION

DELIMITER //

CREATE FUNCTION medicine_stock_value(
    unit_price DECIMAL(10,2),
    stock INT
)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    RETURN unit_price * stock;
END //

DELIMITER ;

SELECT MedicineName, UnitPrice, Stock,
       medicine_stock_value(UnitPrice,Stock) AS StockValue
FROM Medicines;


-- Q5. PATIENTS BY GENDER PROCEDURE

DELIMITER //

CREATE PROCEDURE patient_by_gender(IN p_gender VARCHAR(10))
BEGIN
    SELECT * FROM Patients
    WHERE Gender = p_gender;
END //

DELIMITER ;

CALL patient_by_gender('F');
CALL patient_by_gender('M');


-- Q6. PATIENTS ABOVE AGE PROCEDURE

DELIMITER //

CREATE PROCEDURE patients_above_age(IN p_age INT)
BEGIN
    SELECT * FROM Patients
    WHERE Age > p_age;
END //

DELIMITER ;

CALL patients_above_age(25);
CALL patients_above_age(40);


-- Q7. UPDATE MEDICINE STOCK PROCEDURE

DELIMITER //

CREATE PROCEDURE update_medicine_stock(
    IN p_id INT,
    IN p_quantity INT
)
BEGIN
    UPDATE Medicines
    SET Stock = Stock + p_quantity
    WHERE MedicineID = p_id;

    SELECT * FROM Medicines
    WHERE MedicineID = p_id;
END //

DELIMITER ;

CALL update_medicine_stock(301,10);


-- Q8. MEDICINE COUNT PROCEDURE

DELIMITER //

CREATE PROCEDURE medicine_count(OUT p_count INT)
BEGIN
    SELECT COUNT(*) INTO p_count
    FROM Medicines;
END //

DELIMITER ;

CALL medicine_count(@total_medicines);
SELECT @total_medicines AS TotalMedicines;


-- Q9. PATIENT REPORT PROCEDURE

DELIMITER //

CREATE PROCEDURE patient_report()
BEGIN
    SELECT
        PatientID,
        PatientName,
        Age,
        bmi(WeightKg,1.70) AS BMI,
        age_category(Age) AS AgeCategory
    FROM Patients;
END //

DELIMITER ;

CALL patient_report();


-- Q10. MEDICINE REPORT PROCEDURE

DELIMITER //

CREATE PROCEDURE medicine_report()
BEGIN
    SELECT
        MedicineID,
        MedicineName,
        UnitPrice,
        Stock,
        medicine_stock_value(UnitPrice,Stock) AS StockValue,
        CASE
            WHEN Stock = 0 THEN 'Out of Stock'
            WHEN Stock < 30 THEN 'Low Stock'
            ELSE 'Available'
        END AS StockStatus
    FROM Medicines;
END //

DELIMITER ;

CALL medicine_report();


-- VERIFY FUNCTIONS AND PROCEDURES

SHOW FUNCTION STATUS
WHERE Db = 'Hospital_Functions_Lab';

SHOW PROCEDURE STATUS
WHERE Db = 'Hospital_Functions_Lab';

SELECT * FROM Patients;
SELECT * FROM Medicines;
