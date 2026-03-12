CREATE OR REPLACE PROCEDURE insert_single_operation()
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Operations (Status, Amount, Message)
    VALUES (
        0,                                 -- завжди 0, щоб потім UPDATE на 1 активував тригер
        (random() * 100)::numeric(15,2),   -- випадкова сума
        jsonb_build_object(
            'source', 'scheduled_task', 
            'time', now(),
            'user_id', floor(random() * 100 + 1)::int,        -- ID клієнта (1-100)
            'client_type', (ARRAY['retail', 'corporate', 'vip'])[floor(random()*3)+1] -- ДОДАНО
        )
    );
END;
$$;