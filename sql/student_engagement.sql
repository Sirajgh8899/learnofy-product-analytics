-- Student engagement
-- Combines activity, study time, points, and promotion actions.

WITH activity AS (
  SELECT
    student_id,
    COUNT(*) FILTER (WHERE active_seconds > 0) AS active_days,
    SUM(active_seconds) AS total_active_seconds,
    AVG(active_seconds) AS avg_daily_active_seconds
  FROM synthetic_student_activity_daily
  GROUP BY student_id
),
points AS (
  SELECT
    student_id,
    SUM(points) AS total_points,
    COUNT(*) FILTER (WHERE action_type = 'note_upload') AS note_upload_rewards
  FROM synthetic_points_transactions
  GROUP BY student_id
),
promotions AS (
  SELECT
    student_id,
    COUNT(*) AS promotions_viewed,
    COUNT(*) FILTER (WHERE claimed_at IS NOT NULL) AS promotions_claimed
  FROM synthetic_student_promotions
  GROUP BY student_id
)
SELECT
  s.student_id,
  s.segment_label,
  s.subscription_status,
  COALESCE(a.active_days, 0) AS active_days,
  ROUND(COALESCE(a.total_active_seconds, 0) / 3600.0, 2) AS total_study_hours,
  ROUND(COALESCE(a.avg_daily_active_seconds, 0) / 60.0, 2) AS avg_daily_study_minutes,
  COALESCE(p.total_points, 0) AS total_points,
  COALESCE(p.note_upload_rewards, 0) AS note_upload_rewards,
  COALESCE(pr.promotions_viewed, 0) AS promotions_viewed,
  COALESCE(pr.promotions_claimed, 0) AS promotions_claimed
FROM synthetic_students s
LEFT JOIN activity a ON s.student_id = a.student_id
LEFT JOIN points p ON s.student_id = p.student_id
LEFT JOIN promotions pr ON s.student_id = pr.student_id
ORDER BY total_points DESC, total_study_hours DESC;
