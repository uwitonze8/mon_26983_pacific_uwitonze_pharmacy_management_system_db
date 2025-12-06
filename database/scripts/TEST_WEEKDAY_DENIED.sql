-- ============================================================================
-- WEEKDAY TEST - Screenshot 29 (DENIED)
-- Run this on MONDAY, TUESDAY, WEDNESDAY, THURSDAY, or FRIDAY
-- Expected: INSERT should FAIL with error
-- ============================================================================

SET SERVEROUTPUT ON;

PROMPT ========================================
PROMPT TEST 1: Check Current Day
PROMPT ========================================

SELECT TO_CHAR(SYSDATE, 'DAY, DD-MON-YYYY') AS current_date,
       TO_CHAR(SYSDATE, 'DY') AS day_abbreviation,
       CASE WHEN TO_CHAR(SYSDATE, 'DY') IN ('MON', 'TUE', 'WED', 'THU', 'FRI')
            THEN '❌ WEEKDAY - Operations BLOCKED'
            ELSE '✅ WEEKEND - Operations ALLOWED'
       END AS expected_behavior
FROM dual;

PROMPT
PROMPT ========================================
PROMPT TEST 2: Attempt INSERT on Weekday
PROMPT Expected: DENIED (Error -20010)
PROMPT ========================================

BEGIN
    INSERT INTO prescription (
        prescription_id, doctor_id, patient_id,
        issue_date, status, diagnosis
    ) VALUES (
        seq_prescription_id.NEXTVAL, 1001, 10001,
        SYSDATE, 'NEW', 'Weekday test - Should be DENIED'
    );
    DBMS_OUTPUT.PUT_LINE('❌ UNEXPECTED: Insert was ALLOWED on weekday');
    DBMS_OUTPUT.PUT_LINE('   ERROR: Trigger did not block the operation!');
    ROLLBACK;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('✅ CORRECT: Insert was DENIED on weekday');
        DBMS_OUTPUT.PUT_LINE('   Error Code: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('   Error Message: ' || SQLERRM);
        ROLLBACK;
END;
/

PROMPT
PROMPT ========================================
PROMPT TEST 3: View Audit Log (DENIED entries)
PROMPT ========================================

SELECT user_id,
       TO_CHAR(action_date, 'YYYY-MM-DD HH24:MI:SS') AS timestamp,
       operation,
       table_name,
       status,
       SUBSTR(new_value, 1, 80) AS message
FROM audit_log
WHERE table_name = 'PRESCRIPTION'
  AND status = 'DENIED'
  AND action_date > SYSDATE - 1/24  -- Last hour
ORDER BY action_date DESC
FETCH FIRST 5 ROWS ONLY;

PROMPT
PROMPT ========================================
PROMPT TEST 4: Attempt UPDATE on Weekday
PROMPT Expected: DENIED (Error -20010)
PROMPT ========================================

BEGIN
    UPDATE prescription
    SET status = 'VALIDATED'
    WHERE prescription_id = 1;

    DBMS_OUTPUT.PUT_LINE('❌ UNEXPECTED: Update was ALLOWED on weekday');
    ROLLBACK;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('✅ CORRECT: Update was DENIED on weekday');
        DBMS_OUTPUT.PUT_LINE('   Error: ' || SQLERRM);
        ROLLBACK;
END;
/

PROMPT
PROMPT ========================================
PROMPT ❌ SCREENSHOT 29 COMPLETE
PROMPT This proves operations are DENIED on weekdays
PROMPT ========================================
