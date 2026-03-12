CREATE OR REPLACE PROCEDURE update_status_by_parity()
LANGUAGE plpgsql
AS $$
DECLARE
    current_sec INT;
BEGIN
    -- Отримуємо поточну секунду
    current_sec := extract(second from now())::int;

    IF current_sec % 2 = 0 THEN
        -- Якщо секунда парна: оновлюємо парні ID
        UPDATE Operations 
        SET Status = 1 
        WHERE Status = 0 AND (Id % 2 = 0);
    ELSE
        -- Якщо секунда непарна: оновлюємо непарні ID
        UPDATE Operations
        SET Status = 1 
        WHERE Status = 0 AND (Id % 2 != 0);
    END IF;
    
    COMMIT;
END;
$$;