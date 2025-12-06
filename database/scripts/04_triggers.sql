-- ============================================================================
-- PHARMACY MANAGEMENT SYSTEM - TRIGGERS
-- Author: Uwitonze Pacific (ID: 26983)
-- Database: mon_26983_pacific_pharmacy_db
-- ============================================================================

-- ============================================================================
-- DISPENSING TRIGGER
-- Automatically updates stock when medicines are dispensed
-- ============================================================================

CREATE OR REPLACE TRIGGER trg_dispense_medicine
AFTER INSERT ON dispensed_medicines
FOR EACH ROW
DECLARE
    v_prescription_status VARCHAR2(20);
    v_items NUMBER;
    v_current_stock NUMBER;
BEGIN
    -- Check prescription status
    SELECT status INTO v_prescription_status
    FROM prescription
    WHERE prescription_id = :NEW.prescription_id;

    -- Check if prescription has items
    SELECT COUNT(*) INTO v_items
    FROM prescription_items
    WHERE prescription_id = :NEW.prescription_id;

    -- Validation checks
    IF v_prescription_status != 'VALIDATED' THEN
        RAISE_APPLICATION_ERROR(-20001,
            'Cannot dispense - prescription not validated');
    ELSIF v_items = 0 THEN
        RAISE_APPLICATION_ERROR(-20002,
            'Cannot dispense - no items in prescription');
    END IF;

    -- Update prescription status
    UPDATE prescription
    SET status = 'DISPENSED'
    WHERE prescription_id = :NEW.prescription_id;

    -- Process each medicine item and update stock
    FOR item IN (
        SELECT medicine_id, quantity
        FROM prescription_items
        WHERE prescription_id = :NEW.prescription_id
    ) LOOP
        SELECT current_stock INTO v_current_stock
        FROM medicine
        WHERE medicine_id = item.medicine_id;

        IF v_current_stock < item.quantity THEN
            RAISE_APPLICATION_ERROR(-20003,
                'Insufficient stock for medicine ID ' || item.medicine_id);
        END IF;

        -- Deduct stock
        UPDATE medicine
        SET current_stock = current_stock - item.quantity
        WHERE medicine_id = item.medicine_id;

        -- Log the transaction
        INSERT INTO inventory_log (
            log_id, medicine_id, transaction_type,
            quantity, transaction_date, notes
        ) VALUES (
            seq_log_id.NEXTVAL, item.medicine_id, 'DEDUCT',
            item.quantity, SYSDATE,
            'Dispensed for prescription #' || :NEW.prescription_id
        );
    END LOOP;
END;
/

-- ============================================================================
-- LOW STOCK ALERT TRIGGER
-- Logs an alert when stock falls below reorder level
-- ============================================================================

CREATE OR REPLACE TRIGGER trg_low_stock_alert
AFTER UPDATE OF current_stock ON medicine
FOR EACH ROW
WHEN (NEW.current_stock <= NEW.reorder_level AND OLD.current_stock > OLD.reorder_level)
BEGIN
    INSERT INTO inventory_log (
        log_id, medicine_id, transaction_type,
        quantity, transaction_date, notes
    ) VALUES (
        seq_log_id.NEXTVAL, :NEW.medicine_id, 'ADJUST',
        :NEW.current_stock, SYSDATE,
        'LOW STOCK ALERT: Stock level (' || :NEW.current_stock ||
        ') is at or below reorder level (' || :NEW.reorder_level || ')'
    );
END;
/

-- ============================================================================
-- AUDIT TRIGGER FOR PRESCRIPTION
-- Logs all changes to prescription table
-- ============================================================================

CREATE OR REPLACE TRIGGER trg_audit_prescription
AFTER INSERT OR UPDATE OR DELETE ON prescription
FOR EACH ROW
DECLARE
    v_operation VARCHAR2(10);
    v_old_value CLOB;
    v_new_value CLOB;
