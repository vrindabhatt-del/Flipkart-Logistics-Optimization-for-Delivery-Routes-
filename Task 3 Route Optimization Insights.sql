USE flipkart_logistics;
-- Step 1- Route-level summary: avg delivery time, avg traffic delay, efficiency (km per minute)
SELECT
  r.Route_ID,
  r.Start_Location,
  r.End_Location,
  -- Average delivery time in days (using date conversion)
  ROUND(AVG(DATEDIFF(
    STR_TO_DATE(o.Actual_Delivery_Date, '%Y-%m-%d'),
    STR_TO_DATE(o.Order_Date, '%Y-%m-%d')
  )), 2) AS avg_delivery_time_days,
  -- Average traffic delay
  ROUND(AVG(r.Traffic_Delay_Min), 2) AS avg_traffic_delay_min,
  -- Efficiency ratio: km per minute
  ROUND(r.Distance_KM / NULLIF(r.Average_Travel_Time_Min, 0), 4) AS efficiency_ratio,
  COUNT(o.Order_ID) AS total_shipments
FROM routes_table r
LEFT JOIN orders_table o 
  ON r.Route_ID = o.Route_ID
GROUP BY 
  r.Route_ID, r.Start_Location, r.End_Location, 
  r.Distance_KM, r.Average_Travel_Time_Min
ORDER BY avg_delivery_time_days DESC;
-- Step 2- Identify 3 routes with the worst efficiency ratio
SELECT
  Route_ID,
  Start_Location,
  End_Location,
  Distance_KM,
  Average_Travel_Time_Min,
  ROUND(Distance_KM / NULLIF(Average_Travel_Time_Min, 0), 4) AS efficiency_ratio
FROM routes_table
ORDER BY efficiency_ratio ASC
LIMIT 3;

-- Step 3- Find routes with >20% delayed shipments
SELECT 
  r.Route_ID,
  r.Start_Location,
  r.End_Location,
  COUNT(o.Order_ID) AS total_orders,
  -- Count delayed shipments (where delay days > 0)
  SUM(CASE WHEN o.Delivery_Delay_Days > 0 THEN 1 ELSE 0 END) AS delayed_orders,
  -- Calculate percentage of delayed shipments
  ROUND(
    (SUM(CASE WHEN o.Delivery_Delay_Days > 0 THEN 1 ELSE 0 END) / COUNT(o.Order_ID)) * 100, 
    2
  ) AS delayed_percentage
FROM routes_table r
LEFT JOIN orders_table o 
  ON r.Route_ID = o.Route_ID
GROUP BY r.Route_ID, r.Start_Location, r.End_Location
HAVING delayed_percentage > 20
ORDER BY delayed_percentage DESC;
-- Recommendation Analysis
