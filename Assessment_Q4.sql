/*Task: For each customer, assuming the profit_per_transaction is 0.1% of the transaction value, calculate:
Account tenure (months since signup)
Total transactions
Estimated CLV (Assume: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction)
Order by estimated CLV from highest to lowest*/

SELECT
    u.id AS customer_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,

    -- Calculate account tenure in months since date joined
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,

    -- Count total inflow transactions for the customer (confirmed_amount > 0)
    COUNT(s.id) AS total_transactions,

    -- Calculate average profit per transaction:
    -- profit_per_transaction = 0.1% of transaction value (confirmed_amount in kobo converted to base unit)
    ROUND(AVG(COALESCE(s.confirmed_amount, 0)) * 0.001 / 100,2) AS avg_profit_per_transaction,

    -- Estimated CLV = (total_transactions / tenure_months) * 12 * avg_profit_per_transaction
    ROUND(
        (COUNT(s.id) / NULLIF(TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()), 0)) 
        * 12
        * AVG(COALESCE(s.confirmed_amount, 0)) * 0.001 / 100,
    2) AS estimated_clv

FROM
    users_customuser u
LEFT JOIN
    savings_savingsaccount s ON u.id = s.owner_id AND s.confirmed_amount > 0

GROUP BY
    u.id, name, tenure_months
ORDER BY
    estimated_clv DESC;
