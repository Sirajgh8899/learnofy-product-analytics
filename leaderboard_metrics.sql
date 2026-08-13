-- Leaderboard metrics
-- Recreates portfolio leaderboard calculations from points transactions.

WITH weekly_points AS (
  SELECT
    student_id,
    DATE_TRUNC('week', timestamp)::date AS week_start,
    SUM(points) AS points_earned
  FROM synthetic_points_transactions
  GROUP BY student_id, DATE_TRUNC('week', timestamp)::date
),
student_totals AS (
  SELECT
    s.student_id,
    s.segment_label,
    COALESCE(SUM(pt.points), 0) AS lifetime_points
  FROM synthetic_students s
  LEFT JOIN synthetic_points_transactions pt ON s.student_id = pt.student_id
  GROUP BY s.student_id, s.segment_label
)
SELECT
  student_id,
  segment_label,
  lifetime_points,
  RANK() OVER (ORDER BY lifetime_points DESC) AS lifetime_rank
FROM student_totals
ORDER BY lifetime_rank, student_id;
