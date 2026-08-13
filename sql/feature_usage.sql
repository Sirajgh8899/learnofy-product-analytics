-- Feature usage
-- Uses synthetic feature events created from existing app concepts.

SELECT
  feature_name,
  event_type,
  COUNT(*) AS event_count,
  COUNT(DISTINCT student_id) AS unique_users,
  MIN(event_date) AS first_event_date,
  MAX(event_date) AS last_event_date
FROM synthetic_feature_usage
GROUP BY feature_name, event_type
ORDER BY event_count DESC;
