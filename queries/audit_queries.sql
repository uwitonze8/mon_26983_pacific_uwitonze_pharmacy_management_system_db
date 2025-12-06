
-- Get all audit log entries
SELECT audit_id,
       user_id,
       TO_CHAR(action_date, 'DD-MON-YYYY HH24:MI:SS') AS action_time,
       operation,
       table_name,
       record_id,
       status
FROM audit_log
ORDER BY action_date DESC;

-- Get audit entries by table
SELECT audit_id,
       user_id,
       TO_CHAR(action_date, 'DD-MON-YYYY HH24:MI:SS') AS action_time,
       operation,
       old_value,
       new_value,
       status
FROM audit_log
WHERE table_name = :table_name
ORDER BY action_date DESC;

-- Get audit entries by user
SELECT audit_id,
       TO_CHAR(action_date, 'DD-MON-YYYY HH24:MI:SS') AS action_time,
       operation,
       table_name,
       record_id,
       status
FROM audit_log
WHERE user_id = :user_id
ORDER BY action_date DESC;

-- Get audit entries by date range
SELECT audit_id,
       user_id,
       TO_CHAR(action_date, 'DD-MON-YYYY HH24:MI:SS') AS action_time,
       operation,
       table_name,
       status
FROM audit_log
WHERE action_date BETWEEN :start_date AND :end_date
ORDER BY action_date DESC;

-- Get denied operations
SELECT audit_id,
       user_id,
       TO_CHAR(action_date, 'DD-MON-YYYY HH24:MI:SS') AS action_time,
       operation,
       table_name,
       old_value,
       new_value
FROM audit_log
WHERE status = 'DENIED'
ORDER BY action_date DESC;

-- Get allowed operations
SELECT audit_id,
       user_id,
       TO_CHAR(action_date, 'DD-MON-YYYY HH24:MI:SS') AS action_time,
       operation,
       table_name
FROM audit_log
WHERE status = 'ALLOWED'
ORDER BY action_date DESC;

-- Operations count by type
SELECT operation,
       COUNT(*) AS operation_count,
       ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM audit_log
GROUP BY operation
ORDER BY operation_count DESC;

-- Operations count by table
SELECT table_name,
       COUNT(*) AS operation_count,
       SUM(CASE WHEN operation = 'INSERT' THEN 1 ELSE 0 END) AS inserts,
       SUM(CASE WHEN operation = 'UPDATE' THEN 1 ELSE 0 END) AS updates,
       SUM(CASE WHEN operation = 'DELETE' THEN 1 ELSE 0 END) AS deletes
FROM audit_log
GROUP BY table_name
ORDER BY operation_count DESC;

-- Operations count by user
SELECT user_id,
       COUNT(*) AS total_operations,
       SUM(CASE WHEN status = 'ALLOWED' THEN 1 ELSE 0 END) AS allowed,
       SUM(CASE WHEN status = 'DENIED' THEN 1 ELSE 0 END) AS denied
FROM audit_log
GROUP BY user_id
ORDER BY total_operations DESC;

-- Daily audit activity
SELECT TRUNC(action_date) AS date,
       COUNT(*) AS total_operations,
       SUM(CASE WHEN status = 'ALLOWED' THEN 1 ELSE 0 END) AS allowed,
       SUM(CASE WHEN status = 'DENIED' THEN 1 ELSE 0 END) AS denied
FROM audit_log
GROUP BY TRUNC(action_date)
ORDER BY date DESC;

-- Hourly audit activity
SELECT TO_CHAR(action_date, 'HH24') AS hour,
       COUNT(*) AS operation_count
FROM audit_log
GROUP BY TO_CHAR(action_date, 'HH24')
ORDER BY hour;

-- Weekly audit summary
SELECT TO_CHAR(action_date, 'IYYY-IW') AS year_week,
       COUNT(*) AS total_operations,
       SUM(CASE WHEN status = 'DENIED' THEN 1 ELSE 0 END) AS violations
FROM audit_log
GROUP BY TO_CHAR(action_date, 'IYYY-IW')
ORDER BY year_week DESC;

-- Weekend operation attempts
SELECT audit_id,
       user_id,
       TO_CHAR(action_date, 'DY DD-MON-YYYY HH24:MI') AS attempt_time,
       operation,
       table_name,
       status
