
-- Daily Revenue Summary
SELECT TRUNC(payment_date) AS date,
       COUNT(*) AS transactions,
       SUM(amount) AS total_revenue,
       ROUND(AVG(amount), 2) AS avg_transaction
FROM payment
WHERE status = 'COMPLETED'
GROUP BY TRUNC(payment_date)
ORDER BY date DESC;

-- Monthly Revenue Summary
SELECT TO_CHAR(payment_date, 'YYYY-MM') AS month,
       COUNT(*) AS transactions,
       SUM(amount) AS total_revenue,
       ROUND(AVG(amount), 2) AS avg_transaction
FROM payment
WHERE status = 'COMPLETED'
GROUP BY TO_CHAR(payment_date, 'YYYY-MM')
ORDER BY month DESC;

-- Revenue by Payment Method
SELECT payment_method,
       COUNT(*) AS transaction_count,
       SUM(amount) AS total_amount,
       ROUND(SUM(amount) * 100.0 / SUM(SUM(amount)) OVER(), 2) AS percentage
FROM payment
WHERE status = 'COMPLETED'
GROUP BY payment_method
ORDER BY total_amount DESC;

-- Revenue by Doctor
SELECT d.name AS doctor_name,
       d.specialization,
       COUNT(p.prescription_id) AS prescriptions,
       SUM(pay.amount) AS total_revenue
FROM doctor d
JOIN prescription p ON d.doctor_id = p.doctor_id
JOIN payment pay ON p.prescription_id = pay.prescription_id
WHERE pay.status = 'COMPLETED'
GROUP BY d.name, d.specialization
ORDER BY total_revenue DESC;

-- Year-over-Year Revenue Comparison
SELECT TO_CHAR(payment_date, 'YYYY') AS year,
       TO_CHAR(payment_date, 'MM') AS month,
       SUM(amount) AS revenue
FROM payment
WHERE status = 'COMPLETED'
GROUP BY TO_CHAR(payment_date, 'YYYY'), TO_CHAR(payment_date, 'MM')
ORDER BY year, month;

-- Low Stock Alert
SELECT medicine_id, name, current_stock, reorder_level,
       (reorder_level - current_stock) AS shortage,
       unit_price,
       (reorder_level - current_stock) * unit_price AS restock_cost
FROM medicine
WHERE current_stock <= reorder_level
ORDER BY shortage DESC;

-- Out of Stock Medicines
SELECT medicine_id, name, category, reorder_level
FROM medicine
WHERE current_stock = 0;

-- Medicines Expiring Soon (within 30 days)
SELECT medicine_id, name,
       current_stock,
       TO_CHAR(expiry_date, 'DD-MON-YYYY') AS expiry_date,
       (expiry_date - TRUNC(SYSDATE)) AS days_remaining,
       (current_stock * unit_price) AS potential_loss
FROM medicine
WHERE expiry_date <= SYSDATE + 30
  AND expiry_date > SYSDATE
  AND current_stock > 0
ORDER BY expiry_date;

-- Stock Turnover Analysis
SELECT m.medicine_id, m.name, m.category,
       m.current_stock,
       NVL(SUM(CASE WHEN il.transaction_type = 'DEDUCT' THEN il.quantity ELSE 0 END), 0) AS total_sold,
       CASE
           WHEN m.current_stock > 0 THEN
               ROUND(NVL(SUM(CASE WHEN il.transaction_type = 'DEDUCT' THEN il.quantity ELSE 0 END), 0)
                     / m.current_stock, 2)
           ELSE 0
       END AS turnover_ratio
FROM medicine m
LEFT JOIN inventory_log il ON m.medicine_id = il.medicine_id
    AND il.transaction_date >= ADD_MONTHS(SYSDATE, -3)
GROUP BY m.medicine_id, m.name, m.category, m.current_stock
ORDER BY turnover_ratio DESC;

-- Inventory Value by Category
SELECT category,
       COUNT(*) AS product_count,
       SUM(current_stock) AS total_units,
       SUM(current_stock * unit_price) AS total_value,
       ROUND(SUM(current_stock * unit_price) * 100.0 /
             SUM(SUM(current_stock * unit_price)) OVER(), 2) AS value_percentage
FROM medicine
GROUP BY category
ORDER BY total_value DESC;

-- Total Inventory Value
SELECT SUM(current_stock * unit_price) AS total_inventory_value
FROM medicine;


-- Prescription Status Distribution
SELECT status,
       COUNT(*) AS count,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM prescription
GROUP BY status
ORDER BY count DESC;

-- Prescriptions by Day of Week
SELECT TO_CHAR(issue_date, 'DY') AS day_of_week,
       COUNT(*) AS prescription_count
FROM prescription
GROUP BY TO_CHAR(issue_date, 'DY'), TO_CHAR(issue_date, 'D')
ORDER BY TO_CHAR(issue_date, 'D');

-- Average Items per Prescription
SELECT ROUND(AVG(item_count), 2) AS avg_items_per_prescription
FROM (
    SELECT prescription_id, COUNT(*) AS item_count
    FROM prescription_items
    GROUP BY prescription_id
);

-- Top Prescribed Medicines
SELECT m.medicine_id, m.name, m.category,
       COUNT(pi.item_id) AS times_prescribed,
       SUM(pi.quantity) AS total_quantity
