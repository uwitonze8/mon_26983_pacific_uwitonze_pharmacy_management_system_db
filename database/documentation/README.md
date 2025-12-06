# Database Scripts Documentation

> Guide for executing and maintaining Pharmacy Management System database scripts

---

## Script Execution Order

Execute scripts in the following order for a fresh installation:

| Order | Script | Description |
|-------|--------|-------------|
| 1 | `01_create_tables.sql` | Creates all tables, sequences, and indexes |
| 2 | `02_insert_data.sql` | Populates tables with sample data |
| 3 | `03_procedures.sql` | Creates packages, procedures, and functions |
| 4 | `04_triggers.sql` | Creates all database triggers |

---

## Prerequisites

Before running the scripts, ensure:

1. Oracle Database 21c is installed and running
2. Pluggable database `mon_26983_pacific_pharmacy_db` is created and open
3. User has appropriate privileges (CONNECT, RESOURCE, CREATE TRIGGER)

```sql
-- Connect to the PDB
ALTER SESSION SET CONTAINER = mon_26983_pacific_pharmacy_db;

-- Verify connection
SELECT SYS_CONTEXT('USERENV', 'CON_NAME') FROM dual;
```

---

## Script Details

### 01_create_tables.sql

Creates the following database objects:

**Sequences:**
- seq_doctor_id, seq_patient_id, seq_medicine_id
- seq_prescription_id, seq_item_id, seq_pharmacist_id
- seq_dispensed_id, seq_payment_id, seq_log_id, seq_audit_id

**Tables:**
- doctor, patient, medicine, pharmacist
- prescription, prescription_items
- dispensed_medicines, payment
- inventory_log, audit_log

**Indexes:**
- idx_prescription_status, idx_prescription_date
- idx_medicine_category, idx_medicine_stock
- idx_payment_date, idx_payment_status
- idx_inventory_log_date

### 02_insert_data.sql

Inserts sample data:
- 5 doctors
- 5 patients
- 3 pharmacists
- 10 medicines
- 5 prescriptions with items
- 3 dispensing records
- 4 payments
- 5 inventory log entries

### 03_procedures.sql

Creates the `pharmacy_pkg` package with:

**Procedures:**
- process_prescription
- generate_inventory_report
- get_patient_history
- add_prescription
- add_prescription_item
- update_stock

**Functions:**
- calculate_prescription_total
- get_stock_status

**Cursors:**
- c_active_prescriptions
- c_low_stock_medicines

**Standalone Procedures:**
- process_payment

### 04_triggers.sql

Creates the following triggers:

| Trigger | Table | Event | Purpose |
|---------|-------|-------|---------|
| trg_dispense_medicine | dispensed_medicines | AFTER INSERT | Auto-update stock |
| trg_low_stock_alert | medicine | AFTER UPDATE | Log low stock alerts |
| trg_audit_prescription | prescription | AFTER INSERT/UPDATE/DELETE | Audit trail |
| trg_audit_payment | payment | AFTER INSERT/UPDATE/DELETE | Audit trail |
| trg_audit_medicine | medicine | AFTER INSERT/UPDATE/DELETE | Audit trail |
| trg_weekday_restriction | prescription | BEFORE INSERT/UPDATE/DELETE | Weekend blocks |
| trg_check_expiry | prescription_items | BEFORE INSERT | Block expired meds |

---

## Rollback Scripts

To remove all objects (in reverse order):

```sql
-- Drop triggers
DROP TRIGGER trg_check_expiry;
DROP TRIGGER trg_weekday_restriction;
DROP TRIGGER trg_audit_medicine;
DROP TRIGGER trg_audit_payment;
DROP TRIGGER trg_audit_prescription;
DROP TRIGGER trg_low_stock_alert;
DROP TRIGGER trg_dispense_medicine;

-- Drop procedures and packages
DROP PROCEDURE process_payment;
DROP PACKAGE pharmacy_pkg;

-- Drop tables (in order of dependencies)
DROP TABLE audit_log;
DROP TABLE inventory_log;
DROP TABLE payment;
DROP TABLE dispensed_medicines;
DROP TABLE prescription_items;
DROP TABLE prescription;
DROP TABLE pharmacist;
DROP TABLE medicine;
DROP TABLE patient;
DROP TABLE doctor;

-- Drop sequences
DROP SEQUENCE seq_audit_id;
DROP SEQUENCE seq_log_id;
DROP SEQUENCE seq_payment_id;
DROP SEQUENCE seq_dispensed_id;
DROP SEQUENCE seq_pharmacist_id;
DROP SEQUENCE seq_item_id;
DROP SEQUENCE seq_prescription_id;
DROP SEQUENCE seq_medicine_id;
DROP SEQUENCE seq_patient_id;
DROP SEQUENCE seq_doctor_id;
```

---

## Troubleshooting

### Common Issues

**ORA-00942: table or view does not exist**
- Ensure scripts are run in correct order
- Verify you're connected to the correct PDB

**ORA-04091: table is mutating**
- Review trigger logic for cascading updates
- Use autonomous transactions if needed

**ORA-00001: unique constraint violated**
- Reset sequences if re-running insert scripts
- Truncate tables before re-inserting

### Reset Sequences

```sql
-- Example: Reset doctor sequence
ALTER SEQUENCE seq_doctor_id RESTART START WITH 1001;
```

---

## Maintenance

### Recommended Tasks

| Task | Frequency | Script/Command |
|------|-----------|----------------|
| Analyze tables | Weekly | `EXEC DBMS_STATS.GATHER_SCHEMA_STATS('PHARMACY_USER')` |
| Purge old audit logs | Monthly | `DELETE FROM audit_log WHERE action_date < ADD_MONTHS(SYSDATE, -12)` |
| Rebuild indexes | Quarterly | `ALTER INDEX idx_name REBUILD` |
| Check expired medicines | Daily | See analytics_queries.sql |
