-- ============================================================================
-- PHARMACY MANAGEMENT SYSTEM - WINDOW FUNCTIONS
-- Author: Uwitonze Pacific (ID: 26983)
-- Database: mon_26983_pacific_pharmacy_db
-- Purpose: Demonstrate window functions (Phase VI requirement)
-- ============================================================================

-- ============================================================================
-- 1. ROW_NUMBER() - Assign unique sequential number to rows
-- Use Case: Number prescriptions by patient chronologically
-- ============================================================================

SELECT
    patient_id,
    prescription_id,
    issue_date,
    status,
    ROW_NUMBER() OVER (
        PARTITION BY patient_id
        ORDER BY issue_date DESC
    ) AS prescription_sequence
FROM prescription
ORDER BY patient_id, prescription_sequence
FETCH FIRST 20 ROWS ONLY;

-- ============================================================================
-- 2. RANK() - Rank with gaps for ties
-- Use Case: Rank doctors by number of prescriptions (with ties)
-- ============================================================================

SELECT
    d.doctor_id,
    d.name AS doctor_name,
    d.specialization,
    COUNT(p.prescription_id) AS prescription_count,
    RANK() OVER (
        ORDER BY COUNT(p.prescription_id) DESC
    ) AS doctor_rank
FROM doctor d
LEFT JOIN prescription p ON d.doctor_id = p.doctor_id
GROUP BY d.doctor_id, d.name, d.specialization
ORDER BY doctor_rank
FETCH FIRST 20 ROWS ONLY;

-- ============================================================================
-- 3. DENSE_RANK() - Rank without gaps
-- Use Case: Rank medicines by revenue (no gaps in ranking)
-- ============================================================================

SELECT
    m.medicine_id,
    m.name,
    m.category,
    SUM(m.unit_price * pi.quantity) AS total_revenue,
    DENSE_RANK() OVER (
        ORDER BY SUM(m.unit_price * pi.quantity) DESC
    ) AS revenue_rank,
    DENSE_RANK() OVER (
        PARTITION BY m.category
        ORDER BY SUM(m.unit_price * pi.quantity) DESC
    ) AS category_rank
FROM medicine m
JOIN prescription_items pi ON m.medicine_id = pi.medicine_id
GROUP BY m.medicine_id, m.name, m.category
ORDER BY total_revenue DESC
FETCH FIRST 20 ROWS ONLY;

-- ============================================================================
-- 4. LAG() - Access previous row value
-- Use Case: Compare current stock with previous transaction stock
-- ============================================================================

SELECT
    medicine_id,
    transaction_type,
    quantity,
    transaction_date,
    LAG(quantity, 1, 0) OVER (
        PARTITION BY medicine_id
        ORDER BY transaction_date
    ) AS previous_quantity,
    quantity - LAG(quantity, 1, 0) OVER (
        PARTITION BY medicine_id
        ORDER BY transaction_date
    ) AS quantity_change
FROM inventory_log
ORDER BY medicine_id, transaction_date DESC
FETCH FIRST 30 ROWS ONLY;

-- ============================================================================
-- 5. LEAD() - Access next row value
-- Use Case: Predict next payment based on payment patterns
-- ============================================================================

SELECT
    payment_id,
    prescription_id,
    amount,
    payment_date,
    LEAD(amount, 1) OVER (
        ORDER BY payment_date
    ) AS next_payment_amount,
    LEAD(payment_date, 1) OVER (
        ORDER BY payment_date
    ) AS next_payment_date,
    ROUND(
        LEAD(amount, 1) OVER (ORDER BY payment_date) - amount,
        2
    ) AS amount_difference
FROM payment
WHERE status = 'COMPLETED'
ORDER BY payment_date DESC
FETCH FIRST 20 ROWS ONLY;

-- ============================================================================
-- 6. NTILE() - Divide rows into N groups
-- Use Case: Categorize medicines into quartiles by price
-- ============================================================================

SELECT
    medicine_id,
    name,
    unit_price,
    NTILE(4) OVER (
        ORDER BY unit_price
    ) AS price_quartile,
    CASE NTILE(4) OVER (ORDER BY unit_price)
        WHEN 1 THEN 'Budget'
        WHEN 2 THEN 'Economic'
        WHEN 3 THEN 'Standard'
        WHEN 4 THEN 'Premium'
    END AS price_category
FROM medicine
ORDER BY unit_price DESC;

-- ============================================================================
-- 7. FIRST_VALUE() and LAST_VALUE() - Access first and last values
-- Use Case: Compare each payment with highest and lowest in the month
-- ============================================================================

