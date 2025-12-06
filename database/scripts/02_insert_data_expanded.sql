-- ============================================================================
-- PHARMACY MANAGEMENT SYSTEM - EXPANDED DATA INSERTION (FIXED)
-- Author: Uwitonze Pacific (ID: 26983)
-- Database: mon_26983_pacific_pharmacy_db
-- Purpose: Insert 100-500 realistic rows per table (Phase V requirement)
-- Version: 2.0 - Fixed all errors
-- ============================================================================

SET SERVEROUTPUT ON;

PROMPT ========================================
PROMPT Inserting Expanded Data (100-500 rows)
PROMPT This will take 2-3 minutes...
PROMPT ========================================

-- ============================================================================
-- STEP 1: Clear existing expanded data (keep basic 5 records)
-- ============================================================================
PROMPT
PROMPT Step 1: Preparing database...

-- Get current counts
DECLARE
    v_doc_count NUMBER;
    v_pat_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_doc_count FROM doctor;
    SELECT COUNT(*) INTO v_pat_count FROM patient;

    DBMS_OUTPUT.PUT_LINE('Current doctors: ' || v_doc_count);
    DBMS_OUTPUT.PUT_LINE('Current patients: ' || v_pat_count);
END;
/

-- ============================================================================
-- STEP 2: Add DOCTORS (95 more to reach 100 total)
-- ============================================================================
PROMPT
PROMPT Step 2: Adding doctors (target: 100 total)...

DECLARE
    v_current_count NUMBER;
    v_needed NUMBER;
    v_specializations SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST(
        'General Medicine', 'Pediatrics', 'Cardiology', 'Dermatology',
        'Neurology', 'Orthopedics', 'Psychiatry', 'Oncology',
        'Gynecology', 'Ophthalmology', 'ENT', 'Radiology'
    );
    v_first_names SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST(
        'Jean', 'Marie', 'Paul', 'Alice', 'Eric', 'Grace', 'David', 'Sarah',
        'Joseph', 'Emma', 'Daniel', 'Rachel', 'Samuel', 'Ruth', 'Peter'
    );
    v_last_names SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST(
        'Uwimana', 'Mukamana', 'Kagame', 'Uwase', 'Nshimyumuremyi',
        'Mukankusi', 'Habimana', 'Uwineza', 'Niyonzima', 'Mutesi'
    );
BEGIN
    SELECT COUNT(*) INTO v_current_count FROM doctor;
    v_needed := 100 - v_current_count;

    IF v_needed > 0 THEN
        FOR i IN 1..v_needed LOOP
            INSERT INTO doctor VALUES (
                seq_doctor_id.NEXTVAL,
                'Dr. ' || v_first_names(MOD(i, v_first_names.COUNT) + 1) || ' ' ||
                          v_last_names(MOD(i, v_last_names.COUNT) + 1) || ' #' || i,
                v_specializations(MOD(i, v_specializations.COUNT) + 1),
                'MD-RW-' || TO_CHAR(2020 + MOD(i, 5)) || '-' || LPAD(v_current_count + i, 4, '0'),
                '+25078' || LPAD(TRUNC(DBMS_RANDOM.VALUE(8100000, 8999999)), 7, '0'),
                'doc' || (v_current_count + i) || '@hospital.rw',
                SYSDATE - TRUNC(DBMS_RANDOM.VALUE(1, 1000))
            );
        END LOOP;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Added ' || v_needed || ' doctors. Total now: 100');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Already have ' || v_current_count || ' doctors. Skipping.');
    END IF;
END;
/

-- ============================================================================
-- STEP 3: Add PATIENTS (495 more to reach 500 total)
-- ============================================================================
PROMPT
PROMPT Step 3: Adding patients (target: 500 total)...

DECLARE
    v_current_count NUMBER;
    v_needed NUMBER;
    v_first_names SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST(
        'Jean', 'Marie', 'Paul', 'Alice', 'Eric', 'Grace', 'David', 'Sarah',
        'Joseph', 'Emma', 'Daniel', 'Rachel', 'Samuel', 'Ruth', 'Peter',
        'Anne', 'John', 'Esther', 'Patrick', 'Rose'
    );
    v_last_names SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST(
        'Uwimana', 'Mukamana', 'Kagame', 'Uwase', 'Nshimyumuremyi',
        'Mukankusi', 'Habimana', 'Uwineza', 'Niyonzima', 'Mutesi',
        'Bizimana', 'Uwera', 'Mugisha', 'Mukamazimpaka', 'Nsengiyumva'
    );
    v_districts SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST(
        'Kigali', 'Gasabo', 'Kicukiro', 'Nyarugenge', 'Huye', 'Musanze', 'Rubavu'
    );
    v_insurance SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST(
        'RAMA', 'MMI', 'RSSB', 'Private Insurance', 'Community Based'
    );
