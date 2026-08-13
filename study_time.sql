-- Study time analysis
-- Uses the sample daily activity table inspired by StudentActivityDaily.

SELECT
  student_id,
  COUNT(*) FILTER (WHERE active_seconds > 0) AS active_days,
  ROUND(SUM(active_seconds) / 3600.0, 2) AS total_study_hours,
  ROUND(AVG(NULLIF(active_seconds, 0)) / 60.0, 2) AS avg_minutes_on_active_day,
  MAX(active_seconds) / 60 AS max_minutes_in_day
FROM synthetic_student_activity_daily
GROUP BY student_id
ORDER BY total_study_hours DESC;
