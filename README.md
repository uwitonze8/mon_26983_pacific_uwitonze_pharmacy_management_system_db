 Pharmacy Management System – PL/SQL Oracle Database Project

###  Student Info 
- **Name:** uwitonze pacific
   
- **Student ID:** 26983
  
- **Course:** Database Development with PL/SQL (INSY 8311)
  
- **Lecturer:** Eric Maniraguha
  
- **Academic Year:** 2024–2025  
  
Introduction:

   
Modern pharmacies face increasing challenges due to manual processes that often result in prescription errors, inventory mismatches, delayed patient services, and data inconsistencies. 

To address these pain points, this project introduces a Pharmacy Management System built using Oracle Database and PL/SQL programming. The system provides automation, real-time tracking, and secure data management for prescriptions, inventory, and payments—enhancing service delivery and operational efficiency.

The project was implemented in eight phases, covering everything from problem analysis and business modeling to logical design, implementation, testing, and reporting.

Project Timeline and Structure
   
Phase | Title  
 
- **(Phase 1:  Problem Statement).** **Identifying Core Challenges** – Pinpointing the key pharmacy pain points (prescription errors, stock mismatches, billing delays) and defining exactly what our system must solve.
  
- **(Phase 2:  Business Process Modeling).** **Mapping Essential Workflows** – Drawing a clear flowchart of prescription issuance → validation → dispensing → billing → stock update, and assigning who does each step.
  
- **(Phase 3:  Logical Model Design).** **Designing Strong Foundations** – Translating workflow into tables (Patients, Doctors, Medicines, Prescriptions, Payments), defining fields and relationships to ensure clean, normalized data.
  
- **(Phase 4:  Physical Database Implementation).**  **Building the Database** – Creating the Oracle pluggable database (mon_26630_pascal_pharmacy_db), setting up user privileges, and connecting Oracle Enterprise Manager for real-time monitoring.
  
- **(Phase 5:  Data Insertion).**  **Populating with Meaningful Data** – Loading realistic sample records (patients, doctors, medicines, prescriptions, payments) to validate constraints and simulate real-world operations.
  
- **(Phase 6:  Transaction Handling).**  **Ensuring Data Integrity** – Writing PL/SQL procedures, functions, and packages for core actions (issue prescription, process payment), using cursors and exception blocks to keep data accurate.
  
- **(Phase 7:  Security Features).** **Securing Sensitive Information** – Implementing triggers to auto-update stock and block changes on weekdays/holidays, plus audit tables and triggers to log every data-change attempt.
  
- **(Phase 8:  Reporting and Query Optimization).**  **Delivering Actionable Insights** – Crafting analytical queries (low-stock alerts, sales summaries), tuning indexes for speed, and preparing final reports and a 10-slide presentation for stakeholders.

** Phase 1: Problem Statement.**

** Problem Definition**

Pharmacies often face operational inefficiencies due to manual handling of prescriptions, outdated inventory tracking methods, and unstructured patient records. These issues contribute to:

--Medication errors and mismatched prescriptions

- Delays in service

- Out-of-stock problems

- Lost revenue due to poor billing and payment tracking

###  Context

This Pharmacy Management System is designed for community and hospital-based pharmacies where data integrity, automation, and quick access to patient information are critical.

 Target Users

Pharmacists – Manage inventory, fulfill prescriptions

Doctors – Issue prescriptions

Patients – Get medication, view history

Managers – View analytics, track performance


###  Project Goals

- Automate prescription workflows

- Track inventory levels and alert on low stock
  
 ---

#  Phase 2: Business Process Modeling (BPM)

###  What This Phase Covers
You’ll map out how your pharmacy operations should work—step by step—so you can spot exactly where to automate and optimize.

###  Scope & Objectives
Scope: Prescription lifecycle, from doctor’s order through dispensing and billing.

Objective: Create a clear, visual model (using BPMN or UML) that shows every actor, decision point, and system action. 

###  Actors & Their Roles

- **Doctor:** Issues a prescription

