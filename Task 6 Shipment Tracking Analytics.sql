use flipkart_logistics;
-- 	Step 1 For each order, list the last checkpoint and time.
SELECT 
    sc.Order_ID,
    sc.Checkpoint AS Last_Checkpoint,
    sc.Checkpoint_Time AS Last_Checkpoint_Time
FROM shipmenttracking_table sc
INNER JOIN (
    SELECT 
        Order_ID,
        MAX(Checkpoint_Time) AS Last_Time
    FROM shipmenttracking_table
    GROUP BY Order_ID
) latest ON sc.Order_ID = latest.Order_ID AND sc.Checkpoint_Time = latest.Last_Time;

-- Step 2 Step 2: Find the most common delay reasons (excluding ‘None’)
SELECT 
    Delay_Reason,
    COUNT(*) AS Frequency
FROM shipmenttracking_table
WHERE Delay_Reason IS NOT NULL AND Delay_Reason <> 'None'
GROUP BY Delay_Reason
ORDER BY Frequency DESC
LIMIT 5;

-- Step 3 Identify orders with >2 delayed checkpoints
SELECT 
    Order_ID,
    COUNT(*) AS Delayed_Checkpoints
FROM shipmenttracking_table
WHERE Delay_Minutes > 0
GROUP BY Order_ID
HAVING COUNT(*) > 2
ORDER BY Delayed_Checkpoints DESC;



