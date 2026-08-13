-- Promotion claim rate
-- Calculates claim rate at promotion level.

SELECT
  p.promotion_id,
  p.cafe_name,
  p.title,
  COUNT(sp.student_promotion_id) AS viewed_count,
  COUNT(*) FILTER (WHERE sp.claimed_at IS NOT NULL) AS claimed_count,
  ROUND(COUNT(*) FILTER (WHERE sp.claimed_at IS NOT NULL) * 100.0 / NULLIF(COUNT(sp.student_promotion_id), 0), 2) AS claim_rate_pct
FROM synthetic_promotions p
LEFT JOIN synthetic_student_promotions sp ON p.promotion_id = sp.promotion_id
GROUP BY p.promotion_id, p.cafe_name, p.title
ORDER BY claim_rate_pct DESC NULLS LAST, viewed_count DESC;
