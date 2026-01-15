-- Convert date columns into YYYY-MM-DD format --
-- Check current format --
SELECT Order_Date, Actual_Delivery_Date
FROM orders_table
LIMIT 10;
-- Convert format--
UPDATE orders_table
SET Order_Date = DATE_FORMAT(Order_Date, '%Y-%m-%d'),
    Actual_Delivery_Date = DATE_FORMAT(Actual_Delivery_Date, '%Y-%m-%d');