- **Patient:** Receives prescription and requests medication

- **Pharmacist:** Validates prescription, dispenses medicine, initiates billing.

- **System:**Checks stock, updates inventory, processes payment, sends alerts.

###  Key Workflows

1. **Prescription Issuance:** Doctor prescribes medicine to patient.

2. **Validation & Veryfiation:** 
    . Pharmacist retrieves the order, checks for completeness/legibility.

  .  System verifies patient eligibility and payment status.
  
4. **Stock Check:**
    . System automatically confirms medicine availability.

   . If out of stock → trigger back-order or low-stock alert.
   
5. **Dispensing & Billing:**
  . Pharmacist dispenses the medicine.

 . System calculates cost, records payment method, and issues receipt.
 
7. **Inventory Update & Notification:**

  . System deducts dispensed quantity from stock.

  . Alerts sent if stock falls below reorder threshold.

  ###  Use of Swimlanes

*  **Doctor Lane:**  
  - Creates and submits the electronic prescription.  

*  **Patient Lane:**  
  - Receives notifications (e.g., “Prescription ready for pickup”).  
  - Provides any additional info if needed (e.g., insurance details).  

*  **Pharmacist Lane:**  
  - Retrieves and validates the prescription.  
  - Dispenses medicine and hands it over to the patient.  
  - Initiates billing and confirms payment.  

*  **System Lane:**  
  - Checks medicine stock and availability.  
  - Updates inventory quantities automatically.  
  - Processes payment and issues receipts.  
  - Sends low-stock alerts or back-order notifications.  

