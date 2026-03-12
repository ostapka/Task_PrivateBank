CREATE TABLE Client_Balances (
    Client_Id INT,
    Operation_Type TEXT,
    Total_Amount NUMERIC(15, 2) DEFAULT 0,
    Last_Update TIMESTAMP DEFAULT now(),
    PRIMARY KEY (Client_Id, Operation_Type)
);