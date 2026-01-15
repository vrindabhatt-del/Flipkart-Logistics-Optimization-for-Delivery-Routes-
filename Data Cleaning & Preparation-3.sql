-- replacing null values --
use flipkart_logistics;
SELECT * 
FROM routes_table
WHERE Traffic_Delay_Min IS NULL;
SELECT Route_ID, AVG(Traffic_Delay_Min) AS avg_delay
FROM routes_table
GROUP BY Route_ID;
SELECT COUNT(*) AS null_count
FROM routes_table
WHERE Traffic_Delay_Min IS NULL;

