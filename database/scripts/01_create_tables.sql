-- ============================================================================
-- PHARMACY MANAGEMENT SYSTEM - TABLE CREATION SCRIPT
-- Author: Uwitonze Pacific (ID: 26983)
-- Database: mon_26983_pacific_pharmacy_db
-- ============================================================================

-- ============================================================================
-- SEQUENCES
-- ============================================================================

CREATE SEQUENCE seq_doctor_id START WITH 1001 INCREMENT BY 1;
CREATE SEQUENCE seq_patient_id START WITH 10001 INCREMENT BY 1;
CREATE SEQUENCE seq_medicine_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_prescription_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_item_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_pharmacist_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_dispensed_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_payment_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_log_id START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_holiday_id START WITH 1 INCREMENT BY 1;

-- ============================================================================
-- TABLES
-- ============================================================================

-- DOCTOR Table
CREATE TABLE doctor (
    doctor_id       NUMBER PRIMARY KEY,
    name            VARCHAR2(100) NOT NULL,
    specialization  VARCHAR2(50) NOT NULL,
    license_number  VARCHAR2(20) UNIQUE NOT NULL,
    phone           VARCHAR2(15),
    email           VARCHAR2(100),
    created_date    DATE DEFAULT SYSDATE
);

-- PATIENT Table
CREATE TABLE patient (
    patient_id      NUMBER PRIMARY KEY,
    name            VARCHAR2(100) NOT NULL,
    dob             DATE NOT NULL,
    address         VARCHAR2(200),
    phone           VARCHAR2(15),
    email           VARCHAR2(100),
    insurance_info  VARCHAR2(100),
    medical_history CLOB,
    created_date    DATE DEFAULT SYSDATE
);

-- MEDICINE Table
CREATE TABLE medicine (
    medicine_id     NUMBER PRIMARY KEY,
    name            VARCHAR2(100) NOT NULL,
    description     VARCHAR2(500),
    manufacturer    VARCHAR2(100),
    category        VARCHAR2(50) NOT NULL,
    unit_price      NUMBER(10,2) NOT NULL CHECK (unit_price > 0),
    current_stock   NUMBER NOT NULL CHECK (current_stock >= 0),
    reorder_level   NUMBER NOT NULL,
    expiry_date     DATE NOT NULL,
    created_date    DATE DEFAULT SYSDATE
);

-- PHARMACIST Table
CREATE TABLE pharmacist (
    pharmacist_id   NUMBER PRIMARY KEY,
    name            VARCHAR2(100) NOT NULL,
    license_number  VARCHAR2(20) UNIQUE NOT NULL,
    phone           VARCHAR2(15),
    email           VARCHAR2(100),
    shift_hours     VARCHAR2(50),
    created_date    DATE DEFAULT SYSDATE
);

-- PRESCRIPTION Table
CREATE TABLE prescription (
    prescription_id NUMBER PRIMARY KEY,
    doctor_id       NUMBER NOT NULL,
    patient_id      NUMBER NOT NULL,
    issue_date      DATE NOT NULL,
    status          VARCHAR2(20) DEFAULT 'NEW'
                    CHECK (status IN ('NEW', 'VALIDATED', 'DISPENSED', 'COMPLETED')),
    diagnosis       VARCHAR2(500),
    notes           VARCHAR2(500),
    CONSTRAINT fk_prescription_doctor FOREIGN KEY (doctor_id)
        REFERENCES doctor(doctor_id),
    CONSTRAINT fk_prescription_patient FOREIGN KEY (patient_id)
        REFERENCES patient(patient_id)
);

-- PRESCRIPTION_ITEMS Table
CREATE TABLE prescription_items (
    item_id         NUMBER PRIMARY KEY,
    prescription_id NUMBER NOT NULL,
    medicine_id     NUMBER NOT NULL,
    dosage          VARCHAR2(100) NOT NULL,
    quantity        NUMBER NOT NULL CHECK (quantity > 0),
    instructions    VARCHAR2(500),
    CONSTRAINT fk_item_prescription FOREIGN KEY (prescription_id)
        REFERENCES prescription(prescription_id) ON DELETE CASCADE,
    CONSTRAINT fk_item_medicine FOREIGN KEY (medicine_id)
        REFERENCES medicine(medicine_id)
);