![Image of BPMN](https://github.com/user-attachments/assets/369fad35-ecac-46dc-90aa-0fb89659e728)


###  Logical Flow Description

Start: Doctor logs into system → enters prescription.

Decision: System checks patient record → if invalid, notify pharmacist → end.

Action: Pharmacist verifies prescription details.

Decision: System checks stock → if available, proceed; if not, send low-stock alert.

Action: Pharmacist dispenses medicine → system records transaction.

Action: System updates inventory and processes payment.

End: Patient is notified that prescription is fulfilled.



# 🗂 Phase 3: Logical Model Design for Pharmacy Management System

##  What This Phase Covers
This phase focuses on designing a detailed and robust logical data model for the pharmacy management system. The goal is to create a structure that accurately represents entities, their attributes, and relationships while ensuring the design can handle real-world pharmacy data scenarios.

##  Entities and Attributes

### 1.  **Doctor**:
* **Attributes:** `Doctor_ID (PK)`, Name, Specialization, Contact_Info, License_Number
* Linked to Prescriptions via `Doctor_ID (FK)`

### 2.  **Patient**:
* **Attributes:** `Patient_ID (PK)`, Name, DOB, Address, Phone, Email, Insurance_Info, Medical_History
* Linked to Prescriptions and Payments

### 3.  **Medicine**:
* **Attributes:** `Medicine_ID (PK)`, Name, Description, Manufacturer, Category, Unit_Price, Current_Stock, Reorder_Level, Expiry_Date
* Linked to Prescription_Items via `Medicine_ID (FK)`

### 4.  **Prescription**:
* **Attributes:** `Prescription_ID (PK)`, `Doctor_ID (FK)`, `Patient_ID (FK)`, Issue_Date, Status
* Links Doctors to Patients and connects to Prescription_Items

### 5.  **Prescription_Items**:
* **Attributes:** `Item_ID (PK)`, `Prescription_ID (FK)`, `Medicine_ID (FK)`, Dosage, Quantity, Instructions
* Junction table connecting Prescriptions to Medicines
 
### 6.  **Pharmacist**:
* **Attributes:** `Pharmacist_ID (PK)`, Name, License_Number, Contact_Info, Shift_Hours
* Linked to Dispensed_Medicines via `Pharmacist_ID (FK)`

### 7.  **Dispensed_Medicines**:
* **Attributes:** `Dispensed_ID (PK)`, `Prescription_ID (FK)`, `Pharmacist_ID (FK)`, Dispensing_Date
* Tracks which pharmacist dispensed which prescription

### 8.  **Payment**:
* **Attributes:** `Payment_ID (PK)`, `Prescription_ID (FK)`, Amount, Payment_Date, Payment_Method, Status
* Linked to Prescription via `Prescription_ID (FK)`

### 9.  **Inventory_Log**:
* **Attributes:** `Log_ID (PK)`, `Medicine_ID (FK)`, Transaction_Type, Quantity, Transaction_Date
* Tracks all inventory changes (additions, deductions, adjustments)

##  Relationships and Cardinalities

###  Doctor (1) — (M) Prescription
* Each doctor can write multiple prescriptions, but each prescription is written by exactly one doctor.

###  Patient (1) — (M) Prescription
* Each patient can have multiple prescriptions over time, but each prescription belongs to exactly one patient.

###  Prescription (1) — (M) Prescription_Items 
* Each prescription can include multiple medicines, and each prescription item belongs to exactly one prescription.

###  Medicine (1) — (M) Prescription_Items
* Each medicine can appear in multiple prescriptions, and each prescription item refers to exactly one medicine.

###  Pharmacist (1) — (M) Dispensed_Medicines
* Each pharmacist can dispense multiple prescriptions, but each dispensed prescription is handled by exactly one pharmacist.

###  Prescription (1) — (1) Dispensed_Medicines
* Each prescription is dispensed exactly once, and each dispensing record refers to exactly one prescription.

###  Prescription (1) — (1) Payment
* Each prescription has exactly one payment record, and each payment is for exactly one prescription.

###  Medicine (1) — (M) Inventory_Log
* Each medicine can have multiple inventory transactions, but each inventory transaction involves exactly one medicine.

## ⚙️ Handling Data Scenarios

**The model is designed to handle:**

* **Multiple Medications Per Prescription**: The Prescription_Items table allows a single prescription to include multiple medicines with different dosages and instructions.

* **Prescription Status Tracking**: The Status attribute in Prescription table tracks whether it's new, validated, dispensed, or completed.

* **Inventory Management**: The Inventory_Log tracks all changes to medicine stock, enabling accurate stock levels and reorder alerts.

* **Payment Verification**: The Payment table with status field allows tracking whether payment has been completed before medicine dispensing.

* **Prescription Validation**: The relationship between Prescription and Dispensed_Medicines ensures prescriptions are properly validated and dispensed by qualified pharmacists.

* **Stock Thresholds**: Reorder_Level in the Medicine table triggers alerts when inventory falls below critical levels.

##  Normalization and Constraints

* **First Normal Form (1NF)**: All tables have a primary key, and all attributes contain atomic values.

* **Second Normal Form (2NF)**: All non-key attributes are fully functionally dependent on the primary key.

* **Third Normal Form (3NF)**: No transitive dependencies exist, with junction tables (Prescription_Items) properly handling many-to-many relationships.

* **Referential Integrity**: Foreign key constraints ensure data consistency across related tables.

* **Data Validation**: Check constraints on critical fields like Medicine.Current_Stock (≥ 0) and Payment.Status.

##  Benefits of This Logical Model

1. **Comprehensive Prescription Tracking**: Full lifecycle from creation to dispensing and payment
2. **Accurate Inventory Management**: Real-time stock tracking with detailed transaction history
3. **Clear Accountability**: Records which pharmacist handled each prescription
4. **Flexible Payment Handling**: Supports multiple payment methods and status tracking
5. **Regulatory Compliance**: Maintains complete records of prescriptions, practitioners, and dispensing details
6. **Scalability**: Design accommodates growth in prescription volume and medication inventory

This logical model provides a solid foundation for developing a reliable and efficient pharmacy management system that accurately represents the real-world processes captured in our business process model.


![WhatsApp Image 2025-05-25 at 09 22 06_dfe530ac](https://github.com/user-attachments/assets/0fcfe21a-797a-47fc-a5f0-0571ef34cc2f)

##  Phase 4: Physical Database Implementation

### Database Setup

- **Database Name:** `mon_26630_pascal_pharmacy_db`  
- **Password:** pascal  
- Created in **Oracle 19c** using **SQL Developer**  

### 📈 Monitoring

- **Oracle Enterprise Manager (OEM)** was used to monitor performance and activity.  
- Snapshots and performance dashboards help track real-time resource use and activity logs.
  1. Create a pluggable Database
   ```sql
CREATE PLUGGABLE DATABASEtues_26630_Pascal_Pharmacy-Management-SystemS_db
   2 ADMIN USER muneza IDENTIFIED BY muneza
   3 FILE_NAME_CONVERT=('C:\ORACLE21\ORADATA\ORCL\PDBseed\','C:\ORACLE21\ORADATA\ORC\tues_26630_muneza_PharmAacy_management_db');
   
   Pluggable database created.
```
  ### **3. Open Newly PDB Created:**
```sql
alter pluggable database tues_26630_Pascal_Pharmacy-Management-SystemS OPEN;
pluggable database altered.
```
  4. save the newly created PDB.
     
  6. Set the Session Container
  7. User Creation and Privilege Assignment
 
     ##SCREENSHOT OF CREATED PDB
- ![PDB creation](https://github.com/user-attachments/assets/cf5590ec-edaf-446c-a501-df076f67469e)

![OEM CREATION](https://github.com/user-attachments/assets/a7412f94-637f-4942-8ce5-ad4faf993d62)

  
## Phase 5: Data Insertion

###  Sample Data

Realistic sample records were inserted into all tables:
- 10+ patients with medical histories
```sql

   
 doctors with specialties
  ```sql
   -- Inserting doctors with proper specialties and license numbers
INSERT INTO doctor VALUES (seq_doctor_id.NEXTVAL, 'Dr. Jean Baptiste Uwimana', 'General Medicine', 'MD-RW-2020-001', '+250788123456', 'jb.uwimana@hospital.rw', SYSDATE);
INSERT INTO doctor VALUES (seq_doctor_id.NEXTVAL, 'Dr. Marie Claire Mukamana', 'Pediatrics', 'MD-RW-2021-045', '+250788234567', 'mc.mukamana@clinic.rw', SYSDATE);
INSERT INTO doctor VALUES (seq_doctor_id.NEXTVAL, 'Dr. Paul Kagame', 'Cardiology', 'MD-RW-2019-012', '+250788345678', 'p.kagame@cardio.rw', SYSDATE);
INSERT INTO doctor VALUES (seq_doctor_id.NEXTVAL, 'Dr. Alice Uwase', 'Dermatology', 'MD-RW-2022-078', '+250788456789', 'a.uwase@skin.rw', SYSDATE);
INSERT INTO doctor VALUES (seq_doctor_id.NEXTVAL, 'Dr. Eric Nshimyumuremyi', 'Neurology', 'MD-RW-2018-033', '+250788567890', 'e.nshimyumuremyi@neuro.rw', SYSDATE);
```
- 15+ medicines with stock levels and pricing
```sql
-- Inserting medicines with proper categories and pricing
INSERT INTO medicine VALUES (seq_medicine_id.NEXTVAL, 'Paracetamol 500mg', 'Pain and fever relief', 'Rwanda Pharma', 'Analgesic', 500, 1000, 100, TO_DATE('2025-12-31', 'YYYY-MM-DD'), SYSDATE);
INSERT INTO medicine VALUES (seq_medicine_id.NEXTVAL, 'Amoxicillin 250mg', 'Antibiotic capsule', 'Kigali Pharmaceuticals', 'Antibiotic', 1200, 500, 50, TO_DATE('2025-06-30', 'YYYY-MM-DD'), SYSDATE);
INSERT INTO medicine VALUES (seq_medicine_id.NEXTVAL, 'Ibuprofen 400mg', 'Anti-inflammatory pain relief', 'East Africa Pharma', 'NSAID', 800, 750, 75, TO_DATE('2026-03-15', 'YYYY-MM-DD'), SYSDATE);
INSERT INTO medicine VALUES (seq_medicine_id.NEXTVAL, 'Cetirizine 10mg', 'Antihistamine for allergies', 'Rwanda Pharma', 'Antihistamine', 600, 300, 30, TO_DATE('2025-09-30', 'YYYY-MM-DD'), SYSDATE);
INSERT INTO medicine VALUES (seq_medicine_id.NEXTVAL, 'Metformin 500mg', 'Diabetes medication', 'Kigali Pharmaceuticals', 'Antidiabetic', 900, 400, 40, TO_DATE('2025-11-30', 'YYYY-MM-DD'), SYSDATE);
INSERT INTO medicine VALUES (seq_medicine_id.NEXTVAL, 'Atorvastatin 20mg', 'Cholesterol medication', 'East Africa Pharma', 'Statin', 1500, 250, 25, TO_DATE('2026-01-31', 'YYYY-MM-DD'), SYSDATE);
INSERT INTO medicine VALUES (seq_medicine_id.NEXTVAL, 'Omeprazole 20mg', 'Acid reflux medication', 'Rwanda Pharma', 'PPI', 1000, 350, 35, TO_DATE('2025-08-31', 'YYYY-MM-DD'), SYSDATE);
INSERT INTO medicine VALUES (seq_medicine_id.NEXTVAL, 'Salbutamol Inhaler', 'Asthma relief', 'Kigali Pharmaceuticals', 'Bronchodilator', 3500, 150, 15, TO_DATE('2025-10-31', 'YYYY-MM-DD'), SYSDATE);
INSERT INTO medicine VALUES (seq_medicine_id.NEXTVAL, 'Diazepam 5mg', 'Anxiety medication', 'East Africa Pharma', 'Benzodiazepine', 2000, 100, 10, TO_DATE('2025-07-31', 'YYYY-MM-DD'), SYSDATE);
INSERT INTO medicine VALUES (seq_medicine_id.NEXTVAL, 'Hydrochlorothiazide 25mg', 'Blood pressure medication', 'Rwanda Pharma', 'Diuretic', 700, 200, 20, TO_DATE('2026-02-28', 'YYYY-MM-DD'), SYSDATE);
INSERT INTO medicine VALUES (seq_medicine_id.NEXTVAL, 'Vitamin C 500mg', 'Immune system support', 'Kigali Pharmaceuticals', 'Vitamin', 300, 1000, 100, TO_DATE('2026-06-30', 'YYYY-MM-DD'), SYSDATE);
INSERT INTO medicine VALUES (seq_medicine_id.NEXTVAL, 'Zinc Sulfate 20mg', 'Immune booster', 'East Africa Pharma', 'Mineral', 400, 800, 80, TO_DATE('2026-05-31', 'YYYY-MM-DD'), SYSDATE);
INSERT INTO medicine VALUES (seq_medicine_id.NEXTVAL
```
  
- 10+ prescriptions and payment records  
```sql
-- Inserting prescriptions with proper doctor-patient relationships
INSERT INTO prescription VALUES (seq_prescription_id.NEXTVAL, 1001, 10001, TO_DATE('2023-01-05', 'YYYY-MM-DD'), 'COMPLETED', 'Fever and headache', NULL);
INSERT INTO prescription VALUES (seq_prescription_id.NEXTVAL, 1002, 10002, TO_DATE('2023-01-10', 'YYYY-MM-DD'), 'DISPENSED', 'Childhood vaccination follow-up', NULL);
INSERT INTO prescription VALUES (seq_prescription_id.NEXTVAL, 1003, 10003, TO_DATE('2023-01-15', 'YYYY-MM-DD'), 'VALIDATED', 'Diabetes management', 'Monitor blood sugar levels');
INSERT INTO prescription VALUES (seq_prescription_id.NEXTVAL, 1004, 10004, TO_DATE('2023-01-20', 'YYYY-MM-DD'), 'NEW', 'Skin rash', NULL);
INSERT INTO prescription VALUES (seq_prescription_id.NEXTVAL, 1005, 10005, TO_DATE('2023-01-25', 'YYYY-MM-DD'), 'CANCELLED', 'Migraine - patient cancelled', NULL);
INSERT INTO prescription VALUES (seq_prescription_id.NEXTVAL, 1001, 10006, TO_DATE('2023-02-01', 'YYYY-MM-DD'), 'COMPLETED', 'Annual checkup', NULL);
INSERT INTO prescription VALUES (seq_prescription_id.NEXTVAL, 1002, 10007, TO_DATE('2023-02-05', 'YYYY-MM-DD'), 'DISPENSED', 'Pediatric asthma', 'Use inhaler as directed');
INSERT INTO prescription VALUES (seq_prescription_id.NEXTVAL, 1003, 10008, TO_DATE('2023-02-10', 'YYYY-MM-DD'), 'VALIDATED', 'Neurological consultation', NULL);
INSERT INTO prescription VALUES (seq_prescription_id.NEXTVAL, 1004, 10009, TO_DATE('2023-02-15', 'YYYY-MM-DD'), 'NEW', 'Acne treatment', NULL);
```
###  Data Integrity

- Insert statements used with validation constraints  
- Referential integrity ensured via foreign keys  
- `CHECK`, `NOT NULL`, and `UNIQUE` constraints applied
  

##  Phase 6: Transaction Handling

###  Stored Procedures & Functions

- **Procedures** to issue prescriptions and insert payments  
- **Functions** to calculate total price and fetch prescription details  
- All operations tested with realistic transaction sequences  

###  Cursors & Exception Handling

- Used **explicit cursors** to iterate through prescriptions  
- Built-in **exception blocks** handle duplicate entries or invalid inputs  
```sql
CREATE OR REPLACE PACKAGE pharmacy_pkg AS
    -- Cursor to get all active prescriptions
    CURSOR c_active_prescriptions IS
        SELECT p.prescription_id, p.issue_date, p.status,
               d.name AS doctor_name, pt.name AS patient_name
        FROM prescription p
        JOIN doctor d ON p.doctor_id = d.doctor_id
        JOIN patient pt ON p.patient_id = pt.patient_id
        WHERE p.status IN ('NEW', 'VALIDATED', 'DISPENSED');
    
    -- Cursor to get low stock medicines
    CURSOR c_low_stock_medicines IS
        SELECT medicine_id, name, current_stock, reorder_level
        FROM medicine
        WHERE current_stock <= reorder_level;
    
    -- Procedure to process a prescription
    PROCEDURE process_prescription(
        p_prescription_id IN NUMBER,
        p_action IN VARCHAR2,
        p_result OUT VARCHAR2
    );
    
    -- Function to calculate prescription total
    FUNCTION calculate_prescription_total(
        p_prescription_id IN NUMBER
    ) RETURN NUMBER;
    
    -- Procedure to generate inventory report
    PROCEDURE generate_inventory_report(
        p_start_date IN DATE DEFAULT NULL,
        p_end_date IN DATE DEFAULT NULL,
        p_report OUT SYS_REFCURSOR
    );
    
    -- Procedure to get patient prescription history
    PROCEDURE get_patient_history(
        p_patient_id IN NUMBER,
        p_history OUT SYS_REFCURSOR
    );
END pharmacy_pkg;
/
```
###  Packages

- Reusable **packages** grouped business logic (e.g., billing, inventory update)

```sql
CREATE OR REPLACE PACKAGE pharmacy_pkg AS
    -- Cursor to get all active prescriptions
    CURSOR c_active_prescriptions IS
        SELECT p.prescription_id, p.issue_date, p.status,
               d.name AS doctor_name, pt.name AS patient_name
        FROM prescription p
        JOIN doctor d ON p.doctor_id = d.doctor_id
        JOIN patient pt ON p.patient_id = pt.patient_id
        WHERE p.status IN ('NEW', 'VALIDATED', 'DISPENSED');
    
    -- Cursor to get low stock medicines
    CURSOR c_low_stock_medicines IS
        SELECT medicine_id, name, current_stock, reorder_level
        FROM medicine
        WHERE current_stock <= reorder_level;
    
    -- Procedure to process a prescription
    PROCEDURE process_prescription(
        p_prescription_id IN NUMBER,
        p_action IN VARCHAR2,
        p_result OUT VARCHAR2
    );
    
    -- Function to calculate prescription total
    FUNCTION calculate_prescription_total(
        p_prescription_id IN NUMBER
    ) RETURN NUMBER;
    
    -- Procedure to generate inventory report
    PROCEDURE generate_inventory_report(
        p_start_date IN DATE DEFAULT NULL,
        p_end_date IN DATE DEFAULT NULL,
        p_report OUT SYS_REFCURSOR
    );
    
    -- Procedure to get patient prescription history
    PROCEDURE get_patient_history(
        p_patient_id IN NUMBER,
        p_history OUT SYS_REFCURSOR
    );
END pharmacy_pkg;
/
```
##  Phase 7: Security Features & Auditing

###  Triggers

- **BEFORE INSERT**: Auto-update stock when a medicine is prescribed  
- **AFTER UPDATE/DELETE**: Audit sensitive changes
  ```sql
  
  -- Update prescription status
    UPDATE prescription SET status = 'DISPENSED'
    WHERE prescription_id = :NEW.prescription_id;
    
    -- Process each medicine item
    FOR item IN (SELECT medicine_id, quantity FROM prescription_items 
                WHERE prescription_id = :NEW.prescription_id)
    LOOP
        -- Get current stock level
        SELECT current_stock INTO v_current_stock FROM medicine
        WHERE medicine_id = item.medicine_id;
        
        -- Check stock availability
        IF v_current_stock < item.quantity THEN
            RAISE_APPLICATION_ERROR(-20003, 
                'Insufficient stock for medicine ID ' || item.medicine_id);
        END IF;
  ```

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
```

###  Restriction Logic

- Created a **trigger** to block `INSERT`, `UPDATE`, `DELETE` during weekdays and public holidays  
- Referenced a **holiday table** storing static dates for enforcement  

###  Auditing

- Audited user actions on sensitive tables  
- Logged data includes:
  - **User ID**
  - **Action Date & Time**
  - **Operation Attempted**
  - **Status (Allowed / Denied)**
 

![Audit](https://github.com/user-attachments/assets/4e8d0e5a-be14-4ce1-9bcc-713271accc28)

##  Phase 8: Reporting and Query Optimization

###  GitHub Report

The GitHub repository contains:
- SQL scripts (DDL, DML, Triggers, Procedures, Packages)
- Screenshot folder (OEM monitoring, data queries)
- This complete `README.md` documentation

###  Reports & Queries

- Analytical queries for:
  - Low stock medicines
  - Total sales per doctor/patient
  - Daily revenue summaries  
- Indexed commonly queried fields for faster execution

###  Presentation

A **10-slide PowerPoint presentation** summarizes:
- Project background
- System architecture
- Implementation steps
- Screenshots
- Results and future recommendations


##  Conclusion

The Pharmacy Management System demonstrates how database-driven automation can resolve real-world inefficiencies in pharmaceutical services. With features like prescription validation, stock management, secure billing, and auditing, it ensures operational accuracy and compliance.

This project showcases the power of **PL/SQL programming** combined with thoughtful design, making it a practical solution for pharmacy digital transformation.

---

##  Tools & Technologies Used
- **Database**: Oracle 19c  
- **Language**: PL/SQL  
- **Modeling**: Draw.io, Lucidchart  
- **Monitoring**: Oracle Enterprise Manager  
- **Documentation**: GitHub, PowerPoint  

---

##  Contact
**uwitonze pacific**  
📧 Email: [pacific.uwitonze112@gmail.com]  


---

> _"Whatever you do, work at it with all your heart, as working for the Lord, not for human masters."_ — **Colossians 3:23**


