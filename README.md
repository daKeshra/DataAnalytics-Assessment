# DataAnalytics-Assessment
### Per-Question Explanations: This document explains the approach to solving and analysing this Data analytics assessment as documented [here](https://docs.google.com/document/d/1qGaMGhLRYG3IsBfSHNrj8D5VlmxtjZxns17zC76T_5g/preview?tab=t.0).


## Task 1: Write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.
**Approach:**  
- Applied conditional aggregation to count savings plans (`is_regular_savings = 1`) and investment plans (`is_a_fund = 1`) using the `CASE` statement.
- Joined `users_customuser` with `plans_plan` to identify customers plans.
- Joined with `savings_savingsaccount` to sum all inflow (`confirmed_amount`).
- Convert amounts to Naira by dividing confirmed amount by 100
- Filter customers having at least one savings and one investment plan.
- Sort results by tota_ deposits descending.

----

## Task 2: Calculate the average number of transactions per customer per month and categorize them:
- "High Frequency" (≥10 transactions/month)
- "Medium Frequency" (3-9 transactions/month)
- "Low Frequency" (≤2 transactions/month)
**Approach:**  
- I started by aggregating the total number of transactions each customer made per month.
- then calculate the average monthly transaction count across all months that a transaction occured.
- using the `CASE` statement, I categorized the customers based on the average monthly transaction per customer
- Categorize the customers based on frequency.
- Grouped results by frequency category to get counts and averages.

**Challenges:**  
**Multiple Monthly Records**: Some users have active months and inactive ones, making it tricky to compute true averages. To solve this I ensured to count monthly transactions per user.
**Nested Subqueries**: Calculating the monthly transaction count and frequency category in a single query requires nesting of subqueries.

---

## Task 3: Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days) .
**Approach:**  
- Selected only active savings and investment plans.
- Confirmed the last transaction dates per plan based on the confirmed_amount.
- Calculated datediff to confirm inactivity duration in days.
- Filtered for accounts with no transactions in the last 365 days or no transactions at all.

**Challenges:**  
- Deciding between restricting the inactivity days between the last 365 days only or the last 365 days and above which may then extend to years. After a few research and study, 

---

## Question 4: Task: For each customer, assuming the profit_per_transaction is 0.1% of the transaction value, calculate:
- Account tenure (months since signup)
- Total transactions
- Estimated CLV (Assume: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction)
- Order by estimated CLV from highest to lowest

**Approach:**  
-Joined the `user_customuser and savings_savingsaccount` table.
- Calculated account tenure in months from user signup date.
- Using the assumed profit per transaction as 0.1% of transaction value, I calculated CLV with the formula: `(total_transactions / tenure) * 12 * avg_profit_per_transaction`.
- Sorted customers by estimated CLV descending.

**Challenges:**  
- Handling customers with zero tenure to avoid division by zero.

---

## Additional Notes
- All monetary amounts stored in kobo were converted to the main currency unit by dividing by 100.
- Used `COALESCE` to handle NULLs where transactions might be missing.
- Queries are optimized for readability and maintainability.
