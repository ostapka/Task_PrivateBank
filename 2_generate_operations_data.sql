CREATE OR REPLACE PROCEDURE generate_operations_data(rows_count INT)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Operations (Status, Amount, Op_Date, Message)
    SELECT 
        (random())::int,                                     -- Стан 0 або 1
        (random() * 5000)::numeric(15,2),                    -- Сума
        --період дат від 2025-12-01 до вчора
        '2025-12-01'::timestamp + (random() * ((current_date - 1)::timestamp + interval '1 day' - interval '1 second' - '2025-12-01'::timestamp)),
        jsonb_build_object(
            'source', 'auto_generator',
            'batch_id', s.id,
            'user_id', floor(random() * 100 + 1)::int,       -- Випадковий ID клієнта
            'client_type', (ARRAY['retail', 'corporate', 'vip'])[floor(random()*3)+1]
        )
    FROM generate_series(1, rows_count) AS s(id);
    
    RAISE NOTICE 'Успішно згенеровано % записів з повними даними для тригера', rows_count;
END;
$$;