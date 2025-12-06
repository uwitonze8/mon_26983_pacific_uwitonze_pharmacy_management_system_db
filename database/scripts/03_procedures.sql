-- ============================================================================
-- PHARMACY MANAGEMENT SYSTEM - STORED PROCEDURES
-- Author: Uwitonze Pacific (ID: 26983)
-- Database: mon_26983_pacific_pharmacy_db
-- ============================================================================

-- ============================================================================
-- PACKAGE SPECIFICATION
-- ============================================================================

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

    -- Procedure: Add new prescription
    PROCEDURE add_prescription(
        p_doctor_id IN NUMBER,
        p_patient_id IN NUMBER,
        p_diagnosis IN VARCHAR2,
        p_notes IN VARCHAR2 DEFAULT NULL,
        p_prescription_id OUT NUMBER
    );

    -- Procedure: Add prescription item
    PROCEDURE add_prescription_item(
        p_prescription_id IN NUMBER,
        p_medicine_id IN NUMBER,
        p_dosage IN VARCHAR2,
        p_quantity IN NUMBER,
        p_instructions IN VARCHAR2 DEFAULT NULL
    );

    -- Procedure: Update stock
    PROCEDURE update_stock(
        p_medicine_id IN NUMBER,
        p_quantity IN NUMBER,
        p_transaction_type IN VARCHAR2,
        p_notes IN VARCHAR2 DEFAULT NULL
    );

    -- Function: Get top medicines using window functions
    FUNCTION get_top_medicines_by_revenue(
        p_limit IN NUMBER DEFAULT 10
    ) RETURN SYS_REFCURSOR;

    -- Procedure: Get doctor performance ranking
    PROCEDURE get_doctor_performance_ranking(
        p_result OUT SYS_REFCURSOR
    );

    -- Function: Get medicine stock status
    FUNCTION get_stock_status(
        p_medicine_id IN NUMBER
    ) RETURN VARCHAR2;

END pharmacy_pkg;
/

-- ============================================================================
-- PACKAGE BODY
-- ============================================================================

