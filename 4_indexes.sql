--Прискорює пошук тільки "свіжих" записів зі статусом 0, не чіпаючи мільйони оброблених рядків
CREATE INDEX idx_operations_status_ready 
ON Operations (Status) 
WHERE Status = 0;

-- Прискорює пошук по ID клієнта всередині JSON
CREATE INDEX idx_operations_user_id 
ON Operations (((Message->>'user_id')::int));

-- Прискорює пошук по типу операції
CREATE INDEX idx_operations_client_type 
ON Operations ((Message->>'client_type'));