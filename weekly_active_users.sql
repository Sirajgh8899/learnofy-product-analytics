-- Weekly active users
-- Portfolio/sample analytics query.
-- Source table: synthetic_student_activity_daily

SELECT
  DATE_TRUNC('week', activity_date)::date AS week_start,
  COUNT(DISTINCT CASE WHEN active_seconds > 0 THEN student_id END) AS weekly_active_users,
  COUNT(DISTINCT student_id) AS students_observed,
  ROUND(SUM(active_seconds) / 3600.0, 2) AS total_study_hours
FROM synthetic_student_activity_daily
GROUP BY 1
ORDER BY 1;