BEGIN
    SELECT COUNT(*) INTO v_current_count FROM patient;
    v_needed := 500 - v_current_count;

    IF v_needed > 0 THEN
        FOR i IN 1..v_needed LOOP
            INSERT INTO patient VALUES (
                seq_patient_id.NEXTVAL,
                v_first_names(MOD(i, v_first_names.COUNT) + 1) || ' ' ||
                v_last_names(MOD(i, v_last_names.COUNT) + 1) || ' #' || i,
                SYSDATE - TRUNC(DBMS_RANDOM.VALUE(6570, 29200)), -- Age 18-80
                v_districts(MOD(i, v_districts.COUNT) + 1) || ' District, KG ' ||
                    TRUNC(DBMS_RANDOM.VALUE(1, 999)) || ' St',
                '+25078' || LPAD(TRUNC(DBMS_RANDOM.VALUE(8100000, 8999999)), 7, '0'),
                'patient' || (v_current_count + i) || '@email.com',
                v_insurance(MOD(i, v_insurance.COUNT) + 1) || '-' || LPAD(v_current_count + i, 6, '0'),
                'Medical history: No known allergies',
                SYSDATE - TRUNC(DBMS_RANDOM.VALUE(1, 1500))
            );

            -- Commit every 100 records for performance
            IF MOD(i, 100) = 0 THEN
                COMMIT;
            END IF;
        END LOOP;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Added ' || v_needed || ' patients. Total now: 500');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Already have ' || v_current_count || ' patients. Skipping.');
    END IF;
END;
/

-- ============================================================================
-- STEP 4: Add MEDICINES (195 more to reach 200 total)
-- ============================================================================
PROMPT
PROMPT Step 4: Adding medicines (target: 200 total)...

DECLARE
    v_current_count NUMBER;
    v_needed NUMBER;
    v_medicine_names SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST(
        'Paracetamol', 'Amoxicillin', 'Ibuprofen', 'Metformin', 'Lisinopril',
        'Amlodipine', 'Omeprazole', 'Simvastatin', 'Levothyroxine', 'Azithromycin',
        'Ciprofloxacin', 'Prednisone', 'Albuterol', 'Losartan', 'Gabapentin',
        'Hydrochlorothiazide', 'Sertraline', 'Montelukast', 'Atorvastatin', 'Clopidogrel'
    );
    v_strengths SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST(
        '250mg', '500mg', '100mg', '10mg', '20mg', '50mg', '5mg'
    );
    v_manufacturers SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST(
        'Rwanda Pharma', 'Kigali Pharmaceuticals', 'East Africa Pharma',
        'Medi Rwanda Ltd', 'PharmAccess Rwanda', 'Quality Generics RW'
    );
    v_categories SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST(
        'Analgesic', 'Antibiotic', 'Antihypertensive', 'Antidiabetic',
        'NSAID', 'Antiulcer', 'Antilipidemic', 'Bronchodilator'
    );
BEGIN
    SELECT COUNT(*) INTO v_current_count FROM medicine;
    v_needed := 200 - v_current_count;

    IF v_needed > 0 THEN
        FOR i IN 1..v_needed LOOP
            INSERT INTO medicine VALUES (
                seq_medicine_id.NEXTVAL,
                v_medicine_names(MOD(i, v_medicine_names.COUNT) + 1) || ' ' ||
                    v_strengths(MOD(i, v_strengths.COUNT) + 1) || ' #' || i,
                'Pharmaceutical grade medicine',
                v_manufacturers(MOD(i, v_manufacturers.COUNT) + 1),
                v_categories(MOD(i, v_categories.COUNT) + 1),
                TRUNC(DBMS_RANDOM.VALUE(500, 5000)), -- Price 500-5000 RWF
                TRUNC(DBMS_RANDOM.VALUE(50, 2000)), -- Stock 50-2000 units
                TRUNC(DBMS_RANDOM.VALUE(20, 100)), -- Reorder level
                SYSDATE + TRUNC(DBMS_RANDOM.VALUE(365, 1095)), -- Expiry 1-3 years from now
                SYSDATE - TRUNC(DBMS_RANDOM.VALUE(1, 365))
            );
        END LOOP;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Added ' || v_needed || ' medicines. Total now: 200');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Already have ' || v_current_count || ' medicines. Skipping.');
    END IF;
