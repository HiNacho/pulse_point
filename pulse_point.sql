-- =============================================
-- PulsePoint Hospital Database - Table Creation
-- Day 003 of #100DaysOfSQL
-- =============================================

CREATE DATABASE IF NOT EXISTS pulsepoint;
USE pulsepoint;

CREATE TABLE clinical_departments (
    dept_id         INT PRIMARY KEY,   -- Changed to VARCHAR for import
    dept_name       VARCHAR(255) NOT NULL UNIQUE,
    parent_dept_id  VARCHAR(50),                -- Changed to VARCHAR to accept empty CSV cells
    budget          INT               -- Changed to VARCHAR
);

CREATE TABLE Providers (
	provider_id		INT PRIMARY KEY,
    first_name		VARCHAR(50),
    last_name		VARCHAR(50),
    specialty		VARCHAR(50),
    dept_id			INT,
    FOREIGN KEY (dept_id) REFERENCES clinical_departments(dept_id)
    );

CREATE TABLE Patients (
	patient_id		INT PRIMARY KEY,
    first_name 		VARCHAR(50),
    last_name		VARCHAR(50),
    dob				VARCHAR(50),
    gender			VARCHAR(50),
    insurance_provider	VARCHAR(50) DEFAULT 'NA'
    );
    
    -- 1. Preparation
SET SQL_SAFE_UPDATES = 0;
SET lc_time_names = 'en_US'; -- Force English month names (fixes 'Aug')
SET @old_sql_mode = @@sql_mode;
SET sql_mode = ''; -- Temporarily disable strict mode to prevent the 1411 crash

-- 2. The Master Update
UPDATE Patients 
SET 
    gender = CASE 
        WHEN gender LIKE 'm%' OR gender = 'M' THEN 'Male'
        WHEN gender LIKE 'f%' OR gender = 'F' THEN 'Female'
        WHEN gender IS NULL OR gender = '' OR gender = 'NaN' THEN 'NA'
        ELSE 'NA' 
    END,

    dob = COALESCE(
        STR_TO_DATE(dob, '%Y-%m-%d'), -- Pattern: 1954-09-29
        STR_TO_DATE(dob, '%d-%b-%y'), -- Pattern: 02-Aug-42
        STR_TO_DATE(dob, '%m/%d/%Y'), -- Pattern: 01/26/1990
        STR_TO_DATE(dob, '%d/%m/%Y'), -- Pattern: 04/08/2001
        dob                           -- If all fail, keep original text
    );
    
    
SELECT * FROM Patients;

-- 3. Cleanup
SET sql_mode = @old_sql_mode; -- Restore safety settings

CREATE TABLE IF NOT EXISTS Encounters(
	encounter_id INT PRIMARY KEY,
    patient_id INT,
    provider_id INT,
    dept_id INT,
    encounter_date VARCHAR(50) NOT NULL,
    visit_type VARCHAR(50) NOT NULL,
    
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (provider_id) REFERENCES Providers(provider_id),
    FOREIGN key (dept_id) REFERENCES clinical_departments(dept_id)
    );
    
    CREATE TABLE clinical_vitals (
    vital_id INT PRIMARY KEY AUTO_INCREMENT,
    encounter_id INT,
    vital_name VARCHAR(50) NOT NULL,
    vital_value DECIMAL(10, 2) NOT NULL,
    vital_unit VARCHAR(20) NOT NULL,
    
    FOREIGN KEY (encounter_id) REFERENCES Encounters(encounter_id)
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
    end_date DATE,
    
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (med_id) REFERENCES medications(med_id),
    FOREIGN KEY (encounter_id) REFERENCES Encounters(encounter_id)
);

-- 1. Hardening clinical_departments
-- Convert budget to DECIMAL so we can perform SUM() and AVG()
UPDATE clinical_departments SET budget = REPLACE(REPLACE(budget, '$', ''), ',', '');
ALTER TABLE clinical_departments 
    MODIFY COLUMN budget DECIMAL(15, 2);
    
-- 2. Clean the Encounters table
-- We use LEFT(encounter_date, 10) to grab '2024-02-19' and ignore the time
UPDATE Encounters 
SET encounter_date = STR_TO_DATE(LEFT(encounter_date, 10), '%Y-%m-%d');


SELECT patient_id, COUNT(*) patient_visit
FROM Encounters
GROUP BY patient_id


