CREATE TRIGGER trg_update_balances_on_status
AFTER UPDATE OF Status ON Operations
FOR EACH ROW
EXECUTE FUNCTION update_incremental_balance();