Use flipkart_logistics;
-- Step 1 Rank agents (per route) by on-time delivery percentage
SELECT 
    o.Route_ID,
    da.Agent_Name,
    o.Agent_ID,
    COUNT(o.Order_ID) AS Total_Shipments,
    SUM(CASE WHEN o.Delivery_Delay_Days <= 0 THEN 1 ELSE 0 END) AS On_Time_Shipments,
    ROUND(SUM(CASE WHEN o.Delivery_Delay_Days <= 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(o.Order_ID), 2) AS On_Time_Percentage,
    RANK() OVER (PARTITION BY o.Route_ID ORDER BY SUM(CASE WHEN o.Delivery_Delay_Days <= 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(o.Order_ID) DESC) AS Rank_Per_Route
FROM orders_table o
JOIN deliveryagents_table da ON o.Agent_ID = da.Agent_ID
GROUP BY o.Route_ID, o.Agent_ID, da.Agent_Name
ORDER BY o.Route_ID, Rank_Per_Route;

-- Step 2 Find agents with on-time % < 80%.
WITH Agent_Performance AS (
    SELECT 
        o.Route_ID,
        da.Agent_Name,
        o.Agent_ID,
        COUNT(o.Order_ID) AS Total_Shipments,
        SUM(CASE WHEN o.Delivery_Delay_Days <= 0 THEN 1 ELSE 0 END) AS On_Time_Shipments,
        ROUND(SUM(CASE WHEN o.Delivery_Delay_Days <= 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(o.Order_ID), 2) AS On_Time_Percentage,
        RANK() OVER (PARTITION BY o.Route_ID ORDER BY SUM(CASE WHEN o.Delivery_Delay_Days <= 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(o.Order_ID) DESC) AS Rank_Per_Route
    FROM orders_table o
    JOIN deliveryagents_table da ON o.Agent_ID = da.Agent_ID
    GROUP BY o.Route_ID, o.Agent_ID, da.Agent_Name
)
SELECT *
FROM Agent_Performance
WHERE On_Time_Percentage < 80
ORDER BY On_Time_Percentage ASC;

-- Step 3 Compare average speed of top 5 vs bottom 5 agents using subqueries.
WITH Agent_Performance AS (
    SELECT 
        o.Agent_ID,
        da.Agent_Name,
        da.Avg_Speed_KMPH,
        ROUND(SUM(CASE WHEN o.Delivery_Delay_Days <= 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(o.Order_ID), 2) AS On_Time_Percentage
    FROM orders_table o
    JOIN deliveryagents_table da ON o.Agent_ID = da.Agent_ID
    GROUP BY o.Agent_ID, da.Agent_Name, da.Avg_Speed_KMPH
)
-- Compare top 5 vs bottom 5 agents by on-time %
SELECT 
    'Top 5 Agents' AS Group_Type,
    ROUND(AVG(Avg_Speed_KMPH), 2) AS Average_Speed
FROM (
    SELECT * 
    FROM Agent_Performance
    ORDER BY On_Time_Percentage DESC
    LIMIT 5
) AS Top5
UNION ALL
SELECT 
    'Bottom 5 Agents' AS Group_Type,
    ROUND(AVG(Avg_Speed_KMPH), 2) AS Average_Speed
FROM (
    SELECT * 
    FROM Agent_Performance
    ORDER BY On_Time_Percentage ASC
    LIMIT 5
) AS Bottom5;

-- Step 4 Suggest training or workload balancing strategies for low performers
SELECT *
FROM Agent_Performance
WHERE Performance_Flag = 'Low Performer';
