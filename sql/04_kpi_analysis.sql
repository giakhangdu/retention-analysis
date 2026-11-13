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
