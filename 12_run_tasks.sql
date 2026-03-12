-- Запуск таску на додавання запису в таблицю
SELECT cron.schedule('Try insert every 5 sec', '5 seconds', 'CALL insert_single_operation()');

-- Wokraround
-- якщо не хочемо так, то можемо зробити таким циклом
-- SELECT cron.schedule('Try insert every 5 sec', '* * * * *', $$
--  DO $block$ 
--  BEGIN
--    FOR i IN 1..12 LOOP
--      CALL insert_single_operation();
--      COMMIT; 
--      PERFORM pg_sleep(5);
--    END LOOP;
--  END;
--  $block$ LANGUAGE plpgsql;
--$$);
-- але то троха поганий варіант, бо можливий варіант накладання джоби на джобу, що створює навантаження для бази. Плюс буде, не факт, що 5 сек завжди

-- Запуск таску на оновлення статусу
SELECT cron.schedule('Try update status every 3 sec', '3 seconds', 'CALL update_status_by_parity()');

-- Wokraround
-- SELECT cron.schedule('update_parity_job', '* * * * *', $$
--  DO $block$ 
--  BEGIN
--    FOR i IN 1..20 LOOP
--      CALL update_status_by_parity();
--      COMMIT; 
--      PERFORM pg_sleep(3);
--    END LOOP;
--  END;
--  $block$ LANGUAGE plpgsql;
--$$);