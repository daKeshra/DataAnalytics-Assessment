/*Task: Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days).*/

SELECT
    p.id AS plan_id,
    p.owner_id,
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,
    MAX(CASE WHEN s.confirmed_amount > 0 THEN s.transaction_date ELSE NULL END) AS last_transaction_date,
    DATEDIFF(CURDATE(), MAX(CASE WHEN s.confirmed_amount > 0 THEN s.transaction_date ELSE NULL END)) AS inactivity_days
FROM
    plans_plan p
LEFT JOIN
    savings_savingsaccount s 
    ON p.id = s.plan_id

WHERE
	-- Only active savings or investment plans
    p.is_regular_savings = 1 
    OR p.is_a_fund = 1
GROUP BY
    p.id, p.owner_id, type
HAVING
    last_transaction_date IS NULL -- no inflow transactions
    OR inactivity_days >= 365 -- or no transactions in the last 1 year
ORDER BY
    inactivity_days DESC;