BEGIN
    IF INSERTING THEN
        v_operation := 'INSERT';
        v_new_value := 'ID:' || :NEW.prescription_id ||
                       ',Doctor:' || :NEW.doctor_id ||
                       ',Patient:' || :NEW.patient_id ||
                       ',Status:' || :NEW.status;
    ELSIF UPDATING THEN
        v_operation := 'UPDATE';
        v_old_value := 'ID:' || :OLD.prescription_id ||
                       ',Status:' || :OLD.status;
        v_new_value := 'ID:' || :NEW.prescription_id ||
                       ',Status:' || :NEW.status;
    ELSIF DELETING THEN
        v_operation := 'DELETE';
        v_old_value := 'ID:' || :OLD.prescription_id ||
                       ',Doctor:' || :OLD.doctor_id ||
                       ',Patient:' || :OLD.patient_id;
    END IF;

    INSERT INTO audit_log (
        audit_id, user_id, action_date, operation,
        table_name, record_id, old_value, new_value, status
    ) VALUES (
        seq_audit_id.NEXTVAL, USER, SYSTIMESTAMP, v_operation,
        'PRESCRIPTION', NVL(:NEW.prescription_id, :OLD.prescription_id),
        v_old_value, v_new_value, 'ALLOWED'
    );
END;
/

-- ============================================================================
-- AUDIT TRIGGER FOR PAYMENT
-- Logs all changes to payment table
-- ============================================================================

CREATE OR REPLACE TRIGGER trg_audit_payment
AFTER INSERT OR UPDATE OR DELETE ON payment
FOR EACH ROW
DECLARE
    v_operation VARCHAR2(10);
    v_old_value CLOB;
    v_new_value CLOB;
BEGIN
    IF INSERTING THEN
        v_operation := 'INSERT';
        v_new_value := 'ID:' || :NEW.payment_id ||
                       ',Prescription:' || :NEW.prescription_id ||
                       ',Amount:' || :NEW.amount ||
                       ',Status:' || :NEW.status;
    ELSIF UPDATING THEN
        v_operation := 'UPDATE';
        v_old_value := 'ID:' || :OLD.payment_id ||
                       ',Status:' || :OLD.status ||
                       ',Amount:' || :OLD.amount;
        v_new_value := 'ID:' || :NEW.payment_id ||
                       ',Status:' || :NEW.status ||
                       ',Amount:' || :NEW.amount;
    ELSIF DELETING THEN
        v_operation := 'DELETE';
        v_old_value := 'ID:' || :OLD.payment_id ||
                       ',Amount:' || :OLD.amount;
    END IF;

    INSERT INTO audit_log (
        audit_id, user_id, action_date, operation,
        table_name, record_id, old_value, new_value, status
    ) VALUES (
        seq_audit_id.NEXTVAL, USER, SYSTIMESTAMP, v_operation,
        'PAYMENT', NVL(:NEW.payment_id, :OLD.payment_id),
        v_old_value, v_new_value, 'ALLOWED'
    );
END;
/

-- ============================================================================
-- AUDIT TRIGGER FOR MEDICINE
-- Logs all changes to medicine table
-- ============================================================================

CREATE OR REPLACE TRIGGER trg_audit_medicine
AFTER INSERT OR UPDATE OR DELETE ON medicine
FOR EACH ROW
DECLARE
    v_operation VARCHAR2(10);
    v_old_value CLOB;
    v_new_value CLOB;
BEGIN
    IF INSERTING THEN
        v_operation := 'INSERT';
        v_new_value := 'ID:' || :NEW.medicine_id ||
                       ',Name:' || :NEW.name ||
                       ',Stock:' || :NEW.current_stock;
    ELSIF UPDATING THEN
        v_operation := 'UPDATE';
        v_old_value := 'ID:' || :OLD.medicine_id ||
                       ',Stock:' || :OLD.current_stock ||
                       ',Price:' || :OLD.unit_price;
        v_new_value := 'ID:' || :NEW.medicine_id ||
                       ',Stock:' || :NEW.current_stock ||
                       ',Price:' || :NEW.unit_price;
    ELSIF DELETING THEN
        v_operation := 'DELETE';
        v_old_value := 'ID:' || :OLD.medicine_id ||
                       ',Name:' || :OLD.name;
    END IF;

    INSERT INTO audit_log (
        audit_id, user_id, action_date, operation,
        table_name, record_id, old_value, new_value, status
    ) VALUES (
        seq_audit_id.NEXTVAL, USER, SYSTIMESTAMP, v_operation,
        'MEDICINE', NVL(:NEW.medicine_id, :OLD.medicine_id),
        v_old_value, v_new_value, 'ALLOWED'
    );
