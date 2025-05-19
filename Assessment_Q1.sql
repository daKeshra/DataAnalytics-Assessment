/*Task: Write a query to find customers with at least one funded savings plan 
AND one funded investment plan, sorted by total deposits..*/

SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
	-- Count number of accounts for savings and investment
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) AS savings_count,
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) AS investment_count,
    ROUND(SUM(COALESCE(s.confirmed_amount, 0)) / 100, 2) AS total_deposits  -- Divide by 100 to convert from kobo to naira
FROM users_customuser u
JOIN plans_plan p 
	ON u.id = p.owner_id
LEFT JOIN savings_savingsaccount s 
	ON s.plan_id = p.id
GROUP BY u.id, 
		u.first_name, 
		u.last_name
HAVING savings_count > 0 
		AND investment_count > 0
ORDER BY total_deposits DESC;
