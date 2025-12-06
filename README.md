# Pharmacy Management System

> A comprehensive PL/SQL Oracle Database project for automating pharmacy operations

---

## Student Information

| Field | Details |
|-------|---------|
| **Name** | Uwitonze Pacific |
| **Student ID** | 26983 |
| **Course** | Database Development with PL/SQL (INSY 8311) |
| **Lecturer** | Eric Maniraguha |
| **Academic Year** | 2024-2025 |

---

## Table of Contents

- [Introduction](#introduction)
- [Project Phases](#project-phases)
  - [Phase 1: Problem Statement](#phase-1-problem-statement)
  - [Phase 2: Business Process Modeling](#phase-2-business-process-modeling)
  - [Phase 3: Logical Model Design](#phase-3-logical-model-design)
  - [Phase 4: Physical Database Implementation](#phase-4-physical-database-implementation)
  - [Phase 5: Data Insertion](#phase-5-data-insertion)
  - [Phase 6: Transaction Handling](#phase-6-transaction-handling)
  - [Phase 7: Security Features & Auditing](#phase-7-security-features--auditing)
  - [Phase 8: Reporting and Query Optimization](#phase-8-reporting-and-query-optimization)
- [Tools & Technologies](#tools--technologies)
- [Conclusion](#conclusion)
- [Contact](#contact)

---

## Introduction

Modern pharmacies face increasing challenges due to manual processes that often result in prescription errors, inventory mismatches, delayed patient services, and data inconsistencies.

This project introduces a **Pharmacy Management System** built using Oracle Database and PL/SQL programming. The system provides:

- Automation of prescription workflows
- Real-time inventory tracking
- Secure data management for prescriptions, inventory, and payments
- Enhanced service delivery and operational efficiency

The project was implemented in **eight phases**, covering everything from problem analysis and business modeling to logical design, implementation, testing, and reporting.

---

## Project Phases

| Phase | Title | Description |
|-------|-------|-------------|
| 1 | Problem Statement | Identifying core pharmacy challenges and defining system requirements |
| 2 | Business Process Modeling | Mapping essential workflows using BPMN diagrams |
| 3 | Logical Model Design | Designing normalized database schema with entities and relationships |
| 4 | Physical Database Implementation | Creating Oracle PDB, users, and privileges |
| 5 | Data Insertion | Populating tables with realistic sample data |
| 6 | Transaction Handling | Implementing procedures, functions, cursors, and packages |
| 7 | Security Features | Implementing triggers, audit logging, and access controls |
| 8 | Reporting & Optimization | Creating analytical queries and optimizing performance |

---

## Phase 1: Problem Statement

### Problem Definition

Pharmacies often face operational inefficiencies due to manual handling of prescriptions, outdated inventory tracking methods, and unstructured patient records. These issues contribute to:

- Medication errors and mismatched prescriptions
- Delays in patient service
- Out-of-stock problems
- Lost revenue due to poor billing and payment tracking

### Context

This Pharmacy Management System is designed for community and hospital-based pharmacies where data integrity, automation, and quick access to patient information are critical.

### Target Users

| User | Role |
|------|------|
| **Pharmacists** | Manage inventory, fulfill prescriptions |
| **Doctors** | Issue prescriptions |
| **Patients** | Receive medication, view history |
| **Managers** | View analytics, track performance |

### Project Goals

- Automate prescription workflows
- Track inventory levels and alert on low stock
- Ensure data integrity and security
- Provide actionable insights through reporting

---

## Phase 2: Business Process Modeling

### Scope & Objectives

- **Scope:** Prescription lifecycle, from doctor's order through dispensing and billing
- **Objective:** Create a clear, visual model (using BPMN) that shows every actor, decision point, and system action

### Actors & Their Roles

| Actor | Responsibilities |
|-------|------------------|
| **Doctor** | Issues prescriptions to patients |
| **Patient** | Receives prescription and requests medication |
| **Pharmacist** | Validates prescription, dispenses medicine, initiates billing |
| **System** | Checks stock, updates inventory, processes payment, sends alerts |

### Key Workflows

1. **Prescription Issuance** - Doctor prescribes medicine to patient
2. **Validation & Verification** - Pharmacist retrieves order, checks completeness; system verifies patient eligibility
3. **Stock Check** - System confirms medicine availability; triggers alerts if out of stock
4. **Dispensing & Billing** - Pharmacist dispenses medicine; system calculates cost and issues receipt
5. **Inventory Update & Notification** - System deducts dispensed quantity; alerts sent if stock falls below threshold

### Swimlane Responsibilities

- **Doctor Lane:** Creates and submits electronic prescriptions
- **Patient Lane:** Receives notifications, provides additional info (e.g., insurance details)
- **Pharmacist Lane:** Validates prescriptions, dispenses medicine, confirms payment
- **System Lane:** Checks stock, updates inventory, processes payments, sends alerts

### BPMN Diagram

![BPMN Diagram](https://github.com/user-attachments/assets/369fad35-ecac-46dc-90aa-0fb89659e728)

### Logical Flow

```
Start → Doctor logs in → Enters prescription
      → System checks patient record
          ├─ Invalid → Notify pharmacist → End
          └─ Valid → Pharmacist verifies details
                   → System checks stock
                       ├─ Not available → Send low-stock alert
                       └─ Available → Pharmacist dispenses medicine
                                    → System records transaction
                                    → System updates inventory
                                    → System processes payment
                                    → Patient notified → End
```

---

## Phase 3: Logical Model Design

### Entities and Attributes

#### 1. Doctor
| Attribute | Description |
|-----------|-------------|
| `Doctor_ID` (PK) | Unique identifier |
| `Name` | Full name |
| `Specialization` | Medical specialty |
| `Contact_Info` | Phone/address |
| `License_Number` | Medical license |

#### 2. Patient
| Attribute | Description |
|-----------|-------------|
| `Patient_ID` (PK) | Unique identifier |
| `Name` | Full name |
| `DOB` | Date of birth |
| `Address` | Physical address |
| `Phone`, `Email` | Contact details |
| `Insurance_Info` | Insurance details |
| `Medical_History` | Health records |

#### 3. Medicine
| Attribute | Description |
|-----------|-------------|
| `Medicine_ID` (PK) | Unique identifier |
| `Name` | Medicine name |
| `Description` | Details |
| `Manufacturer` | Producer |
| `Category` | Drug category |
| `Unit_Price` | Price per unit |
| `Current_Stock` | Available quantity |
| `Reorder_Level` | Minimum threshold |
| `Expiry_Date` | Expiration date |

#### 4. Prescription
| Attribute | Description |
|-----------|-------------|
| `Prescription_ID` (PK) | Unique identifier |
| `Doctor_ID` (FK) | Prescribing doctor |
| `Patient_ID` (FK) | Patient receiving prescription |
| `Issue_Date` | Date issued |
| `Status` | NEW/VALIDATED/DISPENSED/COMPLETED |

#### 5. Prescription_Items
| Attribute | Description |
|-----------|-------------|
| `Item_ID` (PK) | Unique identifier |
| `Prescription_ID` (FK) | Parent prescription |
| `Medicine_ID` (FK) | Medicine prescribed |
| `Dosage` | Dosage instructions |
| `Quantity` | Amount prescribed |
| `Instructions` | Special instructions |

#### 6. Pharmacist
| Attribute | Description |
|-----------|-------------|
| `Pharmacist_ID` (PK) | Unique identifier |
| `Name` | Full name |
| `License_Number` | Pharmacy license |
| `Contact_Info` | Contact details |
| `Shift_Hours` | Working hours |

#### 7. Dispensed_Medicines
| Attribute | Description |
|-----------|-------------|
| `Dispensed_ID` (PK) | Unique identifier |
| `Prescription_ID` (FK) | Prescription dispensed |
| `Pharmacist_ID` (FK) | Dispensing pharmacist |
| `Dispensing_Date` | Date dispensed |

#### 8. Payment
| Attribute | Description |
|-----------|-------------|
| `Payment_ID` (PK) | Unique identifier |
| `Prescription_ID` (FK) | Related prescription |
| `Amount` | Payment amount |
| `Payment_Date` | Transaction date |
| `Payment_Method` | Cash/Card/Insurance |
| `Status` | PENDING/COMPLETED |

#### 9. Inventory_Log
| Attribute | Description |
|-----------|-------------|
| `Log_ID` (PK) | Unique identifier |
| `Medicine_ID` (FK) | Medicine involved |
| `Transaction_Type` | ADD/DEDUCT/ADJUST |
| `Quantity` | Amount changed |
| `Transaction_Date` | Date of transaction |

### Entity Relationships

```
Doctor (1) ─────────< (M) Prescription
Patient (1) ────────< (M) Prescription
Prescription (1) ───< (M) Prescription_Items
Medicine (1) ───────< (M) Prescription_Items
Pharmacist (1) ─────< (M) Dispensed_Medicines
Prescription (1) ───○ (1) Dispensed_Medicines
Prescription (1) ───○ (1) Payment
Medicine (1) ───────< (M) Inventory_Log
```

### Normalization

- **1NF:** All tables have primary keys with atomic values
- **2NF:** All non-key attributes are fully dependent on primary key
- **3NF:** No transitive dependencies; junction tables handle M:M relationships
- **Referential Integrity:** Foreign key constraints ensure data consistency

### ERD Diagram

![ERD Diagram](https://github.com/user-attachments/assets/0fcfe21a-797a-47fc-a5f0-0571ef34cc2f)

---

## Phase 4: Physical Database Implementation

### Database Configuration

| Property | Value |
|----------|-------|
| **Database Name** | `mon_26983_pacific_pharmacy_db` |
| **Platform** | Oracle 19c |
| **Tool** | SQL Developer |

### Setup Steps

#### 1. Create Pluggable Database

```sql
CREATE PLUGGABLE DATABASE mon_26983_pacific_pharmacy_db
ADMIN USER pacific IDENTIFIED BY pacific
FILE_NAME_CONVERT=(
    'C:\ORACLE21\ORADATA\ORCL\PDBseed\',
    'C:\ORACLE21\ORADATA\ORCL\mon_26983_pacific_pharmacy_db\'
);
```

#### 2. Open the PDB

```sql
ALTER PLUGGABLE DATABASE mon_26983_pacific_pharmacy_db OPEN;
```

#### 3. Save the PDB State

```sql
ALTER PLUGGABLE DATABASE mon_26983_pacific_pharmacy_db SAVE STATE;
```

#### 4. Set Session Container

```sql
ALTER SESSION SET CONTAINER = mon_26983_pacific_pharmacy_db;
```

#### 5. Create User and Grant Privileges

```sql
CREATE USER pharmacy_user IDENTIFIED BY pharmacy_pass;
GRANT CONNECT, RESOURCE, DBA TO pharmacy_user;
```

### Monitoring

Oracle Enterprise Manager (OEM) was configured for:
- Real-time performance monitoring
- Activity logging
- Resource utilization tracking

### Screenshots

![PDB Creation](https://github.com/user-attachments/assets/cf5590ec-edaf-446c-a501-df076f67469e)

![OEM Dashboard](https://github.com/user-attachments/assets/a7412f94-637f-4942-8ce5-ad4faf993d62)

---

## Phase 5: Data Insertion

### Sample Data Overview

Realistic sample records were inserted into all tables to validate constraints and simulate real-world operations.

### Doctors

```sql
INSERT INTO doctor VALUES (seq_doctor_id.NEXTVAL, 'Dr. Jean Baptiste Uwimana',
    'General Medicine', 'MD-RW-2020-001', '+250788123456', 'jb.uwimana@hospital.rw', SYSDATE);
INSERT INTO doctor VALUES (seq_doctor_id.NEXTVAL, 'Dr. Marie Claire Mukamana',
    'Pediatrics', 'MD-RW-2021-045', '+250788234567', 'mc.mukamana@clinic.rw', SYSDATE);
INSERT INTO doctor VALUES (seq_doctor_id.NEXTVAL, 'Dr. Paul Kagame',
    'Cardiology', 'MD-RW-2019-012', '+250788345678', 'p.kagame@cardio.rw', SYSDATE);
INSERT INTO doctor VALUES (seq_doctor_id.NEXTVAL, 'Dr. Alice Uwase',
    'Dermatology', 'MD-RW-2022-078', '+250788456789', 'a.uwase@skin.rw', SYSDATE);
INSERT INTO doctor VALUES (seq_doctor_id.NEXTVAL, 'Dr. Eric Nshimyumuremyi',
    'Neurology', 'MD-RW-2018-033', '+250788567890', 'e.nshimyumuremyi@neuro.rw', SYSDATE);
```

### Medicines

```sql
INSERT INTO medicine VALUES (seq_medicine_id.NEXTVAL, 'Paracetamol 500mg',
    'Pain and fever relief', 'Rwanda Pharma', 'Analgesic', 500, 1000, 100,
    TO_DATE('2025-12-31', 'YYYY-MM-DD'), SYSDATE);
INSERT INTO medicine VALUES (seq_medicine_id.NEXTVAL, 'Amoxicillin 250mg',
    'Antibiotic capsule', 'Kigali Pharmaceuticals', 'Antibiotic', 1200, 500, 50,
    TO_DATE('2025-06-30', 'YYYY-MM-DD'), SYSDATE);
INSERT INTO medicine VALUES (seq_medicine_id.NEXTVAL, 'Ibuprofen 400mg',
    'Anti-inflammatory pain relief', 'East Africa Pharma', 'NSAID', 800, 750, 75,
    TO_DATE('2026-03-15', 'YYYY-MM-DD'), SYSDATE);
-- Additional medicines...
```

### Prescriptions

```sql
INSERT INTO prescription VALUES (seq_prescription_id.NEXTVAL, 1001, 10001,
    TO_DATE('2023-01-05', 'YYYY-MM-DD'), 'COMPLETED', 'Fever and headache', NULL);
INSERT INTO prescription VALUES (seq_prescription_id.NEXTVAL, 1002, 10002,
    TO_DATE('2023-01-10', 'YYYY-MM-DD'), 'DISPENSED', 'Childhood vaccination follow-up', NULL);
INSERT INTO prescription VALUES (seq_prescription_id.NEXTVAL, 1003, 10003,
    TO_DATE('2023-01-15', 'YYYY-MM-DD'), 'VALIDATED', 'Diabetes management',
    'Monitor blood sugar levels');
-- Additional prescriptions...
```

### Data Integrity Measures

- **Validation Constraints:** CHECK, NOT NULL, UNIQUE applied
- **Referential Integrity:** Foreign keys enforced
- **Sequences:** Used for auto-generating primary keys

---

## Phase 6: Transaction Handling

### Package Specification

```sql
CREATE OR REPLACE PACKAGE pharmacy_pkg AS
    -- Cursor: Active prescriptions
    CURSOR c_active_prescriptions IS
        SELECT p.prescription_id, p.issue_date, p.status,
               d.name AS doctor_name, pt.name AS patient_name
        FROM prescription p
        JOIN doctor d ON p.doctor_id = d.doctor_id
        JOIN patient pt ON p.patient_id = pt.patient_id
        WHERE p.status IN ('NEW', 'VALIDATED', 'DISPENSED');

    -- Cursor: Low stock medicines
    CURSOR c_low_stock_medicines IS
        SELECT medicine_id, name, current_stock, reorder_level
        FROM medicine
        WHERE current_stock <= reorder_level;

    -- Procedure: Process prescription
    PROCEDURE process_prescription(
        p_prescription_id IN NUMBER,
        p_action IN VARCHAR2,
        p_result OUT VARCHAR2
    );

    -- Function: Calculate prescription total
    FUNCTION calculate_prescription_total(
        p_prescription_id IN NUMBER
    ) RETURN NUMBER;

    -- Procedure: Generate inventory report
    PROCEDURE generate_inventory_report(
        p_start_date IN DATE DEFAULT NULL,
        p_end_date IN DATE DEFAULT NULL,
        p_report OUT SYS_REFCURSOR
    );

    -- Procedure: Get patient prescription history
    PROCEDURE get_patient_history(
        p_patient_id IN NUMBER,
        p_history OUT SYS_REFCURSOR
    );
END pharmacy_pkg;
/
```

### Key Features

| Feature | Description |
|---------|-------------|
| **Stored Procedures** | Issue prescriptions, process payments |
| **Functions** | Calculate totals, fetch prescription details |
| **Cursors** | Iterate through prescriptions and inventory |
| **Exception Handling** | Handle duplicates, invalid inputs, stock issues |
| **Packages** | Group related business logic (billing, inventory) |

---

## Phase 7: Security Features & Auditing

### Triggers

#### Dispensing Trigger

```sql
CREATE OR REPLACE TRIGGER trg_dispense_medicine
AFTER INSERT ON dispensed_medicines
FOR EACH ROW
DECLARE
    v_prescription_status VARCHAR2(20);
    v_items NUMBER;
    v_current_stock NUMBER;
BEGIN
    -- Check prescription status
    SELECT status INTO v_prescription_status FROM prescription
    WHERE prescription_id = :NEW.prescription_id;

    -- Check if prescription has items
    SELECT COUNT(*) INTO v_items FROM prescription_items
    WHERE prescription_id = :NEW.prescription_id;

    -- Validation checks
    IF v_prescription_status != 'VALIDATED' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Cannot dispense - prescription not validated');
    ELSIF v_items = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Cannot dispense - no items in prescription');
    END IF;

    -- Update prescription status
    UPDATE prescription SET status = 'DISPENSED'
    WHERE prescription_id = :NEW.prescription_id;

    -- Process each medicine item and update stock
    FOR item IN (SELECT medicine_id, quantity FROM prescription_items
                WHERE prescription_id = :NEW.prescription_id)
    LOOP
        SELECT current_stock INTO v_current_stock FROM medicine
        WHERE medicine_id = item.medicine_id;

        IF v_current_stock < item.quantity THEN
            RAISE_APPLICATION_ERROR(-20003,
                'Insufficient stock for medicine ID ' || item.medicine_id);
        END IF;

        UPDATE medicine
        SET current_stock = current_stock - item.quantity
        WHERE medicine_id = item.medicine_id;
    END LOOP;
END;
/
```

### Security Features

| Feature | Purpose |
|---------|---------|
| **Auto Stock Update** | Trigger deducts inventory on dispensing |
| **Weekday/Holiday Restriction** | Blocks certain operations during restricted times |
| **Audit Logging** | Tracks all data modifications |

### Audit Table Structure

| Column | Description |
|--------|-------------|
| `User_ID` | User performing action |
| `Action_Date` | Timestamp of action |
| `Operation` | INSERT/UPDATE/DELETE |
| `Table_Name` | Affected table |
| `Status` | ALLOWED/DENIED |
| `Old_Value` | Previous data |
| `New_Value` | Updated data |

### Audit Screenshot

![Audit Log](https://github.com/user-attachments/assets/4e8d0e5a-be14-4ce1-9bcc-713271accc28)

---

## Phase 8: Reporting and Query Optimization

### Analytical Queries

#### Low Stock Alert

```sql
SELECT medicine_id, name, current_stock, reorder_level,
       (reorder_level - current_stock) AS shortage
FROM medicine
WHERE current_stock <= reorder_level
ORDER BY shortage DESC;
```

#### Daily Revenue Summary

```sql
SELECT TRUNC(payment_date) AS date,
       COUNT(*) AS transactions,
       SUM(amount) AS total_revenue
FROM payment
WHERE status = 'COMPLETED'
GROUP BY TRUNC(payment_date)
ORDER BY date DESC;
```

#### Sales by Doctor

```sql
SELECT d.name AS doctor_name,
       COUNT(p.prescription_id) AS prescriptions,
       SUM(pay.amount) AS total_revenue
FROM doctor d
JOIN prescription p ON d.doctor_id = p.doctor_id
JOIN payment pay ON p.prescription_id = pay.prescription_id
GROUP BY d.name
ORDER BY total_revenue DESC;
```

### Performance Optimization

- Indexed commonly queried columns (IDs, dates, status fields)
- Created composite indexes for JOIN operations
- Analyzed execution plans for query tuning

### Repository Contents

```
pharmacy-management-system/
├── sql/
│   ├── ddl/          # Table creation scripts
│   ├── dml/          # Data insertion scripts
│   ├── triggers/     # Trigger definitions
│   ├── procedures/   # Stored procedures
│   └── packages/     # PL/SQL packages
├── screenshots/      # OEM and query screenshots
├── docs/            # Additional documentation
└── README.md        # This file
```

---

## Tools & Technologies

| Category | Tools |
|----------|-------|
| **Database** | Oracle 19c |
| **Language** | PL/SQL |
| **IDE** | SQL Developer |
| **Modeling** | Draw.io, Lucidchart |
| **Monitoring** | Oracle Enterprise Manager |
| **Documentation** | GitHub, PowerPoint |
| **Version Control** | Git |

---

## Conclusion

The Pharmacy Management System demonstrates how database-driven automation can resolve real-world inefficiencies in pharmaceutical services. Key achievements include:

- **Automated Workflows:** Streamlined prescription processing from issuance to dispensing
- **Inventory Control:** Real-time stock tracking with low-stock alerts
- **Data Security:** Comprehensive audit logging and access controls
- **Operational Efficiency:** Reduced errors and improved service delivery

This project showcases the power of **PL/SQL programming** combined with thoughtful database design, providing a practical solution for pharmacy digital transformation.

---

## Contact

**Uwitonze Pacific**

| Platform | Contact |
|----------|---------|
| Email | pacific.uwitonze112@gmail.com |


---

> *"Whatever you do, work at it with all your heart, as working for the Lord, not for human masters."* — **Colossians 3:23**
