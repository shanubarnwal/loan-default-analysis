# Loan Default & Credit Risk Analysis

**Tools:** SQL, Excel, Power BI

## Business Problem
Which customers are most likely to default on loans, and how can the bank reduce credit risk?

## Dataset
- Source: Kaggle - [dataset name and link]
- Size: [X] loan records, [Y] columns
- Key fields: age, employment type, income, loan amount, loan purpose, credit score, loan status

## Approach
1. **Excel:** Removed duplicates, handled missing values, created Age Group, Income Bracket and Loan-to-Income ratio columns.
2. **SQL:** Wrote 10 queries (joins, CASE WHEN, CTE, window function) to calculate default rate across segments. See `loan_default_analysis.sql`.
3. **Power BI:** Built a 2-page dashboard.
   - Page 1: KPIs (Total Loans, Default Rate, Exposure at Risk), default rate by loan purpose
   - Page 2: Risk drivers by age, income, credit score, with slicers

## Dashboard
![Dashboard Page 1](images/dashboard_page1.png)
![Dashboard Page 2](images/dashboard_page2.png)

## Key Findings
*(Replace with YOUR real numbers from the queries)*
1. Overall default rate was **[X]%**.
2. Customers with loan-to-income ratio above 40% had a default rate of **[X]%** vs **[Y]%** for those below 20%.
3. **[Loan purpose]** loans had the highest default rate at **[X]%**.
4. Credit scores below 550 showed a default rate of **[X]%**.

## Recommendations
1. Apply stricter approval checks when loan-to-income ratio exceeds 40%.
2. Review lending criteria for **[highest-risk loan purpose]**.
3. Monitor customers with credit score below 550 more closely.

## Folder Structure
```
loan-default-analysis/
├── README.md
├── loan_default_analysis.sql
├── cleaned_data.xlsx
├── loan_dashboard.pbix
└── images/
    ├── dashboard_page1.png
    └── dashboard_page2.png
```
