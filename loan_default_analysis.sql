-- =====================================================
-- Loan Default & Credit Risk Analysis
-- Tools: MySQL / SQL Server compatible
-- NOTE: Rename columns below to match your Kaggle dataset
-- =====================================================

-- Table structure (adjust to your dataset)
CREATE TABLE loans (
    loan_id          INT PRIMARY KEY,
    age              INT,
    gender           VARCHAR(10),
    employment_type  VARCHAR(30),
    annual_income    DECIMAL(12,2),
    loan_amount      DECIMAL(12,2),
    loan_purpose     VARCHAR(30),
    credit_score     INT,
    loan_status      VARCHAR(10)      -- 'Default' or 'Paid'
);

-- 1. Data check: total rows and missing values
SELECT COUNT(*) AS total_loans,
       SUM(CASE WHEN annual_income IS NULL THEN 1 ELSE 0 END) AS missing_income
FROM loans;

-- 2. Overall default rate
SELECT COUNT(*) AS total_loans,
       SUM(CASE WHEN loan_status = 'Default' THEN 1 ELSE 0 END) AS defaults,
       ROUND(100.0 * SUM(CASE WHEN loan_status = 'Default' THEN 1 ELSE 0 END) / COUNT(*), 2) AS default_rate_pct
FROM loans;

-- 3. Default rate by loan purpose
SELECT loan_purpose,
       COUNT(*) AS total_loans,
       ROUND(100.0 * SUM(CASE WHEN loan_status = 'Default' THEN 1 ELSE 0 END) / COUNT(*), 2) AS default_rate_pct
FROM loans
GROUP BY loan_purpose
ORDER BY default_rate_pct DESC;

-- 4. Default rate by age group
SELECT CASE WHEN age BETWEEN 18 AND 25 THEN '18-25'
            WHEN age BETWEEN 26 AND 35 THEN '26-35'
            WHEN age BETWEEN 36 AND 45 THEN '36-45'
            ELSE '46+' END AS age_group,
       COUNT(*) AS total_loans,
       ROUND(100.0 * SUM(CASE WHEN loan_status = 'Default' THEN 1 ELSE 0 END) / COUNT(*), 2) AS default_rate_pct
FROM loans
GROUP BY age_group
ORDER BY default_rate_pct DESC;

-- 5. Default rate by employment type
SELECT employment_type,
       COUNT(*) AS total_loans,
       ROUND(100.0 * SUM(CASE WHEN loan_status = 'Default' THEN 1 ELSE 0 END) / COUNT(*), 2) AS default_rate_pct
FROM loans
GROUP BY employment_type
ORDER BY default_rate_pct DESC;

-- 6. Default rate by credit score band
SELECT CASE WHEN credit_score < 550 THEN 'Poor (<550)'
            WHEN credit_score < 650 THEN 'Fair (550-649)'
            WHEN credit_score < 750 THEN 'Good (650-749)'
            ELSE 'Excellent (750+)' END AS credit_band,
       COUNT(*) AS total_loans,
       ROUND(100.0 * SUM(CASE WHEN loan_status = 'Default' THEN 1 ELSE 0 END) / COUNT(*), 2) AS default_rate_pct
FROM loans
GROUP BY credit_band
ORDER BY default_rate_pct DESC;

-- 7. Loan-to-income ratio vs default (key risk driver)
SELECT CASE WHEN loan_amount / annual_income < 0.2 THEN 'Below 20%'
            WHEN loan_amount / annual_income < 0.4 THEN '20-40%'
            ELSE 'Above 40%' END AS loan_to_income,
       COUNT(*) AS total_loans,
       ROUND(100.0 * SUM(CASE WHEN loan_status = 'Default' THEN 1 ELSE 0 END) / COUNT(*), 2) AS default_rate_pct
FROM loans
WHERE annual_income > 0
GROUP BY loan_to_income
ORDER BY default_rate_pct DESC;

-- 8. Average loan amount: defaulters vs non-defaulters
SELECT loan_status,
       ROUND(AVG(loan_amount), 2) AS avg_loan_amount,
       ROUND(AVG(annual_income), 2) AS avg_income
FROM loans
GROUP BY loan_status;

-- 9. Total exposure (money at risk) from defaulted loans
SELECT SUM(loan_amount) AS exposure_at_risk
FROM loans
WHERE loan_status = 'Default';

-- 10. Rank loan purposes by default rate (window function)
WITH purpose_stats AS (
    SELECT loan_purpose,
           COUNT(*) AS total_loans,
           100.0 * SUM(CASE WHEN loan_status = 'Default' THEN 1 ELSE 0 END) / COUNT(*) AS default_rate
    FROM loans
    GROUP BY loan_purpose
)
SELECT loan_purpose,
       total_loans,
       ROUND(default_rate, 2) AS default_rate_pct,
       RANK() OVER (ORDER BY default_rate DESC) AS risk_rank
FROM purpose_stats;
