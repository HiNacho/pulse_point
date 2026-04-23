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
-- Verification
SHOW TABLES;