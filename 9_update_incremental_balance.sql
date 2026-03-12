CREATE OR REPLACE FUNCTION update_incremental_balance()
RETURNS TRIGGER AS $$
BEGIN
    -- Спрацьовує тільки якщо статус змінився з 0 на 1
    IF (OLD.Status = 0 AND NEW.Status = 1) THEN
        INSERT INTO Client_Balances (Client_Id, Operation_Type, Total_Amount, Last_Update)
        VALUES (
            (NEW.Message->>'user_id')::int, 
            NEW.Message->>'client_type', 
            NEW.Amount, 
            now()
        )
        ON CONFLICT (Client_Id, Operation_Type) 
        DO UPDATE SET 
            Total_Amount = Client_Balances.Total_Amount + EXCLUDED.Total_Amount,
            Last_Update = now();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;