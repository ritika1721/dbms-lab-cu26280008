

CREATE DATABASE Hospital_Cursor_Trigger_Lab;
USE Hospital_Cursor_Trigger_Lab;


CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY,
    DoctorName VARCHAR(50),
    Department VARCHAR(50),
    ConsultationFee DECIMAL(10,2),
    Status VARCHAR(20)
);


INSERT INTO Doctors VALUES
(201, 'Dr. Anil', 'Cardiology', 1200, 'Active'),
(202, 'Dr. Beena', 'Pediatrics', 900, 'Active'),
(203, 'Dr. Chirag', 'Neurology', 1500, 'Active'),
(204, 'Dr. Divya', 'Dermatology', 1000, 'Active'),
(205, 'Dr. Eshan', 'Cardiology', 1300, 'Active'),
(206, 'Dr. Farah', 'Pediatrics', 850, 'Active');

CREATE TABLE Doctor_Audit (
    AuditID INT AUTO_INCREMENT PRIMARY KEY,
    DoctorID INT,
    ActionType VARCHAR(30),
    OldFee DECIMAL(10,2),
    NewFee DECIMAL(10,2),
    ActionTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE Fee_Log (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    DoctorID INT,
    DoctorName VARCHAR(50),
    OldFee DECIMAL(10,2),
    NewFee DECIMAL(10,2),
    ChangedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


SELECT * FROM Doctors;
SELECT * FROM Doctor_Audit;
SELECT * FROM Fee_Log;


-- 1. Display DoctorID and DoctorName of Every Doctor

DELIMITER //

CREATE PROCEDURE DisplayDoctors()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_id INT;
    DECLARE v_name VARCHAR(50);

    DECLARE cur CURSOR FOR
        SELECT DoctorID, DoctorName FROM Doctors;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_id, v_name;

        IF done THEN
            LEAVE read_loop;
        END IF;

        SELECT v_id AS DoctorID, v_name AS DoctorName;
    END LOOP;

    CLOSE cur;
END //

DELIMITER ;

CALL DisplayDoctors();


-- 2. Display Doctors Whose ConsultationFee Is Greater Than 1000

DELIMITER //
CREATE PROCEDURE HighFeeDoctors()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_id INT;
    DECLARE v_name VARCHAR(50);
    DECLARE v_fee DECIMAL(10,2);

    DECLARE cur CURSOR FOR
        SELECT DoctorID, DoctorName, ConsultationFee
        FROM Doctors
        WHERE ConsultationFee > 1000;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_id, v_name, v_fee;

        IF done THEN
            LEAVE read_loop;
        END IF;

        SELECT v_id AS DoctorID, v_name AS DoctorName,
               v_fee AS ConsultationFee;
    END LOOP;

    CLOSE cur;
END //

DELIMITER ;

CALL HighFeeDoctors();


-- 3. Calculate Total ConsultationFee Using OUT Parameter

DELIMITER //
CREATE PROCEDURE TotalConsultationFee(OUT total DECIMAL(10,2))
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_fee DECIMAL(10,2);
    DECLARE total_fee DECIMAL(10,2) DEFAULT 0;

    DECLARE cur CURSOR FOR
        SELECT ConsultationFee FROM Doctors;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_fee;

        IF done THEN
            LEAVE read_loop;
        END IF;

        SET total_fee = total_fee + v_fee;
    END LOOP;

    CLOSE cur;

    SET total = total_fee;
END //

DELIMITER ;

CALL TotalConsultationFee(@total);
SELECT @total AS TotalConsultationFee;


-- 4. Count Cardiology Doctors Using OUT Parameter

DELIMITER //

CREATE PROCEDURE CountCardiologyDoctors(OUT total INT)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_dept VARCHAR(50);
    DECLARE counter INT DEFAULT 0;

    DECLARE cur CURSOR FOR
        SELECT Department FROM Doctors;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_dept;

        IF done THEN
            LEAVE read_loop;
        END IF;

        IF v_dept = 'Cardiology' THEN
            SET counter = counter + 1;
        END IF;
    END LOOP;

    CLOSE cur;

    SET total = counter;
END //

DELIMITER ;

CALL CountCardiologyDoctors(@total);
SELECT @total AS CardiologyDoctors;


-- 5. Calculate Average ConsultationFee

DELIMITER //

CREATE PROCEDURE AverageConsultationFee()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_fee DECIMAL(10,2);
    DECLARE total_fee DECIMAL(10,2) DEFAULT 0;
    DECLARE counter INT DEFAULT 0;

    DECLARE cur CURSOR FOR
        SELECT ConsultationFee FROM Doctors;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_fee;

        IF done THEN
            LEAVE read_loop;
        END IF;

        SET total_fee = total_fee + v_fee;
        SET counter = counter + 1;
    END LOOP;

    CLOSE cur;

    IF counter = 0 THEN
        SELECT 'No doctors available' AS Message;
    ELSE
        SELECT total_fee / counter AS AverageConsultationFee;
    END IF;
END //

DELIMITER ;

CALL AverageConsultationFee();


-- 6. Increase Pediatrics ConsultationFee by 10%

DELIMITER //

CREATE PROCEDURE IncreasePediatricsFee()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_id INT;

    DECLARE cur CURSOR FOR
        SELECT DoctorID FROM Doctors
        WHERE Department = 'Pediatrics';

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_id;

        IF done THEN
            LEAVE read_loop;
        END IF;

        UPDATE Doctors
        SET ConsultationFee = ConsultationFee * 1.10
        WHERE DoctorID = v_id;
    END LOOP;

    CLOSE cur;
END //

DELIMITER ;

CALL IncreasePediatricsFee();
SELECT * FROM Doctors;


-- 7. Change Status to Review for Doctors with Fee Below 1000

DELIMITER //

CREATE PROCEDURE ReviewLowFeeDoctors()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_id INT;

    DECLARE cur CURSOR FOR
        SELECT DoctorID FROM Doctors
        WHERE ConsultationFee < 1000;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_id;

        IF done THEN
            LEAVE read_loop;
        END IF;

        UPDATE Doctors
        SET Status = 'Review'
        WHERE DoctorID = v_id;
    END LOOP;

    CLOSE cur;
END //

DELIMITER ;

CALL ReviewLowFeeDoctors();
SELECT * FROM Doctors;


-- 8. Display Doctor Report Ordered by Department and DoctorName

DELIMITER //

CREATE PROCEDURE DoctorReport()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_name VARCHAR(50);
    DECLARE v_dept VARCHAR(50);
    DECLARE v_fee DECIMAL(10,2);

    DECLARE cur CURSOR FOR
        SELECT DoctorName, Department, ConsultationFee
        FROM Doctors
        ORDER BY Department, DoctorName;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_name, v_dept, v_fee;

        IF done THEN
            LEAVE read_loop;
        END IF;

        SELECT v_name AS DoctorName, v_dept AS Department,
               v_fee AS ConsultationFee;
    END LOOP;

    CLOSE cur;
END //

DELIMITER ;

CALL DoctorReport();


-- 9. Count Active Doctors Using OUT Parameter

DELIMITER //

CREATE PROCEDURE CountActiveDoctors(OUT total INT)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_status VARCHAR(20);
    DECLARE counter INT DEFAULT 0;

    DECLARE cur CURSOR FOR
        SELECT Status FROM Doctors;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_status;

        IF done THEN
            LEAVE read_loop;
        END IF;

        IF v_status = 'Active' THEN
            SET counter = counter + 1;
        END IF;
    END LOOP;

    CLOSE cur;

    SET total = counter;
END //

DELIMITER ;

CALL CountActiveDoctors(@total);
SELECT @total AS ActiveDoctors;


-- 10. Increase Fee by 5% for Doctors with Fee at Least 1200

DELIMITER //

CREATE PROCEDURE IncreaseHighFees()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_id INT;

    DECLARE cur CURSOR FOR
        SELECT DoctorID FROM Doctors
        WHERE ConsultationFee >= 1200;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO v_id;

        IF done THEN
            LEAVE read_loop;
        END IF;

        UPDATE Doctors
        SET ConsultationFee = ConsultationFee * 1.05
        WHERE DoctorID = v_id;
    END LOOP;

    CLOSE cur;
END //

DELIMITER ;

CALL IncreaseHighFees();
SELECT * FROM Doctors;



-- 1. AFTER INSERT Trigger to Record New Doctor

DELIMITER //

CREATE TRIGGER AfterDoctorInsert
AFTER INSERT ON Doctors
FOR EACH ROW
BEGIN
    INSERT INTO Doctor_Audit
    (DoctorID, ActionType, OldFee, NewFee)
    VALUES
    (NEW.DoctorID, 'INSERT', NULL, NEW.ConsultationFee);
END //

DELIMITER ;

INSERT INTO Doctors VALUES
(207, 'Dr. Gita', 'Cardiology', 1100, 'Active');

SELECT * FROM Doctor_Audit;


-- 2. AFTER UPDATE Trigger to Record Old and New Fees

DELIMITER //

CREATE TRIGGER AfterDoctorFeeUpdate
AFTER UPDATE ON Doctors
FOR EACH ROW
BEGIN
    IF OLD.ConsultationFee <> NEW.ConsultationFee THEN
        INSERT INTO Doctor_Audit
        (DoctorID, ActionType, OldFee, NewFee)
        VALUES
        (NEW.DoctorID, 'UPDATE', OLD.ConsultationFee,
         NEW.ConsultationFee);
    END IF;
END //

DELIMITER ;

UPDATE Doctors
SET ConsultationFee = 1400
WHERE DoctorID = 201;

SELECT * FROM Doctor_Audit;


-- 3. BEFORE INSERT Trigger to Convert DoctorName to Uppercase

DELIMITER //

CREATE TRIGGER BeforeDoctorInsertUppercase
BEFORE INSERT ON Doctors
FOR EACH ROW
BEGIN
    SET NEW.DoctorName = UPPER(NEW.DoctorName);
END //

DELIMITER ;

INSERT INTO Doctors VALUES
(208, 'dr. test', 'Neurology', 800, 'Active');

SELECT * FROM Doctors WHERE DoctorID = 208;


-- 4. BEFORE INSERT Trigger to Prevent Negative ConsultationFee

DELIMITER //

CREATE TRIGGER BeforeDoctorInsertFeeCheck
BEFORE INSERT ON Doctors
FOR EACH ROW
BEGIN
    IF NEW.ConsultationFee < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ConsultationFee cannot be negative';
    END IF;
END //

DELIMITER ;

-- Test with a valid fee first
INSERT INTO Doctors VALUES
(209, 'Dr. Test2', 'Dermatology', 700, 'Active');

-- This query should generate an error
-- Uncomment only when testing the validation
-- INSERT INTO Doctors VALUES
-- (210, 'Dr. Invalid', 'Cardiology', -500, 'Active');


-- 5. AFTER DELETE Trigger to Record Deleted Doctor

DELIMITER //

CREATE TRIGGER AfterDoctorDelete
AFTER DELETE ON Doctors
FOR EACH ROW
BEGIN
    INSERT INTO Doctor_Audit
    (DoctorID, ActionType, OldFee, NewFee)
    VALUES
    (OLD.DoctorID, 'DELETE', OLD.ConsultationFee, NULL);
END //

DELIMITER ;

DELETE FROM Doctors
WHERE DoctorID = 209;

SELECT * FROM Doctor_Audit;


-- 6. AFTER UPDATE Trigger to Store Changed Fees in Fee_Log

DELIMITER //

CREATE TRIGGER AfterFeeLogUpdate
AFTER UPDATE ON Doctors
FOR EACH ROW
BEGIN
    IF OLD.ConsultationFee <> NEW.ConsultationFee THEN
        INSERT INTO Fee_Log
        (DoctorID, DoctorName, OldFee, NewFee)
        VALUES
        (NEW.DoctorID, NEW.DoctorName,
         OLD.ConsultationFee, NEW.ConsultationFee);
    END IF;
END //

DELIMITER ;

UPDATE Doctors
SET ConsultationFee = 1600
WHERE DoctorID = 203;

SELECT * FROM Fee_Log;


-- 7. BEFORE UPDATE Trigger to Prevent Negative ConsultationFee

DELIMITER //

CREATE TRIGGER BeforeDoctorUpdateFeeCheck
BEFORE UPDATE ON Doctors
FOR EACH ROW
BEGIN
    IF NEW.ConsultationFee < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ConsultationFee cannot be negative';
    END IF;
END //

DELIMITER ;

-- This query should generate an error
-- Uncomment only when testing the validation
-- UPDATE Doctors SET ConsultationFee = -100
-- WHERE DoctorID = 201;


-- 8. BEFORE UPDATE Trigger to Normalize Status

DELIMITER //

CREATE TRIGGER BeforeDoctorStatusUpdate
BEFORE UPDATE ON Doctors
FOR EACH ROW
BEGIN
    IF LOWER(NEW.Status) = 'active' THEN
        SET NEW.Status = 'Active';
    END IF;
END //

DELIMITER ;

UPDATE Doctors
SET Status = 'active'
WHERE DoctorID = 201;

SELECT * FROM Doctors WHERE DoctorID = 201;


-- 9. AFTER UPDATE Trigger to Record Department Changes

ALTER TABLE Doctor_Audit
ADD OldDepartment VARCHAR(50),
ADD NewDepartment VARCHAR(50);

DELIMITER //

CREATE TRIGGER AfterDoctorDepartmentUpdate
AFTER UPDATE ON Doctors
FOR EACH ROW
BEGIN
    IF NOT (OLD.Department <=> NEW.Department) THEN
        INSERT INTO Doctor_Audit
        (DoctorID, ActionType, OldDepartment, NewDepartment)
        VALUES
        (NEW.DoctorID, 'DEPARTMENT_CHANGE',
         OLD.Department, NEW.Department);
    END IF;
END //

DELIMITER ;

UPDATE Doctors
SET Department = 'Neurology'
WHERE DoctorID = 201;

SELECT * FROM Doctor_Audit;


-- 10. BEFORE INSERT Trigger to Validate DoctorName

DELIMITER //

CREATE TRIGGER BeforeDoctorNameCheck
BEFORE INSERT ON Doctors
FOR EACH ROW
BEGIN
    IF NEW.DoctorName IS NULL OR TRIM(NEW.DoctorName) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'DoctorName cannot be empty';
    END IF;
END //

DELIMITER ;

-- Verify Trigger Results

SHOW TRIGGERS;

SELECT * FROM Doctors;
SELECT * FROM Doctor_Audit;
SELECT * FROM Fee_Log;


