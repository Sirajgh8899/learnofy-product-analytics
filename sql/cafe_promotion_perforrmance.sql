-- Cafe promotion performance
-- Measures views, claims, redemptions, and conversion rates by cafe.

SELECT
  p.cafe_id,
  p.cafe_name,
  COUNT(DISTINCT p.promotion_id) AS promotions_created,
  COUNT(sp.student_promotion_id) AS promotion_views,
  COUNT(*) FILTER (WHERE sp.claimed_at IS NOT NULL) AS promotion_claims,
  COUNT(*) FILTER (WHERE sp.redeemed_at IS NOT NULL) AS promotion_redemptions,
  ROUND(COUNT(*) FILTER (WHERE sp.claimed_at IS NOT NULL) * 100.0 / NULLIF(COUNT(sp.student_promotion_id), 0), 2) AS claim_rate_pct,
  ROUND(COUNT(*) FILTER (WHERE sp.redeemed_at IS NOT NULL) * 100.0 / NULLIF(COUNT(*) FILTER (WHERE sp.claimed_at IS NOT NULL), 0), 2) AS redemption_rate_pct
FROM synthetic_promotions p
LEFT JOIN synthetic_student_promotions sp ON p.promotion_id = sp.promotion_id
GROUP BY p.cafe_id, p.cafe_name
ORDER BY claim_rate_pct DESC NULLS LAST;
