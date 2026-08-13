# Portfolio Gaps And Recommended Next Steps

The current analytics portfolio is honest about what exists and what still needs to be built for a production-grade analytics workflow.

## Gaps

- No production data warehouse or analytics mart is included.
- No existing Power BI or Tableau dashboard files were found.
- No original standalone SQL files existed before this portfolio layer.
- The sample dataset is synthetic and should not be used as proof of real Learnofy business performance.
- Real event instrumentation would need clearer event naming, event properties, session IDs, and device/source metadata.
- Retention analysis is demonstrated on synthetic data only.
- Cafe promotion performance is based on sample views, claims, and redemptions, not real cafe revenue.

## Recommended Real Analytics Additions

- Add production event tracking for page views, feature actions, uploads, promotion views, claims, and redemptions.
- Create a clean warehouse model with fact tables for activity, sessions, feature events, points, and promotion interactions.
- Build real cohort retention by signup week and activation event.
- Segment students by engagement, subscription status, major, and study behavior.
- Add KPI dashboards in Power BI, Tableau, Metabase, or Looker Studio.
- Add export scripts for BI-ready CSVs or database views.
- Validate cafe promotion metrics with real redemption or transaction data.