END;
/

-- ============================================================================
-- RESTRICTION CHECK FUNCTION
-- Checks if current date is a weekday (Mon-Fri) or public holiday
-- Returns: TRUE if operation should be BLOCKED (weekday or holiday)
--          FALSE if operation is ALLOWED (weekend)
-- ============================================================================

CREATE OR REPLACE FUNCTION is_restricted_time RETURN BOOLEAN IS
    v_day VARCHAR2(10);
    v_is_holiday NUMBER;
BEGIN
    -- Get current day of week
    v_day := TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH');

    -- Check if today is a public holiday (within upcoming month)
    SELECT COUNT(*)
    INTO v_is_holiday
    FROM holiday
    WHERE TRUNC(holiday_date) = TRUNC(SYSDATE)
    AND holiday_date BETWEEN SYSDATE AND ADD_MONTHS(SYSDATE, 1);

    -- Block if WEEKDAY (Mon-Fri) OR Holiday
    IF v_day IN ('MON', 'TUE', 'WED', 'THU', 'FRI') OR v_is_holiday > 0 THEN
        RETURN TRUE;  -- BLOCKED
    ELSE
        RETURN FALSE; -- ALLOWED (Weekend)
    END IF;
END;
/

-- ============================================================================
-- AUDIT LOGGING FUNCTION
-- Logs restriction attempts to audit_log table
-- ============================================================================

CREATE OR REPLACE FUNCTION log_restriction_attempt(
    p_operation IN VARCHAR2,
    p_table_name IN VARCHAR2,
    p_record_id IN NUMBER,
    p_status IN VARCHAR2,
    p_message IN VARCHAR2
) RETURN NUMBER IS
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    INSERT INTO audit_log (
        audit_id, user_id, action_date, operation,
        table_name, record_id, old_value, new_value, status
    ) VALUES (
        seq_audit_id.NEXTVAL, USER, SYSTIMESTAMP, p_operation,
        p_table_name, p_record_id, NULL, p_message, p_status
    );
    COMMIT;
    RETURN 1;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RETURN 0;
END;
/

-- ============================================================================
-- WEEKDAY/HOLIDAY RESTRICTION TRIGGER - PRESCRIPTION
-- CRITICAL REQUIREMENT: Blocks INSERT/UPDATE/DELETE on weekdays and holidays
-- Per Assignment Phase VII requirements
-- ============================================================================

CREATE OR REPLACE TRIGGER trg_restrict_prescription
BEFORE INSERT OR UPDATE OR DELETE ON prescription
FOR EACH ROW
DECLARE
    v_operation VARCHAR2(10);
    v_record_id NUMBER;
    v_dummy NUMBER;
    v_day VARCHAR2(10);
    v_is_holiday NUMBER;
