-- ============================================================================
-- PHARMACY MANAGEMENT SYSTEM - DATA INSERTION SCRIPT
-- Author: Uwitonze Pacific (ID: 26983)
-- Database: mon_26983_pacific_pharmacy_db
-- ============================================================================

-- ============================================================================
-- DOCTORS
-- ============================================================================

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

-- ============================================================================
-- PATIENTS
-- ============================================================================

INSERT INTO patient VALUES (seq_patient_id.NEXTVAL, 'Uwimana Jean',
    TO_DATE('1985-03-15', 'YYYY-MM-DD'), 'Kigali, Nyarugenge', '+250788111222',
    'jean.uwimana@email.rw', 'RSSB-2023-001', 'No known allergies', SYSDATE);
INSERT INTO patient VALUES (seq_patient_id.NEXTVAL, 'Habimana Eric',
    TO_DATE('1990-07-22', 'YYYY-MM-DD'), 'Kigali, Gasabo', '+250788222333',
    'eric.habimana@email.rw', 'MMI-2023-045', 'Diabetic', SYSDATE);
INSERT INTO patient VALUES (seq_patient_id.NEXTVAL, 'Mutoni Alice',
    TO_DATE('1978-11-08', 'YYYY-MM-DD'), 'Kigali, Kicukiro', '+250788333444',
    'alice.mutoni@email.rw', 'RSSB-2023-089', 'Hypertension', SYSDATE);
INSERT INTO patient VALUES (seq_patient_id.NEXTVAL, 'Ndayisaba Paul',
    TO_DATE('1995-01-30', 'YYYY-MM-DD'), 'Huye, Southern Province', '+250788444555',
    'paul.ndayisaba@email.rw', NULL, 'Asthmatic', SYSDATE);
INSERT INTO patient VALUES (seq_patient_id.NEXTVAL, 'Ingabire Marie',
    TO_DATE('2000-05-12', 'YYYY-MM-DD'), 'Musanze, Northern Province', '+250788555666',
    'marie.ingabire@email.rw', 'MMI-2023-112', 'No known allergies', SYSDATE);

-- ============================================================================
-- PHARMACISTS
-- ============================================================================

INSERT INTO pharmacist VALUES (seq_pharmacist_id.NEXTVAL, 'Mugabo Patrick',
    'PH-RW-2019-001', '+250788666777', 'patrick.mugabo@pharmacy.rw', '08:00-16:00', SYSDATE);
INSERT INTO pharmacist VALUES (seq_pharmacist_id.NEXTVAL, 'Uwera Claudine',
    'PH-RW-2020-023', '+250788777888', 'claudine.uwera@pharmacy.rw', '16:00-00:00', SYSDATE);
INSERT INTO pharmacist VALUES (seq_pharmacist_id.NEXTVAL, 'Hakizimana Jean Pierre',
    'PH-RW-2021-045', '+250788888999', 'jp.hakizimana@pharmacy.rw', '00:00-08:00', SYSDATE);

-- ============================================================================
-- MEDICINES
-- ============================================================================

INSERT INTO medicine VALUES (seq_medicine_id.NEXTVAL, 'Paracetamol 500mg',
    'Pain and fever relief', 'Rwanda Pharma', 'Analgesic', 500, 1000, 100,
    TO_DATE('2025-12-31', 'YYYY-MM-DD'), SYSDATE);
INSERT INTO medicine VALUES (seq_medicine_id.NEXTVAL, 'Amoxicillin 250mg',
    'Antibiotic capsule', 'Kigali Pharmaceuticals', 'Antibiotic', 1200, 500, 50,
    TO_DATE('2025-06-30', 'YYYY-MM-DD'), SYSDATE);
INSERT INTO medicine VALUES (seq_medicine_id.NEXTVAL, 'Ibuprofen 400mg',
    'Anti-inflammatory pain relief', 'East Africa Pharma', 'NSAID', 800, 750, 75,
    TO_DATE('2026-03-15', 'YYYY-MM-DD'), SYSDATE);
