INSERT INTO Client_Balances (Client_Id, Operation_Type, Total_Amount)
SELECT 
    (Message->>'user_id')::int, 
    Message->>'client_type', 
    SUM(Amount)
FROM Operations1
WHERE Status = 1
GROUP BY 1, 2
ON CONFLICT (Client_Id, Operation_Type) 
DO UPDATE SET Total_Amount = Client_Balances.Total_Amount + EXCLUDED.Total_Amount;