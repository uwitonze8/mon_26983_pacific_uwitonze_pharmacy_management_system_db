# Data Dictionary

> Comprehensive reference for all database objects in the Pharmacy Management System

---

## Tables Overview

| Table Name | Description | Primary Key |
|------------|-------------|-------------|
| DOCTOR | Stores doctor information | Doctor_ID |
| PATIENT | Stores patient records | Patient_ID |
| MEDICINE | Medicine inventory catalog | Medicine_ID |
| PRESCRIPTION | Prescription records | Prescription_ID |
| PRESCRIPTION_ITEMS | Individual items in prescriptions | Item_ID |
| PHARMACIST | Pharmacist staff records | Pharmacist_ID |
| DISPENSED_MEDICINES | Dispensing transaction records | Dispensed_ID |
| PAYMENT | Payment transaction records | Payment_ID |
| INVENTORY_LOG | Inventory change history | Log_ID |

---

## Table Definitions

### DOCTOR

| Column | Data Type | Constraints | Description |
|--------|-----------|-------------|-------------|
| Doctor_ID | NUMBER | PRIMARY KEY | Unique identifier for doctors |
| Name | VARCHAR2(100) | NOT NULL | Full name of the doctor |
| Specialization | VARCHAR2(50) | NOT NULL | Medical specialty area |
| License_Number | VARCHAR2(20) | UNIQUE, NOT NULL | Medical license number |
| Phone | VARCHAR2(15) | | Contact phone number |
| Email | VARCHAR2(100) | | Email address |
| Created_Date | DATE | DEFAULT SYSDATE | Record creation timestamp |

### PATIENT

| Column | Data Type | Constraints | Description |
|--------|-----------|-------------|-------------|
| Patient_ID | NUMBER | PRIMARY KEY | Unique identifier for patients |
| Name | VARCHAR2(100) | NOT NULL | Full name of the patient |
| DOB | DATE | NOT NULL | Date of birth |
| Address | VARCHAR2(200) | | Physical address |
| Phone | VARCHAR2(15) | | Contact phone number |
| Email | VARCHAR2(100) | | Email address |
| Insurance_Info | VARCHAR2(100) | | Insurance provider details |
| Medical_History | CLOB | | Medical history notes |
| Created_Date | DATE | DEFAULT SYSDATE | Record creation timestamp |

### MEDICINE

| Column | Data Type | Constraints | Description |
|--------|-----------|-------------|-------------|
| Medicine_ID | NUMBER | PRIMARY KEY | Unique identifier for medicines |
| Name | VARCHAR2(100) | NOT NULL | Medicine name |
| Description | VARCHAR2(500) | | Detailed description |
| Manufacturer | VARCHAR2(100) | | Manufacturing company |
| Category | VARCHAR2(50) | NOT NULL | Drug category (Analgesic, Antibiotic, etc.) |
| Unit_Price | NUMBER(10,2) | NOT NULL, CHECK > 0 | Price per unit in RWF |
| Current_Stock | NUMBER | NOT NULL, CHECK >= 0 | Available quantity |
| Reorder_Level | NUMBER | NOT NULL | Minimum stock threshold |
| Expiry_Date | DATE | NOT NULL | Expiration date |
| Created_Date | DATE | DEFAULT SYSDATE | Record creation timestamp |

### PRESCRIPTION

| Column | Data Type | Constraints | Description |
|--------|-----------|-------------|-------------|
| Prescription_ID | NUMBER | PRIMARY KEY | Unique identifier for prescriptions |
| Doctor_ID | NUMBER | FOREIGN KEY | Reference to prescribing doctor |
| Patient_ID | NUMBER | FOREIGN KEY | Reference to patient |
| Issue_Date | DATE | NOT NULL | Date prescription was issued |
| Status | VARCHAR2(20) | CHECK IN ('NEW','VALIDATED','DISPENSED','COMPLETED') | Current status |
| Diagnosis | VARCHAR2(500) | | Diagnosis notes |
| Notes | VARCHAR2(500) | | Additional notes |

### PRESCRIPTION_ITEMS

| Column | Data Type | Constraints | Description |
|--------|-----------|-------------|-------------|
| Item_ID | NUMBER | PRIMARY KEY | Unique identifier for prescription items |
| Prescription_ID | NUMBER | FOREIGN KEY | Reference to parent prescription |
| Medicine_ID | NUMBER | FOREIGN KEY | Reference to medicine |
| Dosage | VARCHAR2(100) | NOT NULL | Dosage instructions |
| Quantity | NUMBER | NOT NULL, CHECK > 0 | Quantity prescribed |
| Instructions | VARCHAR2(500) | | Special instructions |

### PHARMACIST

