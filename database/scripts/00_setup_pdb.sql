-- ============================================================================
-- PHARMACY MANAGEMENT SYSTEM - PDB SETUP SCRIPT
-- Author: Uwitonze Pacific (ID: 26983)
-- Purpose: Create Pluggable Database and User for Pharmacy Management System
-- ============================================================================
--
-- INSTRUCTIONS FOR SQL DEVELOPER:
-- 1. Connect to CDB as SYSDBA (sys as sysdba)
-- 2. Run this entire script
-- 3. After completion, create a new connection in SQL Developer:
--    - Connection Name: Pharmacy_User
--    - Username: pharmacy_user
--    - Password: pharmacy_pass
--    - Connection Type: Basic
--    - Hostname: localhost
--    - Port: 1521
--    - Service name: mon_26983_pacific_pharmacy_db
-- ============================================================================

-- ============================================================================
-- STEP 0: CHECK AND OPEN CDB IF NEEDED
-- ============================================================================

-- Check database status
SELECT name, open_mode, database_role FROM v$database;

-- If database is MOUNTED but not OPEN, open it
ALTER DATABASE OPEN;

-- Verify database is now open
SELECT name, open_mode FROM v$database;

PROMPT
PROMPT ============================================================================
PROMPT Database is now OPEN
PROMPT ============================================================================
PROMPT

-- ============================================================================
-- STEP 1: CREATE PLUGGABLE DATABASE
-- ============================================================================

-- Create the PDB
CREATE PLUGGABLE DATABASE mon_26983_pacific_pharmacy_db
ADMIN USER pacific IDENTIFIED BY "Pacific"
FILE_NAME_CONVERT=(
    'C:\APP\HP\PRODUCT\21C\ORADATA\XE\PDBSEED\',
    'C:\APP\HP\PRODUCT\21C\ORADATA\XE\MON_26983_PACIFIC_PHARMACY_DB\'
);

PROMPT
PROMPT ============================================================================
PROMPT PDB Created Successfully
PROMPT ============================================================================
PROMPT

-- Verify PDB creation
SELECT pdb_name, status FROM dba_pdbs WHERE pdb_name = 'MON_26983_PACIFIC_PHARMACY_DB';

-- ============================================================================
-- STEP 2: OPEN THE PDB
-- ============================================================================

-- Open the PDB
ALTER PLUGGABLE DATABASE mon_26983_pacific_pharmacy_db OPEN;

PROMPT
PROMPT ============================================================================
PROMPT PDB Opened Successfully
PROMPT ============================================================================
PROMPT

-- Verify PDB is open
SELECT name, open_mode FROM v$pdbs WHERE name = 'MON_26983_PACIFIC_PHARMACY_DB';

-- ============================================================================
-- STEP 3: SAVE PDB STATE (Auto-open on restart)
-- ============================================================================

-- Save state so PDB opens automatically after database restart
ALTER PLUGGABLE DATABASE mon_26983_pacific_pharmacy_db SAVE STATE;

PROMPT
PROMPT ============================================================================
PROMPT PDB State Saved
PROMPT ============================================================================
PROMPT

-- ============================================================================
-- STEP 4: SWITCH TO THE PDB
-- ============================================================================

-- Switch session to the new PDB
ALTER SESSION SET CONTAINER = mon_26983_pacific_pharmacy_db;

-- Verify you're in the correct PDB
SELECT SYS_CONTEXT('USERENV', 'CON_NAME') AS current_container FROM dual;

PROMPT
PROMPT ============================================================================
PROMPT Switched to PDB Container
PROMPT ============================================================================
PROMPT

-- ============================================================================
-- STEP 5: CREATE APPLICATION USER
-- ============================================================================

-- Create the pharmacy user
CREATE USER pharmacy_user IDENTIFIED BY pharmacy_pass
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP
QUOTA UNLIMITED ON USERS;

PROMPT User 'pharmacy_user' created successfully

-- Grant necessary privileges
GRANT CONNECT TO pharmacy_user;
GRANT RESOURCE TO pharmacy_user;
GRANT CREATE VIEW TO pharmacy_user;
GRANT CREATE SYNONYM TO pharmacy_user;
GRANT CREATE DATABASE LINK TO pharmacy_user;

-- Grant additional privileges for development
GRANT CREATE SESSION TO pharmacy_user;
GRANT CREATE TABLE TO pharmacy_user;
GRANT CREATE SEQUENCE TO pharmacy_user;
GRANT CREATE TRIGGER TO pharmacy_user;
GRANT CREATE PROCEDURE TO pharmacy_user;
GRANT CREATE TYPE TO pharmacy_user;

