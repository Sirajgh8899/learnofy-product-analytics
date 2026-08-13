-- User retention
-- Supported in the portfolio dataset because students have created_at dates
-- and daily activity rows.

WITH cohorts AS (
  SELECT
    student_id,
    DATE_TRUNC('week', created_at)::date AS cohort_week
  FROM synthetic_students
),
activity_weeks AS (
  SELECT DISTINCT
    student_id,
    DATE_TRUNC('week', activity_date)::date AS activity_week
  FROM synthetic_student_activity_daily
  WHERE active_seconds > 0
),
retention AS (
  SELECT
    c.cohort_week,
    ((a.activity_week - c.cohort_week) / 7)::int AS week_number,
    COUNT(DISTINCT c.student_id) AS retained_users
  FROM cohorts c
  JOIN activity_weeks a ON c.student_id = a.student_id
  WHERE a.activity_week >= c.cohort_week
  GROUP BY c.cohort_week, ((a.activity_week - c.cohort_week) / 7)::int
),
cohort_sizes AS (
  SELECT
    cohort_week,
    COUNT(DISTINCT student_id) AS cohort_users
  FROM cohorts
  GROUP BY cohort_week
)
SELECT
  r.cohort_week,
  r.week_number,
  cs.cohort_users,
  r.retained_users,
  ROUND(r.retained_users * 100.0 / NULLIF(cs.cohort_users, 0), 2) AS retention_rate_pct
FROM retention r
JOIN cohort_sizes cs ON r.cohort_week = cs.cohort_week
ORDER BY r.cohort_week, r.week_number;
