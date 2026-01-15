-- Flag records where Actual_Delivery_Date is before Order_Date --
SELECT *FROM orders_table
WHERE Actual_Delivery_Date < Order_Date;



