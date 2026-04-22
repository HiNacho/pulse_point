-- =============================================
-- PulsePoint Hospital Database - Table Creation
-- Day 003 of #100DaysOfSQL
-- =============================================

CREATE DATABASE IF NOT EXISTS pulsepoint;
USE pulsepoint;

-- 1. CLINICAL_DEPARTMENTS
CREATE TABLE IF NOT EXISTS clinical_departments (
    dept_id          VARCHAR(50)   NOT NULL,
    dept_name        VARCHAR(255)  NOT NULL,
    parent_dept_id   VARCHAR(50),                    -- Self-referencing FK (can be NULL for top-level depts)
    budget           DECIMAL(15,2),                  -- Better than VARCHAR for money
    PRIMARY KEY (dept_id)
);

-- 2. PROVIDERS
CREATE TABLE IF NOT EXISTS providers (
    provider_id      VARCHAR(50)   NOT NULL,
    first_name       VARCHAR(100)  NOT NULL,
    last_name        VARCHAR(100)  NOT NULL,
    specialty        VARCHAR(150),
    dept_id          VARCHAR(50),                    -- Will become FK later
    PRIMARY KEY (provider_id)
);

-- 3. PATIENTS
CREATE TABLE IF NOT EXISTS patients (
    patient_id          VARCHAR(50)   NOT NULL,
    first_name          VARCHAR(100)  NOT NULL,
    last_name           VARCHAR(100)  NOT NULL,
    dob                 VARCHAR(50),                  -- Keep as VARCHAR initially (messy dates)
    gender              VARCHAR(20),
    insurance_provider  VARCHAR(100),
    PRIMARY KEY (patient_id)
);

-- 4. ENCOUNTERS (Central linking table)
CREATE TABLE IF NOT EXISTS encounters (
    encounter_id     VARCHAR(50)   NOT NULL,
    patient_id       VARCHAR(50)   NOT NULL,
    provider_id      VARCHAR(50)   NOT NULL,
    dept_id          VARCHAR(50)   NOT NULL,
    encounter_date   VARCHAR(50),                  -- Will convert to DATE later
    visit_type       VARCHAR(100),
    PRIMARY KEY (encounter_id)
);

-- 5. CLINICAL_VITALS
CREATE TABLE IF NOT EXISTS clinical_vitals (
    vital_id         VARCHAR(50)   NOT NULL,
    encounter_id     VARCHAR(50)   NOT NULL,
    vital_name       VARCHAR(100)  NOT NULL,
    vital_value      VARCHAR(50),
    vital_unit       VARCHAR(20),
    PRIMARY KEY (vital_id)
);

-- 6. MEDICATIONS
CREATE TABLE IF NOT EXISTS medications (
    med_id           VARCHAR(50)   NOT NULL,
    med_name         VARCHAR(255)  NOT NULL,
    dosage_form      VARCHAR(100),
    unit_cost        DECIMAL(10,2),                -- Better for money
    PRIMARY KEY (med_id)
);

-- 7. PRESCRIPTIONS
CREATE TABLE IF NOT EXISTS prescriptions (
    rx_id            VARCHAR(50)   NOT NULL,
    patient_id       VARCHAR(50)   NOT NULL,
    med_id           VARCHAR(50)   NOT NULL,
    encounter_id     VARCHAR(50)   NOT NULL,
    start_date       VARCHAR(50),
    end_date         VARCHAR(50),
    PRIMARY KEY (rx_id)
);

-- Verification
SHOW TABLES;