SELECT
    payment_id,
    TO_CHAR(payment_date, 'YYYY-MM') AS payment_month,
    amount,
    FIRST_VALUE(amount) OVER (
        PARTITION BY TO_CHAR(payment_date, 'YYYY-MM')
        ORDER BY amount DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS highest_payment_in_month,
    LAST_VALUE(amount) OVER (
        PARTITION BY TO_CHAR(payment_date, 'YYYY-MM')
        ORDER BY amount DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS lowest_payment_in_month
FROM payment
WHERE status = 'COMPLETED'
ORDER BY payment_date DESC
FETCH FIRST 30 ROWS ONLY;

-- ============================================================================
-- 8. SUM() OVER - Running total
-- Use Case: Calculate cumulative revenue over time
-- ============================================================================

SELECT
    TRUNC(payment_date) AS payment_day,
    COUNT(*) AS daily_transactions,
    SUM(amount) AS daily_revenue,
    SUM(SUM(amount)) OVER (
        ORDER BY TRUNC(payment_date)
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_revenue
FROM payment
WHERE status = 'COMPLETED'
AND payment_date >= SYSDATE - 30
GROUP BY TRUNC(payment_date)
ORDER BY payment_day;

-- ============================================================================
-- 9. AVG() OVER - Moving average
-- Use Case: Calculate 7-day moving average of daily revenue
-- ============================================================================

SELECT
    TRUNC(payment_date) AS payment_day,
    SUM(amount) AS daily_revenue,
    ROUND(AVG(SUM(amount)) OVER (
        ORDER BY TRUNC(payment_date)
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ), 2) AS moving_avg_7days
FROM payment
WHERE status = 'COMPLETED'
AND payment_date >= SYSDATE - 90
GROUP BY TRUNC(payment_date)
ORDER BY payment_day DESC;

-- ============================================================================
-- 10. PERCENT_RANK() - Percentile rank
-- Use Case: Percentile ranking of pharmacists by dispensing activity
-- ============================================================================

SELECT
    ph.pharmacist_id,
    ph.name,
    COUNT(dm.dispensed_id) AS dispensed_count,
    PERCENT_RANK() OVER (
        ORDER BY COUNT(dm.dispensed_id)
    ) AS percentile_rank,
    ROUND(
        PERCENT_RANK() OVER (ORDER BY COUNT(dm.dispensed_id)) * 100,
        2
    ) AS percentile_score
FROM pharmacist ph
LEFT JOIN dispensed_medicines dm ON ph.pharmacist_id = dm.pharmacist_id
GROUP BY ph.pharmacist_id, ph.name
ORDER BY dispensed_count DESC;

-- ============================================================================
-- 11. RATIO_TO_REPORT() - Calculate ratio to total
-- Use Case: Each medicine category's percentage of total revenue
-- ============================================================================

SELECT
    m.category,
    SUM(m.unit_price * pi.quantity) AS category_revenue,
    ROUND(
        RATIO_TO_REPORT(SUM(m.unit_price * pi.quantity)) OVER () * 100,
        2
    ) AS percentage_of_total
FROM medicine m
JOIN prescription_items pi ON m.medicine_id = pi.medicine_id
GROUP BY m.category
ORDER BY category_revenue DESC;

-- ============================================================================
-- 12. Complex Window Function - Top 3 medicines per category
-- Use Case: Show best-selling medicines in each category
-- ============================================================================

WITH medicine_sales AS (
    SELECT
        m.medicine_id,
        m.name,
        m.category,
        COUNT(pi.item_id) AS times_prescribed,
        SUM(pi.quantity) AS total_quantity_sold,
        SUM(m.unit_price * pi.quantity) AS revenue,
        ROW_NUMBER() OVER (
            PARTITION BY m.category
            ORDER BY SUM(m.unit_price * pi.quantity) DESC
        ) AS rank_in_category
    FROM medicine m
    JOIN prescription_items pi ON m.medicine_id = pi.medicine_id
    GROUP BY m.medicine_id, m.name, m.category
)
SELECT
    category,
    name AS medicine_name,
    times_prescribed,
    total_quantity_sold,
    revenue,
    rank_in_category
FROM medicine_sales
WHERE rank_in_category <= 3
ORDER BY category, rank_in_category;

-- ============================================================================
-- 13. PARTITION BY with multiple columns
-- Use Case: Analyze prescription patterns by doctor specialty and status
-- ============================================================================

SELECT
    d.specialization,
    p.status,
    COUNT(*) AS prescription_count,
    ROUND(
        RATIO_TO_REPORT(COUNT(*)) OVER (
            PARTITION BY d.specialization
        ) * 100,
        2
    ) AS pct_within_specialty,
    RANK() OVER (
        PARTITION BY d.specialization
        ORDER BY COUNT(*) DESC
    ) AS status_rank_in_specialty
FROM prescription p
JOIN doctor d ON p.doctor_id = d.doctor_id
GROUP BY d.specialization, p.status
ORDER BY d.specialization, prescription_count DESC;

-- ============================================================================
-- 14. Window Frame Specification - Custom ranges
-- Use Case: Compare each doctor's performance to dept average
-- ============================================================================

SELECT
    d.doctor_id,
    d.name,
    d.specialization,
    COUNT(p.prescription_id) AS prescription_count,
    ROUND(AVG(COUNT(p.prescription_id)) OVER (
        PARTITION BY d.specialization
    ), 2) AS specialty_avg,
    ROUND(
        COUNT(p.prescription_id) - AVG(COUNT(p.prescription_id)) OVER (
            PARTITION BY d.specialization
        ),
        2
    ) AS deviation_from_avg
FROM doctor d
LEFT JOIN prescription p ON d.doctor_id = p.doctor_id
GROUP BY d.doctor_id, d.name, d.specialization
ORDER BY d.specialization, prescription_count DESC;

-- ============================================================================
-- End of Window Functions Script
-- ============================================================================
