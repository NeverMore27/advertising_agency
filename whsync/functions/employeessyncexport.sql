CREATE OR REPLACE FUNCTION whsync.employeessyncexport(_log_id BIGINT) RETURNS JSONB
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
DECLARE
    _dt  TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
    _res JSONB;
BEGIN
    DELETE
    FROM whsync.employeessync es
    WHERE es.log_id <= _log_id
      AND es.sync_dt IS NOT NULL;

    WITH sync_cte AS (
    SELECT es.log_id,
           es.employee_id,
           es.name,
           es.phone_number,
           es.payment_detalis,
           es.sync_dt

    FROM whsync.employeessync es
    ORDER BY es.log_id
    LIMIT 1000)

        ,cte_upd AS (
         UPDATE whsync.employeessync es
         SET sync_dt = _dt
         FROM sync_cte sc
         WHERE es.log_id = sc.log_id)

    SELECT JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(sc)))
    INTO _res
    FROM sync_cte sc;

    RETURN _res;
END
$$;