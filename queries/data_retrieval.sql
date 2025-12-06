
-- Get all doctors
SELECT doctor_id, name, specialization, license_number, phone, email
FROM doctor
ORDER BY name;

-- Get doctor by ID
SELECT * FROM doctor WHERE doctor_id = :doctor_id;

-- Get doctors by specialization
SELECT doctor_id, name, phone, email
FROM doctor
WHERE specialization = :specialization;

-- Get doctor with prescription count
SELECT d.doctor_id, d.name, d.specialization,
       COUNT(p.prescription_id) AS total_prescriptions
FROM doctor d
LEFT JOIN prescription p ON d.doctor_id = p.doctor_id
GROUP BY d.doctor_id, d.name, d.specialization
ORDER BY total_prescriptions DESC;

-- Get all patients
SELECT patient_id, name, dob, phone, email, insurance_info
FROM patient
ORDER BY name;

-- Get patient by ID with full details
SELECT patient_id, name,
       TO_CHAR(dob, 'DD-MON-YYYY') AS date_of_birth,
       TRUNC(MONTHS_BETWEEN(SYSDATE, dob) / 12) AS age,
       address, phone, email, insurance_info, medical_history
FROM patient
WHERE patient_id = :patient_id;

-- Get patients with insurance
SELECT patient_id, name, phone, insurance_info
FROM patient
WHERE insurance_info IS NOT NULL
ORDER BY name;

-- Get patient prescription history
SELECT p.prescription_id,
       TO_CHAR(p.issue_date, 'DD-MON-YYYY') AS issue_date,
       p.status,
       p.diagnosis,
       d.name AS doctor_name
FROM prescription p
JOIN doctor d ON p.doctor_id = d.doctor_id
WHERE p.patient_id = :patient_id
ORDER BY p.issue_date DESC;


-- Get all medicines with stock status
SELECT medicine_id, name, category,
       current_stock, reorder_level, unit_price,
       TO_CHAR(expiry_date, 'DD-MON-YYYY') AS expiry_date,
       CASE
           WHEN current_stock = 0 THEN 'OUT OF STOCK'
           WHEN current_stock <= reorder_level THEN 'LOW STOCK'
           ELSE 'IN STOCK'
       END AS stock_status
FROM medicine
ORDER BY category, name;

-- Get medicine by ID
SELECT * FROM medicine WHERE medicine_id = :medicine_id;

-- Get medicines by category
SELECT medicine_id, name, current_stock, unit_price
FROM medicine
WHERE category = :category
ORDER BY name;

-- Search medicines by name
SELECT medicine_id, name, category, current_stock, unit_price
FROM medicine
WHERE UPPER(name) LIKE UPPER('%' || :search_term || '%')
ORDER BY name;

-- Get medicine stock value
SELECT medicine_id, name, current_stock, unit_price,
       (current_stock * unit_price) AS stock_value
FROM medicine
ORDER BY stock_value DESC;


-- Get all prescriptions with details
SELECT p.prescription_id,
       TO_CHAR(p.issue_date, 'DD-MON-YYYY') AS issue_date,
       p.status,
       pt.name AS patient_name,
       d.name AS doctor_name,
       p.diagnosis
FROM prescription p
JOIN patient pt ON p.patient_id = pt.patient_id
JOIN doctor d ON p.doctor_id = d.doctor_id
ORDER BY p.issue_date DESC;

-- Get prescription by ID with items
SELECT p.prescription_id,
       TO_CHAR(p.issue_date, 'DD-MON-YYYY') AS issue_date,
       p.status, p.diagnosis, p.notes,
       pt.name AS patient_name,
       d.name AS doctor_name,
       m.name AS medicine_name,
       pi.dosage, pi.quantity, pi.instructions,
       m.unit_price,
       (pi.quantity * m.unit_price) AS item_total
FROM prescription p
JOIN patient pt ON p.patient_id = pt.patient_id
JOIN doctor d ON p.doctor_id = d.doctor_id
LEFT JOIN prescription_items pi ON p.prescription_id = pi.prescription_id
LEFT JOIN medicine m ON pi.medicine_id = m.medicine_id
WHERE p.prescription_id = :prescription_id;

-- Get prescriptions by status
SELECT p.prescription_id,
       TO_CHAR(p.issue_date, 'DD-MON-YYYY') AS issue_date,
       pt.name AS patient_name,
       d.name AS doctor_name
