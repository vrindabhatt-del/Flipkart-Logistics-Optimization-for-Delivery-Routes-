SELECT Order_ID, Warehouse_ID, Route_ID, Order_Date, Actual_Delivery_Date
FROM orders_table
LIMIT 10;
-- Step 1: Calculate delivery delay (in days) for each order --
SELECT 
    Order_ID,
    Warehouse_ID,
    Route_ID,
    Order_Date,
    Actual_Delivery_Date,
    DATEDIFF(Actual_Delivery_Date, Order_Date) AS Delivery_Delay_Days
FROM orders_table
LIMIT 10;
-- Step 2: Find Top 10 delayed routes (average delay) --
SELECT 
    Route_ID,
    ROUND(AVG(DATEDIFF(Actual_Delivery_Date, Order_Date)), 2) AS Avg_Delay_Days
FROM orders_table
GROUP BY Route_ID
ORDER BY Avg_Delay_Days DESC
LIMIT 10;
-- Step 3: Rank orders by delay within each warehouse --
SELECT
    Order_ID,
    Warehouse_ID,
    Route_ID,
    DATEDIFF(Actual_Delivery_Date, Order_Date) AS Delivery_Delay_Days,
    RANK() OVER (
        PARTITION BY Warehouse_ID
        ORDER BY DATEDIFF(Actual_Delivery_Date, Order_Date) DESC
    ) AS Delay_Rank
FROM orders_table
ORDER BY Warehouse_ID, Delay_Rank
LIMIT 20;