CREATE OR REPLACE PACKAGE BODY pharmacy_pkg AS

    -- Process Prescription Procedure
    PROCEDURE process_prescription(
        p_prescription_id IN NUMBER,
        p_action IN VARCHAR2,
        p_result OUT VARCHAR2
    ) IS
        v_current_status VARCHAR2(20);
        v_new_status VARCHAR2(20);
        v_item_count NUMBER;
    BEGIN
        -- Get current status
        SELECT status INTO v_current_status
        FROM prescription
        WHERE prescription_id = p_prescription_id;

        -- Validate action
        CASE p_action
            WHEN 'VALIDATE' THEN
                IF v_current_status != 'NEW' THEN
                    p_result := 'ERROR: Can only validate NEW prescriptions';
                    RETURN;
                END IF;
                v_new_status := 'VALIDATED';

            WHEN 'DISPENSE' THEN
                IF v_current_status != 'VALIDATED' THEN
                    p_result := 'ERROR: Can only dispense VALIDATED prescriptions';
                    RETURN;
                END IF;
                v_new_status := 'DISPENSED';

            WHEN 'COMPLETE' THEN
                IF v_current_status != 'DISPENSED' THEN
                    p_result := 'ERROR: Can only complete DISPENSED prescriptions';
                    RETURN;
                END IF;
                v_new_status := 'COMPLETED';

            ELSE
                p_result := 'ERROR: Invalid action. Use VALIDATE, DISPENSE, or COMPLETE';
                RETURN;
        END CASE;

        -- Update prescription status
        UPDATE prescription
        SET status = v_new_status
        WHERE prescription_id = p_prescription_id;

        COMMIT;
        p_result := 'SUCCESS: Prescription ' || p_prescription_id ||
                    ' updated to ' || v_new_status;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_result := 'ERROR: Prescription not found';
        WHEN OTHERS THEN
            ROLLBACK;
            p_result := 'ERROR: ' || SQLERRM;
    END process_prescription;

    -- Calculate Prescription Total Function
    FUNCTION calculate_prescription_total(
        p_prescription_id IN NUMBER
    ) RETURN NUMBER IS
        v_total NUMBER := 0;
    BEGIN
        SELECT NVL(SUM(pi.quantity * m.unit_price), 0)
        INTO v_total
        FROM prescription_items pi
        JOIN medicine m ON pi.medicine_id = m.medicine_id
        WHERE pi.prescription_id = p_prescription_id;

        RETURN v_total;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 0;
    END calculate_prescription_total;

    -- Generate Inventory Report Procedure
    PROCEDURE generate_inventory_report(
        p_start_date IN DATE DEFAULT NULL,
        p_end_date IN DATE DEFAULT NULL,
        p_report OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_report FOR
            SELECT m.medicine_id,
                   m.name,
                   m.category,
                   m.current_stock,
                   m.reorder_level,
                   m.unit_price,
                   (m.current_stock * m.unit_price) AS stock_value,
                   m.expiry_date,
                   CASE
                       WHEN m.current_stock = 0 THEN 'OUT OF STOCK'
                       WHEN m.current_stock <= m.reorder_level THEN 'LOW STOCK'
                       ELSE 'NORMAL'
                   END AS stock_status
            FROM medicine m
            ORDER BY m.category, m.name;
    END generate_inventory_report;

    -- Get Patient History Procedure
    PROCEDURE get_patient_history(
        p_patient_id IN NUMBER,
        p_history OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_history FOR
            SELECT p.prescription_id,
                   p.issue_date,
                   p.status,
                   p.diagnosis,
                   d.name AS doctor_name,
                   pharmacy_pkg.calculate_prescription_total(p.prescription_id) AS total_amount
            FROM prescription p
            JOIN doctor d ON p.doctor_id = d.doctor_id
            WHERE p.patient_id = p_patient_id
            ORDER BY p.issue_date DESC;
    END get_patient_history;

    -- Add New Prescription Procedure
    PROCEDURE add_prescription(
        p_doctor_id IN NUMBER,
        p_patient_id IN NUMBER,
        p_diagnosis IN VARCHAR2,
        p_notes IN VARCHAR2 DEFAULT NULL,
        p_prescription_id OUT NUMBER
    ) IS
    BEGIN
        SELECT seq_prescription_id.NEXTVAL INTO p_prescription_id FROM dual;

        INSERT INTO prescription (
            prescription_id, doctor_id, patient_id, issue_date,
            status, diagnosis, notes
        ) VALUES (
            p_prescription_id, p_doctor_id, p_patient_id, SYSDATE,
            'NEW', p_diagnosis, p_notes
        );

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END add_prescription;

    -- Add Prescription Item Procedure
    PROCEDURE add_prescription_item(
        p_prescription_id IN NUMBER,
        p_medicine_id IN NUMBER,
        p_dosage IN VARCHAR2,
        p_quantity IN NUMBER,
        p_instructions IN VARCHAR2 DEFAULT NULL
    ) IS
        v_stock NUMBER;
    BEGIN
        -- Check stock availability
        SELECT current_stock INTO v_stock
        FROM medicine
        WHERE medicine_id = p_medicine_id;

        IF v_stock < p_quantity THEN
            RAISE_APPLICATION_ERROR(-20001,
                'Insufficient stock. Available: ' || v_stock);
        END IF;

        INSERT INTO prescription_items (
            item_id, prescription_id, medicine_id,
            dosage, quantity, instructions
        ) VALUES (
            seq_item_id.NEXTVAL, p_prescription_id, p_medicine_id,
            p_dosage, p_quantity, p_instructions
        );

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END add_prescription_item;

    -- Update Stock Procedure
    PROCEDURE update_stock(
        p_medicine_id IN NUMBER,
        p_quantity IN NUMBER,
        p_transaction_type IN VARCHAR2,
        p_notes IN VARCHAR2 DEFAULT NULL
    ) IS
        v_current_stock NUMBER;
    BEGIN
        SELECT current_stock INTO v_current_stock
        FROM medicine
        WHERE medicine_id = p_medicine_id
        FOR UPDATE;

        CASE p_transaction_type
            WHEN 'ADD' THEN
                UPDATE medicine
                SET current_stock = current_stock + p_quantity
                WHERE medicine_id = p_medicine_id;

            WHEN 'DEDUCT' THEN
                IF v_current_stock < p_quantity THEN
                    RAISE_APPLICATION_ERROR(-20002,
                        'Cannot deduct more than available stock');
                END IF;
                UPDATE medicine
                SET current_stock = current_stock - p_quantity
                WHERE medicine_id = p_medicine_id;

            WHEN 'ADJUST' THEN
                UPDATE medicine
                SET current_stock = p_quantity
                WHERE medicine_id = p_medicine_id;

            ELSE
                RAISE_APPLICATION_ERROR(-20003,
                    'Invalid transaction type. Use ADD, DEDUCT, or ADJUST');
        END CASE;

        -- Log the transaction
        INSERT INTO inventory_log (
            log_id, medicine_id, transaction_type,
            quantity, transaction_date, notes
        ) VALUES (
            seq_log_id.NEXTVAL, p_medicine_id, p_transaction_type,
            p_quantity, SYSDATE, p_notes
        );

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END update_stock;

    -- Get Stock Status Function
    FUNCTION get_stock_status(
        p_medicine_id IN NUMBER
    ) RETURN VARCHAR2 IS
        v_stock NUMBER;
        v_reorder NUMBER;
    BEGIN
        SELECT current_stock, reorder_level
        INTO v_stock, v_reorder
        FROM medicine
        WHERE medicine_id = p_medicine_id;

        IF v_stock = 0 THEN
            RETURN 'OUT OF STOCK';
        ELSIF v_stock <= v_reorder THEN
            RETURN 'LOW STOCK';
        ELSE
            RETURN 'NORMAL';
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'MEDICINE NOT FOUND';
    END get_stock_status;

    -- Get Top Medicines by Revenue using WINDOW FUNCTIONS
    FUNCTION get_top_medicines_by_revenue(
        p_limit IN NUMBER DEFAULT 10
    ) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT * FROM (
                SELECT
                    m.medicine_id,
                    m.name,
                    m.category,
                    SUM(m.unit_price * pi.quantity) AS total_revenue,
                    COUNT(pi.item_id) AS prescription_count,
                    RANK() OVER (
                        ORDER BY SUM(m.unit_price * pi.quantity) DESC
                    ) AS revenue_rank,
                    DENSE_RANK() OVER (
                        PARTITION BY m.category
                        ORDER BY SUM(m.unit_price * pi.quantity) DESC
                    ) AS category_rank,
                    ROUND(
                        RATIO_TO_REPORT(SUM(m.unit_price * pi.quantity)) OVER () * 100,
                        2
                    ) AS pct_of_total_revenue
                FROM medicine m
                JOIN prescription_items pi ON m.medicine_id = pi.medicine_id
                GROUP BY m.medicine_id, m.name, m.category
                ORDER BY total_revenue DESC
            )
            WHERE ROWNUM <= p_limit;

        RETURN v_cursor;
    END get_top_medicines_by_revenue;

    -- Get Doctor Performance Ranking using WINDOW FUNCTIONS
    PROCEDURE get_doctor_performance_ranking(
        p_result OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN p_result FOR
            SELECT
                d.doctor_id,
                d.name,
                d.specialization,
                COUNT(p.prescription_id) AS prescription_count,
                COUNT(DISTINCT p.patient_id) AS unique_patients,
                RANK() OVER (
                    ORDER BY COUNT(p.prescription_id) DESC
                ) AS overall_rank,
                DENSE_RANK() OVER (
                    PARTITION BY d.specialization
                    ORDER BY COUNT(p.prescription_id) DESC
                ) AS specialty_rank,
                ROUND(
                    AVG(COUNT(p.prescription_id)) OVER (
                        PARTITION BY d.specialization
                    ),
                    2
                ) AS specialty_avg,
                PERCENT_RANK() OVER (
                    ORDER BY COUNT(p.prescription_id)
                ) AS percentile_rank
            FROM doctor d
            LEFT JOIN prescription p ON d.doctor_id = p.doctor_id
            GROUP BY d.doctor_id, d.name, d.specialization
            ORDER BY prescription_count DESC;
    END get_doctor_performance_ranking;

END pharmacy_pkg;
/

-- ============================================================================
-- STANDALONE PROCEDURES
-- ============================================================================

-- Procedure to process payment
CREATE OR REPLACE PROCEDURE process_payment(
    p_prescription_id IN NUMBER,
    p_payment_method IN VARCHAR2,
    p_result OUT VARCHAR2
) IS
    v_total NUMBER;
    v_payment_id NUMBER;
    v_existing_payment NUMBER;
BEGIN
    -- Check if payment already exists
    SELECT COUNT(*) INTO v_existing_payment
    FROM payment
    WHERE prescription_id = p_prescription_id AND status = 'COMPLETED';

    IF v_existing_payment > 0 THEN
        p_result := 'ERROR: Payment already completed for this prescription';
        RETURN;
    END IF;

    -- Calculate total
    v_total := pharmacy_pkg.calculate_prescription_total(p_prescription_id);

    IF v_total = 0 THEN
        p_result := 'ERROR: No items found in prescription';
        RETURN;
    END IF;

    -- Create or update payment
    SELECT seq_payment_id.NEXTVAL INTO v_payment_id FROM dual;

    INSERT INTO payment (
        payment_id, prescription_id, amount,
        payment_date, payment_method, status
    ) VALUES (
        v_payment_id, p_prescription_id, v_total,
        SYSDATE, p_payment_method, 'COMPLETED'
    );

    COMMIT;
    p_result := 'SUCCESS: Payment of ' || v_total || ' RWF processed';

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        p_result := 'ERROR: ' || SQLERRM;
END process_payment;
/

-- ============================================================================
-- End of Script
-- ============================================================================