FROM prescription p
JOIN patient pt ON p.patient_id = pt.patient_id
JOIN doctor d ON p.doctor_id = d.doctor_id
WHERE p.status = :status
ORDER BY p.issue_date;

-- Get pending prescriptions (queue)
SELECT p.prescription_id,
       pt.name AS patient_name,
       d.name AS doctor_name,
       p.status,
       ROUND((SYSDATE - p.issue_date) * 24 * 60, 0) AS wait_minutes
FROM prescription p
JOIN patient pt ON p.patient_id = pt.patient_id
JOIN doctor d ON p.doctor_id = d.doctor_id
WHERE p.status IN ('NEW', 'VALIDATED')
ORDER BY p.issue_date;

-- Get all pharmacists
SELECT pharmacist_id, name, license_number, phone, shift_hours
FROM pharmacist
ORDER BY name;

-- Get pharmacist dispensing history
SELECT dm.dispensed_id,
       TO_CHAR(dm.dispensing_date, 'DD-MON-YYYY HH24:MI') AS dispensing_time,
       p.prescription_id,
       pt.name AS patient_name
FROM dispensed_medicines dm
JOIN prescription p ON dm.prescription_id = p.prescription_id
JOIN patient pt ON p.patient_id = pt.patient_id
WHERE dm.pharmacist_id = :pharmacist_id
ORDER BY dm.dispensing_date DESC;


-- Get all payments
SELECT pay.payment_id,
       pay.prescription_id,
       pt.name AS patient_name,
       pay.amount,
       TO_CHAR(pay.payment_date, 'DD-MON-YYYY') AS payment_date,
       pay.payment_method,
       pay.status
FROM payment pay
JOIN prescription p ON pay.prescription_id = p.prescription_id
JOIN patient pt ON p.patient_id = pt.patient_id
ORDER BY pay.payment_date DESC;

-- Get payments by status
SELECT pay.payment_id,
       pay.prescription_id,
       pt.name AS patient_name,
       pay.amount,
       pay.payment_method
FROM payment pay
JOIN prescription p ON pay.prescription_id = p.prescription_id
JOIN patient pt ON p.patient_id = pt.patient_id
WHERE pay.status = :status
ORDER BY pay.payment_date;

-- Get payment by prescription
SELECT * FROM payment WHERE prescription_id = :prescription_id;

-- Get inventory movement for a medicine
SELECT il.log_id,
       m.name AS medicine_name,
       il.transaction_type,
       il.quantity,
       TO_CHAR(il.transaction_date, 'DD-MON-YYYY HH24:MI') AS transaction_time,
       il.notes
FROM inventory_log il
JOIN medicine m ON il.medicine_id = m.medicine_id
WHERE il.medicine_id = :medicine_id
ORDER BY il.transaction_date DESC;

-- Get recent inventory transactions
SELECT il.log_id,
       m.name AS medicine_name,
       il.transaction_type,
       il.quantity,
       TO_CHAR(il.transaction_date, 'DD-MON-YYYY HH24:MI') AS transaction_time,
       il.notes
FROM inventory_log il
JOIN medicine m ON il.medicine_id = m.medicine_id
WHERE il.transaction_date >= SYSDATE - 7
ORDER BY il.transaction_date DESC;

-- Get dispensing record by prescription
SELECT dm.dispensed_id,
       ph.name AS pharmacist_name,
       TO_CHAR(dm.dispensing_date, 'DD-MON-YYYY HH24:MI') AS dispensing_time
FROM dispensed_medicines dm
JOIN pharmacist ph ON dm.pharmacist_id = ph.pharmacist_id
WHERE dm.prescription_id = :prescription_id;

-- Get today's dispensed medicines
SELECT dm.dispensed_id,
       p.prescription_id,
       pt.name AS patient_name,
       ph.name AS pharmacist_name,
       TO_CHAR(dm.dispensing_date, 'HH24:MI') AS time_dispensed
FROM dispensed_medicines dm
JOIN prescription p ON dm.prescription_id = p.prescription_id
JOIN patient pt ON p.patient_id = pt.patient_id
JOIN pharmacist ph ON dm.pharmacist_id = ph.pharmacist_id
WHERE TRUNC(dm.dispensing_date) = TRUNC(SYSDATE)
ORDER BY dm.dispensing_date DESC;