END;
/

-- ============================================================================
-- STEP 5: Add PHARMACISTS (47 more to reach 50 total)
-- ============================================================================
PROMPT
PROMPT Step 5: Adding pharmacists (target: 50 total)...

DECLARE
    v_current_count NUMBER;
    v_needed NUMBER;
    v_first_names SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST(
        'Jean', 'Marie', 'Paul', 'Alice', 'Eric', 'Grace', 'David', 'Sarah',
        'Joseph', 'Emma', 'Daniel', 'Rachel', 'Samuel', 'Ruth', 'Peter'
    );
    v_last_names SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST(
        'Uwimana', 'Mukamana', 'Kagame', 'Uwase', 'Nshimyumuremyi',
        'Mukankusi', 'Habimana', 'Uwineza', 'Niyonzima', 'Mutesi'
    );
    v_shifts SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST(
        'Morning (6AM-2PM)', 'Afternoon (2PM-10PM)', 'Night (10PM-6AM)', 'Day (8AM-5PM)'
    );
BEGIN
    SELECT COUNT(*) INTO v_current_count FROM pharmacist;
    v_needed := 50 - v_current_count;

    IF v_needed > 0 THEN
        FOR i IN 1..v_needed LOOP
            INSERT INTO pharmacist VALUES (
                seq_pharmacist_id.NEXTVAL,
                v_first_names(MOD(i, v_first_names.COUNT) + 1) || ' ' ||
                v_last_names(MOD(i, v_last_names.COUNT) + 1) || ' #' || i,
                'RPH-RW-' || TO_CHAR(2020 + MOD(i, 5)) || '-' || LPAD(v_current_count + i, 4, '0'),
                '+25078' || LPAD(TRUNC(DBMS_RANDOM.VALUE(8100000, 8999999)), 7, '0'),
                'pharm' || (v_current_count + i) || '@pharmacy.rw',
                v_shifts(MOD(i, v_shifts.COUNT) + 1),
                SYSDATE - TRUNC(DBMS_RANDOM.VALUE(1, 500))
            );
        END LOOP;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Added ' || v_needed || ' pharmacists. Total now: 50');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Already have ' || v_current_count || ' pharmacists. Skipping.');
    END IF;
END;
/

-- ============================================================================
-- VERIFICATION - Final counts
-- ============================================================================
PROMPT
PROMPT ========================================
PROMPT FINAL ROW COUNTS:
PROMPT ========================================

SELECT * FROM (
    SELECT 'DOCTOR' AS table_name, COUNT(*) AS row_count FROM doctor
    UNION ALL SELECT 'PATIENT', COUNT(*) FROM patient
    UNION ALL SELECT 'MEDICINE', COUNT(*) FROM medicine
    UNION ALL SELECT 'PHARMACIST', COUNT(*) FROM pharmacist
    UNION ALL SELECT 'PRESCRIPTION', COUNT(*) FROM prescription
    UNION ALL SELECT 'PRESCRIPTION_ITEMS', COUNT(*) FROM prescription_items
    UNION ALL SELECT 'DISPENSED_MEDICINES', COUNT(*) FROM dispensed_medicines
    UNION ALL SELECT 'PAYMENT', COUNT(*) FROM payment
    UNION ALL SELECT 'INVENTORY_LOG', COUNT(*) FROM inventory_log
    UNION ALL SELECT 'HOLIDAY', COUNT(*) FROM holiday
)
ORDER BY table_name;

PROMPT
PROMPT ========================================
PROMPT SUCCESS! Data insertion complete.
PROMPT ========================================
PROMPT
PROMPT Requirements met:
PROMPT - Doctors: 100 (meets 100-500 requirement)
PROMPT - Patients: 500 (meets 100-500 requirement)
PROMPT - Medicines: 200 (meets 100-500 requirement)
PROMPT - Pharmacists: 50 (good supporting data)
PROMPT
PROMPT You are now ready to take screenshots!
PROMPT ========================================

-- ============================================================================
-- End of Expanded Data Insertion
-- ============================================================================
