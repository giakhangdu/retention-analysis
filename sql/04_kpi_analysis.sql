USE MavenFlix;
GO

-- ==========================================
-- KPI 1: Monthly New Subscriptions
-- ==========================================

-- Business Question:
-- How has subscription acquisition changed
-- over time?

SELECT
    YEAR(created_date) AS subscription_year,
    MONTH(created_date) AS subscription_month,
    COUNT(*) AS new_subscriptions  
FROM dbo.subscriptions
WHERE created_date >= '2022-09-01'
  AND created_date < '2023-09-01'
GROUP BY
    YEAR(created_date),
    MONTH(created_date)
ORDER BY
    subscription_year,
    subscription_month;

-- Key Findings:
-- 1. Monthly new subscriptions fluctuated throughout
--    the reporting period, increasing from 217 in
--    September 2022 to 268 in August 2023.
--
-- 2. November 2022 recorded the lowest number of
--    new subscriptions (189), while July 2023
--    recorded the highest (306).
--
-- 3. Subscription acquisition increased between
--    the first and last reporting months, although
--    growth was not consistent month over month.
--    The dataset does not establish the reasons
--    behind these changes.

-- ==========================================
-- KPI 2: Monthly Cancellations
-- ==========================================

-- Business Question:
-- How many subscriptions were canceled each month,
-- and how did cancellation volumes change over time?

SELECT
    YEAR(canceled_date) AS cancellation_year,
    MONTH(canceled_date) AS cancellation_month,
    COUNT(*) AS cancellations
FROM dbo.subscriptions
WHERE canceled_date IS NOT NULL
  AND canceled_date >= '2022-09-01'
  AND canceled_date < '2023-09-01'
GROUP BY
    YEAR(canceled_date),
    MONTH(canceled_date)
ORDER BY
    cancellation_year,
    cancellation_month;

-- Key Findings:
-- 1. Monthly subscription cancellations generally
--    increased from 33 in September 2022 to 219
--    in August 2023, with fluctuations throughout
--    the reporting period.
--
-- 2. September 2022 recorded the lowest number
--    of cancellations (33), while June 2023
--    recorded the highest (225).
--
-- 3. The increase in cancellation volume may
--    reflect a growing subscription base rather
--    than worsening retention performance.
--    Churn rate analysis is required to assess
--    cancellations relative to the subscription base.

-- ==========================================
-- KPI 3: Monthly Subscription Churn Rate
-- ==========================================

-- Business Question:
-- What is the monthly subscription churn rate,
-- and how has it changed over time?

WITH reporting_months AS (
    SELECT DISTINCT
        DATEFROMPARTS(
            YEAR(created_date),
            MONTH(created_date),
            1
        ) AS month_start
    FROM dbo.subscriptions
    WHERE created_date >= '2022-10-01'
      AND created_date < '2023-09-01'
),
monthly_churn AS (
    SELECT
        rm.month_start,
        COUNT(s.customer_id) AS opening_subscriptions,
        SUM(
            CASE
                WHEN s.canceled_date >= rm.month_start
                 AND s.canceled_date < DATEADD(MONTH, 1, rm.month_start)
                THEN 1
                ELSE 0
            END
        ) AS canceled_subscriptions
    FROM reporting_months rm
    LEFT JOIN dbo.subscriptions s
        ON s.created_date < rm.month_start
       AND (s.canceled_date IS NULL OR s.canceled_date >= rm.month_start)
    GROUP BY rm.month_start
)

SELECT
    month_start,
    opening_subscriptions,
    canceled_subscriptions,
    100.0 * canceled_subscriptions / NULLIF(opening_subscriptions, 0) AS churn_rate
FROM monthly_churn
ORDER BY month_start;

-- Key Findings:
-- 1. Monthly subscription churn declined from 30.98%
--    in October 2022 to 18.03% in August 2023,
--    a reduction of 12.95 percentage points.
--
-- 2. October 2022 recorded the highest churn rate
--    (30.98%), while July 2023 recorded the lowest
--    (17.90%). Churn fluctuated during the period.
--
-- 3. The opening subscription base increased from
--    184 to 1,004 subscriptions. Despite substantial
--    cancellation volumes, the proportion of opening
--    subscriptions canceled generally decreased.
--    Further analysis is needed to explain the trend.

-- ==========================================
-- KPI 4: Monthly Paid Subscription Value
-- ==========================================

SELECT
    YEAR(created_date) AS subscription_year,
    MONTH(created_date) AS subscription_month,
    COUNT(*) AS paid_new_subscriptions,
    SUM(subscription_cost) AS total_paid_subscription_value
FROM dbo.subscriptions
WHERE created_date >= '2022-09-01'
  AND created_date < '2023-09-01'
  AND was_subscription_paid = 'Yes'
GROUP BY
    YEAR(created_date),
    MONTH(created_date)
ORDER BY
    subscription_year,
    subscription_month;

-- Key Findings:
-- 1. Monthly paid new subscription value increased
--    from 8,190 in September 2022 to 10,062 in
--    August 2023, with fluctuations throughout
--    the reporting period.
--
-- 2. November 2022 recorded the lowest value
--    (6,903), while July 2023 recorded the highest
--    (11,427).
--
-- 3. Changes in paid new subscription value were
--    driven by changes in the number of new
--    subscriptions marked as paid, as the listed
--    subscription price remained constant at 39.
--    This metric does not represent verified revenue.