FROM audit_log
WHERE TO_CHAR(action_date, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH') IN ('SAT', 'SUN')
ORDER BY action_date DESC;

-- After-hours operation attempts (outside 8AM-6PM)
SELECT audit_id,
       user_id,
       TO_CHAR(action_date, 'DD-MON-YYYY HH24:MI') AS attempt_time,
       operation,
       table_name,
       status
FROM audit_log
WHERE TO_NUMBER(TO_CHAR(action_date, 'HH24')) NOT BETWEEN 8 AND 18
ORDER BY action_date DESC;

-- Repeated denial attempts by user (potential security threat)
SELECT user_id,
       COUNT(*) AS denial_count,
       MIN(action_date) AS first_denial,
       MAX(action_date) AS last_denial
FROM audit_log
WHERE status = 'DENIED'
GROUP BY user_id
HAVING COUNT(*) > 3
ORDER BY denial_count DESC;

-- Unusual activity patterns (high volume in short time)
SELECT user_id,
       TRUNC(action_date, 'HH') AS hour_block,
       COUNT(*) AS operations_in_hour
FROM audit_log
GROUP BY user_id, TRUNC(action_date, 'HH')
HAVING COUNT(*) > 10
ORDER BY operations_in_hour DESC;


-- Monthly compliance summary
SELECT TO_CHAR(action_date, 'YYYY-MM') AS month,
       table_name,
       COUNT(*) AS total_operations,
       SUM(CASE WHEN status = 'ALLOWED' THEN 1 ELSE 0 END) AS compliant,
       SUM(CASE WHEN status = 'DENIED' THEN 1 ELSE 0 END) AS violations,
       ROUND(SUM(CASE WHEN status = 'ALLOWED' THEN 1 ELSE 0 END) * 100.0 /
             NULLIF(COUNT(*), 0), 2) AS compliance_rate
FROM audit_log
GROUP BY TO_CHAR(action_date, 'YYYY-MM'), table_name
ORDER BY month DESC, table_name;

-- User activity report
SELECT user_id,
       MIN(action_date) AS first_activity,
       MAX(action_date) AS last_activity,
       COUNT(DISTINCT TRUNC(action_date)) AS active_days,
       COUNT(*) AS total_operations,
       ROUND(COUNT(*) / NULLIF(COUNT(DISTINCT TRUNC(action_date)), 0), 2) AS avg_ops_per_day
FROM audit_log
GROUP BY user_id
ORDER BY total_operations DESC;

-- Data modification history for specific record
SELECT audit_id,
       user_id,
       TO_CHAR(action_date, 'DD-MON-YYYY HH24:MI:SS') AS modification_time,
       operation,
       old_value,
       new_value
FROM audit_log
WHERE table_name = :table_name
  AND record_id = :record_id
ORDER BY action_date;


-- Stock adjustment history
SELECT il.log_id,
       m.name AS medicine_name,
       il.transaction_type,
       il.quantity,
       TO_CHAR(il.transaction_date, 'DD-MON-YYYY HH24:MI') AS transaction_time,
       il.notes
FROM inventory_log il
JOIN medicine m ON il.medicine_id = m.medicine_id
WHERE il.transaction_type = 'ADJUST'
ORDER BY il.transaction_date DESC;

-- Large quantity transactions (potential fraud detection)
SELECT il.log_id,
       m.name AS medicine_name,
       il.transaction_type,
       il.quantity,
       m.unit_price,
       (il.quantity * m.unit_price) AS transaction_value,
       TO_CHAR(il.transaction_date, 'DD-MON-YYYY HH24:MI') AS transaction_time
FROM inventory_log il
JOIN medicine m ON il.medicine_id = m.medicine_id
WHERE il.quantity > 100
ORDER BY il.quantity DESC;

-- Low stock alerts from logs
SELECT il.log_id,
       m.name AS medicine_name,
       il.notes,
       TO_CHAR(il.transaction_date, 'DD-MON-YYYY HH24:MI') AS alert_time
FROM inventory_log il
JOIN medicine m ON il.medicine_id = m.medicine_id
WHERE il.notes LIKE '%LOW STOCK ALERT%'
ORDER BY il.transaction_date DESC;


-- Prescription status change history
SELECT al.audit_id,
       al.user_id,
       TO_CHAR(al.action_date, 'DD-MON-YYYY HH24:MI') AS change_time,
       al.old_value,
       al.new_value
FROM audit_log al
WHERE al.table_name = 'PRESCRIPTION'
  AND al.operation = 'UPDATE'
ORDER BY al.action_date DESC;

-- Prescriptions modified after dispensing (suspicious)
SELECT p.prescription_id,
       pt.name AS patient_name,
       p.status,
       al.user_id,
       TO_CHAR(al.action_date, 'DD-MON-YYYY HH24:MI') AS modification_time,
       al.operation
FROM audit_log al
JOIN prescription p ON al.record_id = p.prescription_id
JOIN patient pt ON p.patient_id = pt.patient_id
WHERE al.table_name = 'PRESCRIPTION'
  AND p.status IN ('DISPENSED', 'COMPLETED')
  AND al.operation = 'UPDATE'
ORDER BY al.action_date DESC;

-- Payment modifications (potential fraud)
SELECT al.audit_id,
       al.user_id,
       TO_CHAR(al.action_date, 'DD-MON-YYYY HH24:MI') AS modification_time,
       al.operation,
       al.old_value,
       al.new_value
FROM audit_log al
WHERE al.table_name = 'PAYMENT'
  AND al.operation IN ('UPDATE', 'DELETE')
ORDER BY al.action_date DESC;

-- Large payment transactions
SELECT pay.payment_id,
       p.prescription_id,
       pt.name AS patient_name,
       pay.amount,
       pay.payment_method,
       TO_CHAR(pay.payment_date, 'DD-MON-YYYY') AS payment_date
FROM payment pay
JOIN prescription p ON pay.prescription_id = p.prescription_id
JOIN patient pt ON p.patient_id = pt.patient_id
WHERE pay.amount > 50000
ORDER BY pay.amount DESC;