-- Grant DBA privileges (for development/testing only - remove in production)
GRANT DBA TO pharmacy_user;

PROMPT Privileges granted to 'pharmacy_user'

-- ============================================================================
-- STEP 6: VERIFY USER CREATION
-- ============================================================================

-- Check user exists
SELECT username, account_status, default_tablespace
FROM dba_users
WHERE username = 'PHARMACY_USER';

-- Check user privileges
SELECT privilege FROM dba_sys_privs WHERE grantee = 'PHARMACY_USER' ORDER BY privilege;

-- ============================================================================
-- STEP 7: CREATE ADDITIONAL USERS (OPTIONAL)
-- ============================================================================

-- Create read-only user for reports
CREATE USER pharmacy_report IDENTIFIED BY report_pass
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP;

GRANT CONNECT TO pharmacy_report;
GRANT CREATE SESSION TO pharmacy_report;

PROMPT User 'pharmacy_report' created successfully

-- Grant SELECT on all tables (will be granted after tables are created)
-- GRANT SELECT ON pharmacy_user.doctor TO pharmacy_report;
-- GRANT SELECT ON pharmacy_user.patient TO pharmacy_report;
-- etc.

-- ============================================================================
-- SETUP COMPLETE
-- ============================================================================

PROMPT
PROMPT ============================================================================
PROMPT PDB Setup Complete!
PROMPT ============================================================================
PROMPT
PROMPT PDB Name: mon_26983_pacific_pharmacy_db
PROMPT Admin User: pacific / pacific
PROMPT App User: pharmacy_user / pharmacy_pass
PROMPT Report User: pharmacy_report / report_pass
PROMPT
PROMPT NEXT STEPS:
PROMPT 1. Create a new connection in SQL Developer for pharmacy_user:
PROMPT    - Username: pharmacy_user
PROMPT    - Password: pharmacy_pass
PROMPT    - Service name: mon_26983_pacific_pharmacy_db
PROMPT 2. Connect as pharmacy_user
PROMPT 3. Run scripts in order:
PROMPT    - 01_create_tables.sql
PROMPT    - 02_insert_data.sql
PROMPT    - 03_procedures.sql
PROMPT    - 04_triggers.sql
PROMPT ============================================================================
PROMPT

-- ============================================================================
-- VERIFICATION QUERIES
-- ============================================================================

-- Show current container
SELECT SYS_CONTEXT('USERENV', 'CON_NAME') AS current_pdb FROM dual;

-- Show all PDBs and their status
SELECT pdb_id, pdb_name, status, open_mode
FROM dba_pdbs
ORDER BY pdb_id;

-- Show tablespace usage
SELECT tablespace_name, file_name, bytes/1024/1024 AS size_mb
FROM dba_data_files
WHERE tablespace_name = 'USERS';

-- ============================================================================
-- TROUBLESHOOTING COMMANDS (DO NOT RUN - FOR REFERENCE ONLY)
-- ============================================================================

/*
-- If you get ORA-01109: database not open
-- Connect as SYSDBA and run:
STARTUP;
-- or
ALTER DATABASE OPEN;

-- If PDB already exists and you want to drop it:
ALTER PLUGGABLE DATABASE mon_26983_pacific_pharmacy_db CLOSE IMMEDIATE;
DROP PLUGGABLE DATABASE mon_26983_pacific_pharmacy_db INCLUDING DATAFILES;

-- If you need to recreate the user:
DROP USER pharmacy_user CASCADE;

-- To check file locations:
SELECT name FROM v$datafile WHERE con_id = (
    SELECT con_id FROM v$pdbs WHERE name = 'MON_26983_PACIFIC_PHARMACY_DB'
);

-- To manually open PDB after restart:
ALTER PLUGGABLE DATABASE mon_26983_pacific_pharmacy_db OPEN;

-- To close PDB:
ALTER PLUGGABLE DATABASE mon_26983_pacific_pharmacy_db CLOSE IMMEDIATE;

-- To check PDB status:
SELECT name, open_mode FROM v$pdbs;

-- To check if database is open:
SELECT name, open_mode, database_role FROM v$database;

-- To startup database:
STARTUP;

-- To shutdown database:
SHUTDOWN IMMEDIATE;
*/

-- ============================================================================
-- End of Script
-- ============================================================================
