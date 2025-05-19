/* Calculate the average number of transactions per customer per month and categorize them.*/

SELECT
    frequency_category,
    COUNT(DISTINCT owner_id) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month
FROM (
    SELECT
        owner_id,
        AVG(transactions_count) AS avg_transactions_per_month,
        CASE
            WHEN AVG(transactions_count) >= 10 THEN 'High Frequency'
            WHEN AVG(transactions_count) BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM (
        SELECT
            owner_id,
            DATE_FORMAT(transaction_date, '%Y-%m') AS year_and_month,
            COUNT(*) AS transactions_count
        FROM savings_savingsaccount
        GROUP BY owner_id, 
				year_and_month
    ) monthly_counts
    GROUP BY owner_id
) categorized
GROUP BY frequency_category
ORDER BY
    CASE frequency_category
        WHEN 'High Frequency' THEN 1
        WHEN 'Medium Frequency' THEN 2
        WHEN 'Low Frequency' THEN 3
    END;
