-- Streak analysis
-- Calculates consecutive active study days from daily activity.

WITH active_days AS (
  SELECT
    student_id,
    activity_date::date AS activity_date
  FROM synthetic_student_activity_daily
  WHERE active_seconds > 0
),
numbered AS (
  SELECT
    student_id,
    activity_date,
    activity_date - (ROW_NUMBER() OVER (PARTITION BY student_id ORDER BY activity_date)::int) AS streak_group
  FROM active_days
),
streaks AS (
  SELECT
    student_id,
    MIN(activity_date) AS streak_start,
    MAX(activity_date) AS streak_end,
    COUNT(*) AS streak_days
  FROM numbered
  GROUP BY student_id, streak_group
)
SELECT
  student_id,
  MAX(streak_days) AS longest_streak_days,
  COUNT(*) AS total_streak_periods
FROM streaks
GROUP BY student_id
ORDER BY longest_streak_days DESC, student_id;
