Use flipkart_logistics;
-- Step 1 Average Delivery Delay per Region (Start_Location)
SELECT 
    r.Start_Location,
    ROUND(AVG(COALESCE(o.Delivery_Delay_Days, 0)), 2) AS Avg_Delivery_Delay_Days
FROM orders_table o
JOIN routes_table r ON o.Route_ID = r.Route_ID
GROUP BY r.Start_Location
ORDER BY Avg_Delivery_Delay_Days DESC;

-- Step 2 On-Time Delivery % = (Total On-Time Deliveries / Total Deliveries) * 100.
SELECT 
    r.Start_Location,
    ROUND(
        (SUM(CASE WHEN o.Delivery_Delay_Days <= 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(o.Order_ID)),
        2
    ) AS OnTime_Delivery_Percentage
FROM orders_table o
JOIN routes_table r ON o.Route_ID = r.Route_ID
GROUP BY r.Start_Location
ORDER BY OnTime_Delivery_Percentage DESC;

-- Step 3 Average Traffic Delay per Route
SELECT 
    r.Route_ID,
    r.Start_Location,
    r.End_Location,
    ROUND(AVG(r.Traffic_Delay_Min), 2) AS Avg_Traffic_Delay_Min
FROM routes_table r
GROUP BY r.Route_ID, r.Start_Location, r.End_Location
ORDER BY Avg_Traffic_Delay_Min DESC;









