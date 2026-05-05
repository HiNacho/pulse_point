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


-- SELECT patient_id, COUNT(*) patient_visit
-- FROM Encounters
-- GROUP BY patient_id

SELECT p.first_name, e.visit_type
FROM Patients p 
INNER JOIN Encounters e
ON p.patient_id = e.patient_id
LIMIT 10;

-- SELECT p.first_name, e.visit_type
-- FROM Patients p 
-- LEFT JOIN Encounters e
-- ON p.patient_id = e.patient_id
-- LIMIT 30

SELECT p.first_name, pr.first_name, e.encounter_date
FROM Patients p
INNER JOIN Encounters e
ON p.patient_id = e.patient_id
INNER JOIN Providers pr
ON e.provider_id = pr.provider_id;

SELECT * FROM Encounters;

SELECT p.first_name, p.last_name, e.visit_type
FROM Patients p
LEFT JOIN Encounters e
ON p.patient_id = e.patient_id;

SELECT * FROM clinical_departments;

SELECT 
    sub.dept_name AS "Department", 
    head.dept_name AS "Parent Department"
FROM clinical_departments AS sub
INNER JOIN clinical_departments AS head 
    ON sub.parent_dept_id = head.dept_id;
    
SELECT * FROM clinical_departments;

-- High-Coverage Analysis: Find all patients using 'Aetna' insurance to evaluate partnership volume.-- 
SELECT first_name,last_name,gender
FROM Patients
WHERE insurance_provider = "Aetna";

-- Gender Distribution: Filter patients by gender (e.g., 'F') to analyze specialized care needs.
SELECT first_name, last_name 
FROM Patients
WHERE gender = "Female";

-- Senior Care Identification: Select patients born before 1960 to identify those eligible for geriatric programs.
SELECT * 
FROM Patients;

-- Senior Care Identification: Select patients born before 1960 to identify those eligible for geriatric programs.
SELECT 
DATE_FORMAT(dob,"%Y") AS dob, first_name, first_name
FROM Patients
WHERE dob < 1960;

-- Unknown Demographics: Find patients where gender is NULL to identify records needing data cleaning.
SELECT *
FROM Patients
WHERE gender = 'NA';

-- Specific Insurance Cohorts: List all patients under 'BlueShield' to check for specific plan benefits.
SELECT first_name, last_name
FROM Patients 
WHERE insurance_provider = 'BlueShield';

-- Emergency Room Load: Filter the Encounters table for visit_type = 'ER' to see how many emergency visits were recorded.
SELECT *
FROM Encounters
WHERE visit_type = 'ER';

-- Inpatient Status: Select all encounters where the visit type is 'Inpatient' to track hospital bed occupancy.

-- Date-Specific Volume: Select encounters that happened on a specific day (e.g., '2023-11-11') to check for daily spikes.
SELECT provider_id, dept_id, DATE_FORMAT(encounter_date,'%Y') AS e_date
FROM Encounters
WHERE DATE_FORMAT(encounter_date,'%Y') = 2023;

SELECT provider_id, dept_id, DATE_FORMAT(encounter_date,'%Y') AS e_date
FROM Encounters
WHERE DATE_FORMAT(encounter_date,'%Y-%m-%d') = '2023-12-13';

-- Hypertensive Crisis Alert: Find patients in the Vitals table with a vital_name = 'BP_Systolic' and a vital_value > 180.
SELECT * 
FROM clinical_vitals
WHERE vital_name = 'BP_Systolic' AND vital_value > 180;

SELECT p.first_name,p.last_name, p.specialty,e.patient_id,pt.last_name,pt.first_name
FROM Patients pt
LEFT JOIN Encounters e
ON pt.patient_id = e.patient_id
LEFT JOIN Providers p
ON e.provider_id = p.provider_id
WHERE p.specialty = "Cardiologist";

-- Overworked Departments: Identify departments that have handled more than 500 total encounters.
SELECT dept_id, COUNT(dept_id) AS Number_of_encounters 
FROM Encounters
GROUP BY dept_id
HAVING COUNT(dept_id) > 500
ORDER BY Number_of_encounters DESC;

-- High-Value Providers: Find providers who have written prescriptions totaling a cost of more than $1,000 across all their patients.
SELECT 
    e.provider_id, 
    SUM(m.unit_cost) AS total_prescribed_cost
FROM Encounters e
JOIN Prescriptions p ON e.encounter_id = p.encounter_id
JOIN Medications m ON p.med_id = m.med_id
GROUP BY e.provider_id
HAVING SUM(m.unit_cost) > 1000
ORDER BY total_prescribed_cost DESC;

-- Count encounters per patient where the visit type was 'ER', but only for patients with more than 5 emergency visits.

SELECT
DISTINCT patient_id, COUNT(patient_id) AS frequency ,visit_type
FROM Encounters
WHERE visit_type = 'ER'
GROUP BY patient_id, visit_type
HAVING frequency  > 5
ORDER BY frequency DESC;


SELECT dept_id, COUNT(dept_id) AS encounter_numbers
FROM Encounters
WHERE DATE_FORMAT(encounter_date,"%Y") = 2024
GROUP BY dept_id;

SELECT e.provider_id,COUNT(m.med_id) AS metformin_prescription
FROM Encounters e
LEFT JOIN Prescriptions p ON e.patient_id = p.patient_id
LEFT JOIN medications m ON p.med_id = m.med_id
GROUP BY e.provider_id, m.med_id
HAVING m.med_id = 1 AND metformin_prescription > 450
ORDER BY metformin_prescription DESC