INSERT INTO medicine VALUES (seq_medicine_id.NEXTVAL, 'Metformin 500mg',
    'Diabetes management', 'Rwanda Pharma', 'Antidiabetic', 1500, 600, 60,
    TO_DATE('2025-09-30', 'YYYY-MM-DD'), SYSDATE);
INSERT INTO medicine VALUES (seq_medicine_id.NEXTVAL, 'Omeprazole 20mg',
    'Acid reflux treatment', 'Kigali Pharmaceuticals', 'Gastrointestinal', 2000, 400, 40,
    TO_DATE('2025-08-15', 'YYYY-MM-DD'), SYSDATE);
INSERT INTO medicine VALUES (seq_medicine_id.NEXTVAL, 'Aspirin 100mg',
    'Blood thinner and pain relief', 'East Africa Pharma', 'Cardiovascular', 300, 800, 80,
    TO_DATE('2026-01-20', 'YYYY-MM-DD'), SYSDATE);
INSERT INTO medicine VALUES (seq_medicine_id.NEXTVAL, 'Loratadine 10mg',
    'Antihistamine for allergies', 'Rwanda Pharma', 'Antihistamine', 600, 350, 35,
    TO_DATE('2025-11-30', 'YYYY-MM-DD'), SYSDATE);
INSERT INTO medicine VALUES (seq_medicine_id.NEXTVAL, 'Ciprofloxacin 500mg',
    'Broad-spectrum antibiotic', 'Kigali Pharmaceuticals', 'Antibiotic', 2500, 200, 20,
    TO_DATE('2025-07-31', 'YYYY-MM-DD'), SYSDATE);
INSERT INTO medicine VALUES (seq_medicine_id.NEXTVAL, 'Amlodipine 5mg',
    'Blood pressure control', 'East Africa Pharma', 'Cardiovascular', 1800, 450, 45,
    TO_DATE('2026-02-28', 'YYYY-MM-DD'), SYSDATE);
INSERT INTO medicine VALUES (seq_medicine_id.NEXTVAL, 'Salbutamol Inhaler',
    'Asthma relief inhaler', 'Rwanda Pharma', 'Respiratory', 5000, 150, 15,
    TO_DATE('2025-10-31', 'YYYY-MM-DD'), SYSDATE);

-- ============================================================================
-- PRESCRIPTIONS
-- ============================================================================

INSERT INTO prescription VALUES (seq_prescription_id.NEXTVAL, 1001, 10001,
    TO_DATE('2024-01-05', 'YYYY-MM-DD'), 'COMPLETED', 'Fever and headache', NULL);
INSERT INTO prescription VALUES (seq_prescription_id.NEXTVAL, 1002, 10002,
    TO_DATE('2024-01-10', 'YYYY-MM-DD'), 'DISPENSED', 'Diabetes management',
    'Monitor blood sugar levels');
INSERT INTO prescription VALUES (seq_prescription_id.NEXTVAL, 1003, 10003,
    TO_DATE('2024-01-15', 'YYYY-MM-DD'), 'VALIDATED', 'Hypertension control',
    'Regular BP monitoring required');
INSERT INTO prescription VALUES (seq_prescription_id.NEXTVAL, 1004, 10004,
    TO_DATE('2024-01-18', 'YYYY-MM-DD'), 'NEW', 'Asthma attack prevention', NULL);
INSERT INTO prescription VALUES (seq_prescription_id.NEXTVAL, 1005, 10005,
    TO_DATE('2024-01-20', 'YYYY-MM-DD'), 'COMPLETED', 'Bacterial infection', NULL);

-- ============================================================================
-- PRESCRIPTION ITEMS
-- ============================================================================

-- Prescription 1 items
INSERT INTO prescription_items VALUES (seq_item_id.NEXTVAL, 1, 1,
    '500mg twice daily', 20, 'Take after meals');
