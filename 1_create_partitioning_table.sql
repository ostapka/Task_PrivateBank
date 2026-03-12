CREATE TABLE Operations (
    Id INT GENERATED ALWAYS AS IDENTITY,
    Op_Date TIMESTAMP NOT NULL DEFAULT now(),
    Amount NUMERIC(15, 2) CHECK (Amount >= 0),
    Status SMALLINT NOT NULL CHECK (Status IN (0, 1)),
    Op_Guid UUID NOT NULL DEFAULT gen_random_uuid(),
    Message JSONB,
    -- Ключі мають включати поле Op_Date
    PRIMARY KEY (Id, Op_Date),
    UNIQUE (Op_Guid, Op_Date)
) PARTITION BY RANGE (Op_Date);

-- 1. Створюємо партицію на лютий - березень 2026
CREATE TABLE operations_q1 PARTITION OF Operations
    FOR VALUES FROM ('2026-02-01') TO ('2026-04-01');

-- 2. Створюємо партицію на грудень 2025 - січень 2026
CREATE TABLE operations_q2 PARTITION OF Operations
    FOR VALUES FROM ('2025-12-01') TO ('2026-02-01');

-- 3. Завжди створюйте дефолтну партицію для "майбутнього" або помилок
CREATE TABLE operations_default PARTITION OF Operations DEFAULT;