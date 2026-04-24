-- =============================================
-- PulsePoint Hospital Database - Table Creation
-- Day 003 of #100DaysOfSQL
-- =============================================

CREATE DATABASE IF NOT EXISTS pulsepoint;
USE pulsepoint;

CREATE TABLE clinical_departments (
    dept_id         VARCHAR(50) PRIMARY KEY,   -- Changed to VARCHAR for import
    dept_name       VARCHAR(255) NOT NULL UNIQUE,
    parent_dept_id  VARCHAR(50),                -- Changed to VARCHAR to accept empty CSV cells
    budget          VARCHAR(100)               -- Changed to VARCHAR
);

CREATE TABLE Providers (
	provider_id		VARCHAR(50) NOT NULL PRIMARY KEY,
    first_name		VARCHAR(50),
    last_name		VARCHAR(50),
    specialty		VARCHAR(50),
    dept_id			VARCHAR(50),
    FOREIGN KEY (dept_id) REFERENCES clinical_departments(dept_id)
    );
    
    
-- Turn off the safety switch
SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE Patients (
	patient_id		VARCHAR(50) NOT NULL PRIMARY KEY,
    first_name 		VARCHAR(50),
    last_name		VARCHAR(50),
    dob				VARCHAR(50),
    gender			VARCHAR(50),
    insurance_provider	VARCHAR(50) DEFAULT 'NA'
    );
    
    DELIMITER //

CREATE TRIGGER before_patient_insert_advanced
BEFORE INSERT ON patients
FOR EACH ROW
BEGIN
    -- This looks at the incoming 'dob' and tries 4 different "masks"
    SET NEW.dob = COALESCE(
        STR_TO_DATE(NEW.dob, '%Y-%m-%d'), -- Standard (1976-04-17)
        STR_TO_DATE(NEW.dob, '%d-%M-%y'), -- Alpha-Dash (17-April-76)
        STR_TO_DATE(NEW.dob, '%m/%d/%Y'), -- US Slashes (04/17/1976)
        STR_TO_DATE(NEW.dob, '%d-%m-%Y'), -- Euro Dashes (17-04-1976)
        NEW.dob                           -- If all fail, keep original text
    );
END //

DELIMITER //

CREATE TRIGGER trg_standardize_gender
BEFORE INSERT ON patients
FOR EACH ROW
BEGIN
    -- 1. Handle missing data (NULL or empty string)
    IF NEW.gender IS NULL OR NEW.gender = '' THEN
        SET NEW.gender = 'NA';
    
    -- 2. Standardize Male inputs
    ELSEIF NEW.gender LIKE 'm%' OR NEW.gender LIKE 'M%' THEN
        SET NEW.gender = 'Male';
    
    -- 3. Standardize Female inputs
    ELSEIF NEW.gender LIKE 'f%' OR NEW.gender LIKE 'F%' THEN
        SET NEW.gender = 'Female';
    
    -- 4. Catch-all for everything else
    ELSE
        SET NEW.gender = 'NA';
    END IF;
END //

DELIMITER ;

CREATE TABLE IF NOT EXISTS Encounters(
	encounter_id VARCHAR(50) PRIMARY KEY,
    patient_id VARCHAR(50),
    provider_id VARCHAR(50),
    dept_id VARCHAR(50),
    encounter_date VARCHAR(50) NOT NULL,
    visit_type VARCHAR(50) NOT NULL
    
    );
    
    CREATE TABLE clinical_vitals (
    vital_id INT PRIMARY KEY AUTO_INCREMENT,
    encounter_id INT NOT NULL,
    vital_name VARCHAR(50) NOT NULL,
    vital_value DECIMAL(10, 2) NOT NULL,
    vital_unit VARCHAR(20) NOT NULL
);

CREATE TABLE medications (
    med_id INT PRIMARY KEY,
    med_name VARCHAR(255) NOT NULL UNIQUE,
    dosage_form VARCHAR(50),
    unit_cost DECIMAL(10, 2) CHECK (unit_cost > 0)
);

CREATE TABLE prescriptions (
    rx_id INT PRIMARY KEY,
    patient_id INT,
    med_id INT ,
    encounter_id INT,
    start_date DATE,
    end_date DATE
);

