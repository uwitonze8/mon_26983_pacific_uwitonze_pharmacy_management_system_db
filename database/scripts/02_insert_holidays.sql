SELECT holiday_name, TO_CHAR(holiday_date, 'YYYY-MM-DD DAY') AS holiday_date, description
FROM holiday
ORDER BY holiday_date;

SELECT COUNT(*) AS total_holidays FROM holiday;