INSERT INTO prescription_items VALUES (seq_item_id.NEXTVAL, 1, 3,
    '400mg once daily', 10, 'Take with food');

-- Prescription 2 items
INSERT INTO prescription_items VALUES (seq_item_id.NEXTVAL, 2, 4,
    '500mg twice daily', 60, 'Take before meals');

-- Prescription 3 items
INSERT INTO prescription_items VALUES (seq_item_id.NEXTVAL, 3, 9,
    '5mg once daily', 30, 'Take in the morning');
INSERT INTO prescription_items VALUES (seq_item_id.NEXTVAL, 3, 6,
    '100mg once daily', 30, 'Take with water');

-- Prescription 4 items
INSERT INTO prescription_items VALUES (seq_item_id.NEXTVAL, 4, 10,
    '2 puffs as needed', 1, 'Use during asthma attacks');

-- Prescription 5 items
INSERT INTO prescription_items VALUES (seq_item_id.NEXTVAL, 5, 2,
    '250mg three times daily', 21, 'Complete full course');

-- ============================================================================
-- DISPENSED MEDICINES
-- ============================================================================

INSERT INTO dispensed_medicines VALUES (seq_dispensed_id.NEXTVAL, 1, 1,
    TO_DATE('2024-01-05', 'YYYY-MM-DD'));
INSERT INTO dispensed_medicines VALUES (seq_dispensed_id.NEXTVAL, 2, 2,
    TO_DATE('2024-01-10', 'YYYY-MM-DD'));
INSERT INTO dispensed_medicines VALUES (seq_dispensed_id.NEXTVAL, 5, 1,
    TO_DATE('2024-01-20', 'YYYY-MM-DD'));

-- ============================================================================
-- PAYMENTS
-- ============================================================================

INSERT INTO payment VALUES (seq_payment_id.NEXTVAL, 1, 18000,
    TO_DATE('2024-01-05', 'YYYY-MM-DD'), 'CASH', 'COMPLETED');
INSERT INTO payment VALUES (seq_payment_id.NEXTVAL, 2, 90000,
    TO_DATE('2024-01-10', 'YYYY-MM-DD'), 'INSURANCE', 'COMPLETED');
INSERT INTO payment VALUES (seq_payment_id.NEXTVAL, 3, 63000,
    TO_DATE('2024-01-15', 'YYYY-MM-DD'), 'CARD', 'PENDING');
INSERT INTO payment VALUES (seq_payment_id.NEXTVAL, 5, 25200,
    TO_DATE('2024-01-20', 'YYYY-MM-DD'), 'CASH', 'COMPLETED');

-- ============================================================================
-- INVENTORY LOG
-- ============================================================================

INSERT INTO inventory_log VALUES (seq_log_id.NEXTVAL, 1, 'ADD', 500,
    TO_DATE('2024-01-01', 'YYYY-MM-DD'), 'Initial stock');
INSERT INTO inventory_log VALUES (seq_log_id.NEXTVAL, 1, 'DEDUCT', 20,
    TO_DATE('2024-01-05', 'YYYY-MM-DD'), 'Dispensed for prescription #1');
INSERT INTO inventory_log VALUES (seq_log_id.NEXTVAL, 2, 'ADD', 300,
    TO_DATE('2024-01-01', 'YYYY-MM-DD'), 'Initial stock');
INSERT INTO inventory_log VALUES (seq_log_id.NEXTVAL, 2, 'DEDUCT', 21,
    TO_DATE('2024-01-20', 'YYYY-MM-DD'), 'Dispensed for prescription #5');
INSERT INTO inventory_log VALUES (seq_log_id.NEXTVAL, 4, 'DEDUCT', 60,
    TO_DATE('2024-01-10', 'YYYY-MM-DD'), 'Dispensed for prescription #2');

COMMIT;

-- ============================================================================
-- End of Script
-- ============================================================================