-- DISPENSED_MEDICINES Table
CREATE TABLE dispensed_medicines (
    dispensed_id    NUMBER PRIMARY KEY,
    prescription_id NUMBER NOT NULL,
    pharmacist_id   NUMBER NOT NULL,
    dispensing_date DATE DEFAULT SYSDATE,
    CONSTRAINT fk_dispensed_prescription FOREIGN KEY (prescription_id)
        REFERENCES prescription(prescription_id),
    CONSTRAINT fk_dispensed_pharmacist FOREIGN KEY (pharmacist_id)
        REFERENCES pharmacist(pharmacist_id)
);

-- PAYMENT Table
CREATE TABLE payment (
    payment_id      NUMBER PRIMARY KEY,
    prescription_id NUMBER NOT NULL,
    amount          NUMBER(10,2) NOT NULL CHECK (amount > 0),
    payment_date    DATE DEFAULT SYSDATE,
    payment_method  VARCHAR2(20) CHECK (payment_method IN ('CASH', 'CARD', 'INSURANCE')),
    status          VARCHAR2(20) DEFAULT 'PENDING'
                    CHECK (status IN ('PENDING', 'COMPLETED')),
    CONSTRAINT fk_payment_prescription FOREIGN KEY (prescription_id)
        REFERENCES prescription(prescription_id)
);

-- INVENTORY_LOG Table
CREATE TABLE inventory_log (
    log_id           NUMBER PRIMARY KEY,
    medicine_id      NUMBER NOT NULL,
    transaction_type VARCHAR2(20) CHECK (transaction_type IN ('ADD', 'DEDUCT', 'ADJUST')),
    quantity         NUMBER NOT NULL,
    transaction_date DATE DEFAULT SYSDATE,
    notes            VARCHAR2(200),
    CONSTRAINT fk_log_medicine FOREIGN KEY (medicine_id)
        REFERENCES medicine(medicine_id)
);

-- AUDIT_LOG Table (for tracking all changes)
CREATE TABLE audit_log (
    audit_id        NUMBER PRIMARY KEY,
    user_id         VARCHAR2(50),
    action_date     TIMESTAMP DEFAULT SYSTIMESTAMP,
    operation       VARCHAR2(10),
    table_name      VARCHAR2(50),
    record_id       NUMBER,
    old_value       CLOB,
    new_value       CLOB,
    status          VARCHAR2(20)
);

CREATE SEQUENCE seq_audit_id START WITH 1 INCREMENT BY 1;

-- HOLIDAY Table (for weekday/holiday restriction)
CREATE TABLE holiday (
    holiday_id      NUMBER PRIMARY KEY,
    holiday_name    VARCHAR2(100) NOT NULL,
    holiday_date    DATE NOT NULL UNIQUE,
    description     VARCHAR2(200),
    is_recurring    CHAR(1) DEFAULT 'N' CHECK (is_recurring IN ('Y', 'N')),
    created_date    DATE DEFAULT SYSDATE
);

-- ============================================================================
-- INDEXES
-- ============================================================================

CREATE INDEX idx_prescription_status ON prescription(status);
CREATE INDEX idx_prescription_date ON prescription(issue_date);
CREATE INDEX idx_medicine_category ON medicine(category);
CREATE INDEX idx_medicine_stock ON medicine(current_stock);
CREATE INDEX idx_payment_date ON payment(payment_date);
CREATE INDEX idx_payment_status ON payment(status);
CREATE INDEX idx_inventory_log_date ON inventory_log(transaction_date);
CREATE INDEX idx_holiday_date ON holiday(holiday_date);

-- ============================================================================
-- End of Script
-- ============================================================================
