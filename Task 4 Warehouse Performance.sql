USE flipkart_logistics;
-- step 1 Find the top 3 warehouses with the highest average processing time.
SELECT Warehouse_ID, Warehouse_Name, City, Average_Processing_Time_Min
FROM warehouse_table
ORDER BY Average_Processing_Time_Min DESC
LIMIT 3;

-- Step 2 Calculate total vs. delayed shipments for each warehouse.
SELECT 
    w.Warehouse_ID,
    w.Warehouse_Name,
    COUNT(o.Order_ID) AS Total_Shipments,
    SUM(CASE WHEN o.Delivery_Delay_Days > 0 THEN 1 ELSE 0 END) AS Delayed_Shipments
FROM Warehouse_table w
LEFT JOIN orders_table o ON w.Warehouse_ID = o.Warehouse_ID
GROUP BY w.Warehouse_ID, w.Warehouse_Name
ORDER BY Delayed_Shipments DESC;

-- Step 3 Use CTEs to find bottleneck warehouses where processing time > global average.
SELECT 
    w.Warehouse_ID,
    w.Warehouse_Name,
    w.City,
    w.Average_Processing_Time_Min,
    (SELECT AVG(Average_Processing_Time_Min) FROM Warehouse_table) AS Global_Avg_Processing_Time
FROM Warehouse_table w
WHERE w.Average_Processing_Time_Min > (SELECT AVG(Average_Processing_Time_Min) FROM Warehouse_table)
ORDER BY w.Average_Processing_Time_Min DESC;

-- Step 4 Rank warehouses based on on-time delivery percentage.
SELECT 
    w.Warehouse_ID,
    w.Warehouse_Name,
    w.City,
    w.Average_Processing_Time_Min,
    COUNT(o.Order_ID) AS Total_Shipments,
    SUM(CASE WHEN o.Delivery_Delay_Days > 0 THEN 1 ELSE 0 END) AS Delayed_Shipments,
    ROUND(
        (SUM(CASE WHEN o.Delivery_Delay_Days <= 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(o.Order_ID)), 2
    ) AS On_Time_Percentage,
    CASE WHEN w.Average_Processing_Time_Min > (SELECT AVG(Average_Processing_Time_Min) FROM Warehouse_table) 
         THEN 1 ELSE 0 
    END AS Is_Bottleneck
FROM Warehouse_table w
LEFT JOIN orders_table o ON w.Warehouse_ID = o.Warehouse_ID
GROUP BY w.Warehouse_ID, w.Warehouse_Name, w.City, w.Average_Processing_Time_Min
ORDER BY On_Time_Percentage DESC;