| Column | Data Type | Constraints | Description |
|--------|-----------|-------------|-------------|
| Pharmacist_ID | NUMBER | PRIMARY KEY | Unique identifier for pharmacists |
| Name | VARCHAR2(100) | NOT NULL | Full name |
| License_Number | VARCHAR2(20) | UNIQUE, NOT NULL | Pharmacy license number |
| Phone | VARCHAR2(15) | | Contact phone number |
| Email | VARCHAR2(100) | | Email address |
| Shift_Hours | VARCHAR2(50) | | Working shift hours |
| Created_Date | DATE | DEFAULT SYSDATE | Record creation timestamp |

### DISPENSED_MEDICINES

| Column | Data Type | Constraints | Description |
|--------|-----------|-------------|-------------|
| Dispensed_ID | NUMBER | PRIMARY KEY | Unique identifier for dispensing records |
| Prescription_ID | NUMBER | FOREIGN KEY | Reference to prescription |
| Pharmacist_ID | NUMBER | FOREIGN KEY | Reference to dispensing pharmacist |
| Dispensing_Date | DATE | DEFAULT SYSDATE | Date of dispensing |

### PAYMENT

| Column | Data Type | Constraints | Description |
|--------|-----------|-------------|-------------|
| Payment_ID | NUMBER | PRIMARY KEY | Unique identifier for payments |
| Prescription_ID | NUMBER | FOREIGN KEY | Reference to prescription |
| Amount | NUMBER(10,2) | NOT NULL, CHECK > 0 | Payment amount in RWF |
| Payment_Date | DATE | DEFAULT SYSDATE | Date of payment |
| Payment_Method | VARCHAR2(20) | CHECK IN ('CASH','CARD','INSURANCE') | Payment method used |
| Status | VARCHAR2(20) | CHECK IN ('PENDING','COMPLETED') | Payment status |

### INVENTORY_LOG

| Column | Data Type | Constraints | Description |
|--------|-----------|-------------|-------------|
| Log_ID | NUMBER | PRIMARY KEY | Unique identifier for log entries |
| Medicine_ID | NUMBER | FOREIGN KEY | Reference to medicine |
| Transaction_Type | VARCHAR2(20) | CHECK IN ('ADD','DEDUCT','ADJUST') | Type of inventory change |
| Quantity | NUMBER | NOT NULL | Quantity changed |
| Transaction_Date | DATE | DEFAULT SYSDATE | Date of transaction |
| Notes | VARCHAR2(200) | | Transaction notes |

---

## Sequences

| Sequence Name | Start Value | Increment | Description |
|---------------|-------------|-----------|-------------|
| seq_doctor_id | 1001 | 1 | Auto-generates Doctor IDs |
| seq_patient_id | 10001 | 1 | Auto-generates Patient IDs |
| seq_medicine_id | 1 | 1 | Auto-generates Medicine IDs |
| seq_prescription_id | 1 | 1 | Auto-generates Prescription IDs |
| seq_item_id | 1 | 1 | Auto-generates Prescription Item IDs |
| seq_pharmacist_id | 1 | 1 | Auto-generates Pharmacist IDs |
| seq_dispensed_id | 1 | 1 | Auto-generates Dispensed Medicine IDs |
| seq_payment_id | 1 | 1 | Auto-generates Payment IDs |
| seq_log_id | 1 | 1 | Auto-generates Inventory Log IDs |

---

## Indexes

| Index Name | Table | Columns | Type | Purpose |
|------------|-------|---------|------|---------|
| idx_prescription_status | PRESCRIPTION | status | B-Tree | Speed up status-based queries |
| idx_prescription_date | PRESCRIPTION | issue_date | B-Tree | Speed up date-range queries |
| idx_medicine_category | MEDICINE | category | B-Tree | Speed up category filtering |
| idx_medicine_stock | MEDICINE | current_stock | B-Tree | Speed up low-stock queries |
| idx_payment_date | PAYMENT | payment_date | B-Tree | Speed up payment reporting |

---

## Foreign Key Relationships

| Child Table | Child Column | Parent Table | Parent Column | On Delete |
|-------------|--------------|--------------|---------------|-----------|
| PRESCRIPTION | Doctor_ID | DOCTOR | Doctor_ID | RESTRICT |
| PRESCRIPTION | Patient_ID | PATIENT | Patient_ID | RESTRICT |
| PRESCRIPTION_ITEMS | Prescription_ID | PRESCRIPTION | Prescription_ID | CASCADE |
| PRESCRIPTION_ITEMS | Medicine_ID | MEDICINE | Medicine_ID | RESTRICT |
| DISPENSED_MEDICINES | Prescription_ID | PRESCRIPTION | Prescription_ID | RESTRICT |
| DISPENSED_MEDICINES | Pharmacist_ID | PHARMACIST | Pharmacist_ID | RESTRICT |
| PAYMENT | Prescription_ID | PRESCRIPTION | Prescription_ID | RESTRICT |
| INVENTORY_LOG | Medicine_ID | MEDICINE | Medicine_ID | RESTRICT |
