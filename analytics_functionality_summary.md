# Analytics Functionality Summary

This repository separates existing application analytics logic from portfolio/sample analytics work.

## Existing Production/Application Analytics Logic

These files existed in the Learnofy project before the portfolio analytics layer:

- `backend/students/models.py`: defines activity, study session, points, weekly plan, note upload, and asset access log models.
- `backend/students/gamification.py`: contains logic for points, rank progress, streaks, study-time rewards, note-upload rewards, daily challenges, weekly challenges, and activity recording.
- `backend/students/gamification_views.py`: serializes student stats, activity summaries, recent activity, leaderboards, and weekly plan progress.
- `backend/students/views.py`: includes activity heartbeat, activity summary, study-room session APIs, promotion listing and claiming, note uploads, and secure asset views.
- `backend/cafes/models.py`: defines cafes, promotions, and student-promotion status.
- `backend/cafes/views.py`: includes cafe promotion APIs, awards preview, and cafe dashboard metric calculations.
- `frontend/src/views/HomePage.vue`: student dashboard experience using activity, courses, notes, and promotions.
- `frontend/src/views/RewardsPage.vue`: student rewards dashboard using points, streaks, challenges, leaderboards, and study sessions.
- `frontend/src/views/CafeDashboard.vue`: cafe dashboard summary for promotions and engagement.
- `frontend/src/views/CafePromotionsPage.vue`: cafe promotion management UI.
- `docs/learnoFy_erd_v2.md`: ERD-style project documentation.

## Portfolio/Sample Analytics Work Added

These files were added to present the project as a data analytics portfolio:

- `data/sample/*.csv`: synthetic schema-aligned sample dataset.
- `sql/*.sql`: standalone SQL analysis for weekly active users, engagement, study time, streaks, feature usage, cafe promotion performance, claim rate, leaderboards, and retention.
- `python/notebooks/learnofy_exploratory_analysis.ipynb`: Pandas exploratory analysis notebook.
- `python/outputs/*.png`: exported chart images.
- `docs/analytics_questions.md`: business questions answered by the analysis.
- `docs/kpi_definitions.md`: KPI formulas and business meaning.
- `docs/data_dictionary.md`: field-level documentation for the synthetic dataset.
- `docs/insights.md`: sample-data conclusions only.
- `docs/portfolio_gaps.md`: honest next steps for stronger real analytics work.

## What Is Not Claimed

This repository does not claim existing Power BI or Tableau dashboards. It also does not claim production SQL pipelines. SQL and Python analytics are included as portfolio work created from the existing schema and synthetic sample data.