BEGIN
    -- Determine operation type
    IF INSERTING THEN
        v_operation := 'INSERT';
        v_record_id := :NEW.prescription_id;
    ELSIF UPDATING THEN
        v_operation := 'UPDATE';
        v_record_id := :NEW.prescription_id;
    ELSIF DELETING THEN
        v_operation := 'DELETE';
        v_record_id := :OLD.prescription_id;
    END IF;

    -- Get current day
    v_day := TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH');

    -- Check for holiday
    SELECT COUNT(*)
    INTO v_is_holiday
    FROM holiday
    WHERE TRUNC(holiday_date) = TRUNC(SYSDATE)
    AND holiday_date BETWEEN SYSDATE AND ADD_MONTHS(SYSDATE, 1);

    -- BLOCK if weekday (Mon-Fri)
    IF v_day IN ('MON', 'TUE', 'WED', 'THU', 'FRI') THEN
        -- Log the denial
        v_dummy := log_restriction_attempt(
            v_operation,
            'PRESCRIPTION',
            v_record_id,
            'DENIED',
            'Operation blocked: Weekday restriction (' || v_day || ')'
        );

        RAISE_APPLICATION_ERROR(-20010,
            'DENIED: Cannot ' || v_operation || ' prescriptions on weekdays (Mon-Fri). ' ||
            'Current day: ' || v_day || '. Operations allowed on weekends only.');
    END IF;

    -- BLOCK if public holiday
    IF v_is_holiday > 0 THEN
        -- Log the denial
        v_dummy := log_restriction_attempt(
            v_operation,
            'PRESCRIPTION',
            v_record_id,
            'DENIED',
            'Operation blocked: Public holiday'
        );

        RAISE_APPLICATION_ERROR(-20011,
            'DENIED: Cannot ' || v_operation || ' prescriptions on public holidays. ' ||
            'Operations allowed on regular weekends only.');
    END IF;

    -- If we reach here, operation is ALLOWED (weekend, non-holiday)
    v_dummy := log_restriction_attempt(
        v_operation,
        'PRESCRIPTION',
        v_record_id,
        'ALLOWED',
        'Operation permitted: Weekend (' || v_day || ')'
    );
END;
/

-- ============================================================================
-- WEEKDAY/HOLIDAY RESTRICTION TRIGGER - PAYMENT
-- Applies same restriction to payment table
-- ============================================================================

CREATE OR REPLACE TRIGGER trg_restrict_payment
BEFORE INSERT OR UPDATE OR DELETE ON payment
FOR EACH ROW
DECLARE
    v_operation VARCHAR2(10);
    v_record_id NUMBER;
    v_dummy NUMBER;
    v_day VARCHAR2(10);
    v_is_holiday NUMBER;
BEGIN
    -- Determine operation
    IF INSERTING THEN
        v_operation := 'INSERT';
        v_record_id := :NEW.payment_id;
    ELSIF UPDATING THEN
        v_operation := 'UPDATE';
        v_record_id := :NEW.payment_id;
    ELSIF DELETING THEN
        v_operation := 'DELETE';
        v_record_id := :OLD.payment_id;
    END IF;

    -- Get current day
    v_day := TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH');

    -- Check for holiday
    SELECT COUNT(*)
    INTO v_is_holiday
    FROM holiday
    WHERE TRUNC(holiday_date) = TRUNC(SYSDATE);

    -- BLOCK on weekdays or holidays
    IF v_day IN ('MON', 'TUE', 'WED', 'THU', 'FRI') OR v_is_holiday > 0 THEN
        v_dummy := log_restriction_attempt(
            v_operation,
            'PAYMENT',
            v_record_id,
            'DENIED',
            'Operation blocked: Weekday/Holiday restriction'
        );

        RAISE_APPLICATION_ERROR(-20012,
            'DENIED: Cannot ' || v_operation || ' payments on weekdays or holidays.');
    END IF;
END;
/

-- ============================================================================
-- PREVENT EXPIRED MEDICINE DISPENSING
-- Blocks dispensing of expired medicines
-- ============================================================================

CREATE OR REPLACE TRIGGER trg_check_expiry
BEFORE INSERT ON prescription_items
FOR EACH ROW
DECLARE
    v_expiry_date DATE;
    v_medicine_name VARCHAR2(100);
BEGIN
    SELECT expiry_date, name
    INTO v_expiry_date, v_medicine_name
    FROM medicine
    WHERE medicine_id = :NEW.medicine_id;

    IF v_expiry_date < SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20011,
            'Cannot prescribe expired medicine: ' || v_medicine_name ||
            ' (Expired: ' || TO_CHAR(v_expiry_date, 'DD-MON-YYYY') || ')');
    END IF;
END;
/

-- ============================================================================
-- End of Script
-- ============================================================================
