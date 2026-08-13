# Data Dictionary

This dictionary describes the portfolio sample dataset. The dataset is synthetic and schema-aligned with the existing Learnofy Django models.

## synthetic_students.csv

| Field | Description |
| --- | --- |
| student_id | Synthetic student identifier. |
| first_name | Synthetic first name. |
| last_name | Synthetic last name. |
| email | Synthetic email using `example.com`. |
| university | Sample university label. |
| major | Sample major label. |
| year | Student year label. |
| subscription_status | Sample student subscription status, based on the app's `basic` and `learner` statuses. |
| created_at | Synthetic signup date. |
| segment_label | Portfolio segment assigned for analysis. |
| is_synthetic | Always true in this dataset. |

## synthetic_student_activity_daily.csv

| Field | Description |
| --- | --- |
| student_id | Student identifier. |
| activity_date | Date of activity. |
| active_seconds | Study/activity time in seconds. |
| heartbeat_count | Count of sample activity heartbeats. |
| first_seen_at | First synthetic activity timestamp for the day. |
| last_seen_at | Last synthetic activity timestamp for the day. |
| is_synthetic | Always true in this dataset. |

## synthetic_study_sessions.csv

| Field | Description |
| --- | --- |
| study_session_id | Synthetic study session identifier. |
| student_id | Student identifier. |
| course_id | Synthetic course identifier. |
| session_date | Study session date. |
| start_time | Session start timestamp. |
| end_time | Session end timestamp. |
| active_seconds | Active study seconds in the session. |
| duration_minutes | Session duration in minutes. |
| status | Session status. |
| is_synthetic | Always true in this dataset. |

## synthetic_points_transactions.csv

| Field | Description |
| --- | --- |
| points_transaction_id | Synthetic transaction identifier. |
| student_id | Student identifier. |
| action_type | Points action such as `study_time` or `note_upload`. |
| points | Points awarded. |
| timestamp | Transaction timestamp. |
| reference_id | Synthetic reference to related action. |
| is_synthetic | Always true in this dataset. |

## synthetic_promotions.csv

| Field | Description |
| --- | --- |
| promotion_id | Synthetic promotion identifier. |
| cafe_id | Synthetic cafe identifier. |
| cafe_name | Cafe display name. |
| title | Promotion title. |
| discount_type | Discount type. |
| discount_value | Discount value. |
| min_spend | Minimum spend requirement. |
| start_at | Promotion start date. |
| end_at | Promotion end date. |
| is_active | Whether the promotion is active at the sample period end. |
| is_synthetic | Always true in this dataset. |

## synthetic_student_promotions.csv

| Field | Description |
| --- | --- |
| student_promotion_id | Synthetic interaction identifier. |
| student_id | Student identifier. |
| promotion_id | Promotion identifier. |
| status | Promotion status: viewed, claimed, or redeemed. |
| viewed_at | Synthetic view date. |
| claimed_at | Synthetic claim date when applicable. |
| redeemed_at | Synthetic redemption date when applicable. |
| is_synthetic | Always true in this dataset. |

## synthetic_feature_usage.csv

| Field | Description |
| --- | --- |
| event_id | Synthetic event identifier. |
| student_id | Student identifier. |
| event_date | Event date. |
| feature_name | Feature area such as dashboard, rewards, notes, study room, or promotions. |
| event_type | Event action such as page view, session started, note uploaded, or promotion claimed. |
| is_synthetic | Always true in this dataset. |
