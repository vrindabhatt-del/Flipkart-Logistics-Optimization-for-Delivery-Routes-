use flipkart_logistics;
SELECT * FROM orders_table LIMIT 10;
-- finding duplicates --
SELECT Order_ID, COUNT(*) AS count
FROM orders_table
GROUP BY Order_ID
HAVING count > 1;