FROM medicine m
JOIN prescription_items pi ON m.medicine_id = pi.medicine_id
GROUP BY m.medicine_id, m.name, m.category
ORDER BY times_prescribed DESC
FETCH FIRST 10 ROWS ONLY;

-- Prescription Fulfillment Rate
SELECT
    COUNT(*) AS total_prescriptions,
    COUNT(CASE WHEN status IN ('DISPENSED', 'COMPLETED') THEN 1 END) AS fulfilled,
    ROUND(COUNT(CASE WHEN status IN ('DISPENSED', 'COMPLETED') THEN 1 END) * 100.0 /
          NULLIF(COUNT(*), 0), 2) AS fulfillment_rate
FROM prescription
WHERE issue_date >= ADD_MONTHS(SYSDATE, -1);

-- Average Processing Time (Issue to Dispense)
SELECT ROUND(AVG(dm.dispensing_date - p.issue_date) * 24 * 60, 2) AS avg_processing_minutes
FROM prescription p
JOIN dispensed_medicines dm ON p.prescription_id = dm.prescription_id
WHERE dm.dispensing_date >= ADD_MONTHS(SYSDATE, -1);


-- Active Patients (Last 90 days)
SELECT COUNT(DISTINCT patient_id) AS active_patients
FROM prescription
WHERE issue_date >= SYSDATE - 90;

-- Top Patients by Revenue
SELECT pt.patient_id, pt.name,
       COUNT(p.prescription_id) AS total_prescriptions,
       SUM(pay.amount) AS total_spent
FROM patient pt
JOIN prescription p ON pt.patient_id = p.patient_id
JOIN payment pay ON p.prescription_id = pay.prescription_id
WHERE pay.status = 'COMPLETED'
GROUP BY pt.patient_id, pt.name
ORDER BY total_spent DESC
FETCH FIRST 10 ROWS ONLY;

-- Patient Visit Frequency
SELECT pt.patient_id, pt.name,
       COUNT(p.prescription_id) AS visit_count,
       MIN(p.issue_date) AS first_visit,
       MAX(p.issue_date) AS last_visit
FROM patient pt
JOIN prescription p ON pt.patient_id = p.patient_id
GROUP BY pt.patient_id, pt.name
ORDER BY visit_count DESC;

-- Insurance vs Cash Patients
SELECT
    CASE WHEN pt.insurance_info IS NOT NULL THEN 'Insured' ELSE 'Non-Insured' END AS patient_type,
    COUNT(DISTINCT pt.patient_id) AS patient_count,
    COUNT(p.prescription_id) AS total_prescriptions
FROM patient pt
LEFT JOIN prescription p ON pt.patient_id = p.patient_id
GROUP BY CASE WHEN pt.insurance_info IS NOT NULL THEN 'Insured' ELSE 'Non-Insured' END;



-- Prescriptions Dispensed per Pharmacist
SELECT ph.pharmacist_id, ph.name,
       COUNT(dm.dispensed_id) AS prescriptions_dispensed
FROM pharmacist ph
LEFT JOIN dispensed_medicines dm ON ph.pharmacist_id = dm.pharmacist_id
GROUP BY ph.pharmacist_id, ph.name
ORDER BY prescriptions_dispensed DESC;

-- Revenue Generated per Pharmacist
SELECT ph.pharmacist_id, ph.name,
       COUNT(dm.dispensed_id) AS prescriptions,
       SUM(pay.amount) AS total_revenue
FROM pharmacist ph
JOIN dispensed_medicines dm ON ph.pharmacist_id = dm.pharmacist_id
JOIN payment pay ON dm.prescription_id = pay.prescription_id
WHERE pay.status = 'COMPLETED'
GROUP BY ph.pharmacist_id, ph.name
ORDER BY total_revenue DESC;

-- Daily Dispensing by Pharmacist
SELECT ph.name,
       TRUNC(dm.dispensing_date) AS date,
       COUNT(*) AS prescriptions_dispensed
FROM pharmacist ph
JOIN dispensed_medicines dm ON ph.pharmacist_id = dm.pharmacist_id
GROUP BY ph.name, TRUNC(dm.dispensing_date)
ORDER BY date DESC, prescriptions_dispensed DESC;



-- Weekly Prescription Trend
SELECT TO_CHAR(issue_date, 'IYYY-IW') AS year_week,
       COUNT(*) AS prescription_count
FROM prescription
WHERE issue_date >= ADD_MONTHS(SYSDATE, -3)
GROUP BY TO_CHAR(issue_date, 'IYYY-IW')
ORDER BY year_week;

-- Medicine Category Sales Trend
SELECT TO_CHAR(p.issue_date, 'YYYY-MM') AS month,
       m.category,
       SUM(pi.quantity * m.unit_price) AS sales
FROM prescription p
JOIN prescription_items pi ON p.prescription_id = pi.prescription_id
JOIN medicine m ON pi.medicine_id = m.medicine_id
WHERE p.status IN ('DISPENSED', 'COMPLETED')
GROUP BY TO_CHAR(p.issue_date, 'YYYY-MM'), m.category
ORDER BY month, sales DESC;

-- Peak Hours Analysis
SELECT TO_CHAR(issue_date, 'HH24') AS hour,
       COUNT(*) AS prescription_count
FROM prescription
GROUP BY TO_CHAR(issue_date, 'HH24')
ORDER BY hour;

