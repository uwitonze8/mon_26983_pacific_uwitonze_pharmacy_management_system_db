-- ============================================================================
-- WEEKEND TEST - Screenshot 30 (ALLOWED)
-- Run this on SATURDAY or SUNDAY
-- Expected: INSERT should SUCCEED
-- ============================================================================

SET SERVEROUTPUT ON;

PROMPT ========================================
PROMPT TEST 1: Check Current Day
PROMPT ========================================

SELECT TO_CHAR(SYSDATE, 'DAY, DD-MON-YYYY') AS current_date,
       TO_CHAR(SYSDATE, 'DY') AS day_abbreviation,
       CASE WHEN TO_CHAR(SYSDATE, 'DY') IN ('SAT', 'SUN')
            THEN '✅ WEEKEND - Operations ALLOWED'
            ELSE '❌ WEEKDAY - Operations BLOCKED'
       END AS expected_behavior
FROM dual;

PROMPT
PROMPT ========================================
PROMPT TEST 2: Attempt INSERT on Weekend
PROMPT Expected: SUCCESS (ALLOWED)
PROMPT ========================================

BEGIN
    INSERT INTO prescription (
        prescription_id, doctor_id, patient_id,
        issue_date, status, diagnosis
    ) VALUES (
        seq_prescription_id.NEXTVAL, 1001, 10001,
        SYSDATE, 'NEW', 'Weekend test - Should be ALLOWED'
    );
    DBMS_OUTPUT.PUT_LINE('✅ SUCCESS: Insert ALLOWED on weekend');
    DBMS_OUTPUT.PUT_LINE('   Prescription created successfully!');
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('❌ UNEXPECTED: Insert was DENIED on weekend');
        DBMS_OUTPUT.PUT_LINE('   Error: ' || SQLERRM);
        ROLLBACK;
END;
/

PROMPT
PROMPT ========================================
PROMPT TEST 3: View Audit Log (ALLOWED entries)
PROMPT ========================================

SELECT user_id,
       TO_CHAR(action_date, 'YYYY-MM-DD HH24:MI:SS') AS timestamp,
       operation,
       table_name,
       status,
       SUBSTR(new_value, 1, 60) AS message
FROM audit_log
WHERE table_name = 'PRESCRIPTION'
  AND status = 'ALLOWED'
  AND action_date > SYSDATE - 1/24  -- Last hour
ORDER BY action_date DESC
FETCH FIRST 5 ROWS ONLY;

PROMPT
PROMPT ========================================
PROMPT ✅ SCREENSHOT 30 COMPLETE
PROMPT This proves operations are ALLOWED on weekends
PROMPT ========================================
