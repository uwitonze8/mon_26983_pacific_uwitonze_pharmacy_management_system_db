-- ============================================================================
-- CREATE APPLICATION USER
-- Author: Uwitonze Pacific (ID: 26983)
-- Run this as SYS after PDB is created
-- ============================================================================

-- Connect to the PDB
ALTER SESSION SET CONTAINER = mon_26983_pacific_pharmacy_db;

-- Check available tablespaces
SELECT tablespace_name FROM dba_tablespaces;

-- Create application user (using SYSTEM tablespace)
CREATE USER pharmacy_user IDENTIFIED BY pharmacy_pass
DEFAULT TABLESPACE SYSTEM
TEMPORARY TABLESPACE TEMP
QUOTA UNLIMITED ON SYSTEM;

-- Grant privileges
GRANT CONNECT, RESOURCE, DBA TO pharmacy_user;
GRANT CREATE SESSION, CREATE TABLE, CREATE SEQUENCE TO pharmacy_user;
GRANT CREATE TRIGGER, CREATE PROCEDURE, CREATE VIEW TO pharmacy_user;

-- Verify user creation
SELECT username, account_status, default_tablespace
FROM dba_users
WHERE username = 'PHARMACY_USER';

-- ============================================================================
-- User created successfully!
-- ============================================================================
-- Username: pharmacy_user
-- Password: pharmacy_pass
-- Service name: mon_26983_pacific_pharmacy_db
-- ============================================================================
