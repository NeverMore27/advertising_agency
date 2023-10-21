CREATE OR REPLACE FUNCTION whsync.clientsyncexport(_log_id BIGINT) RETURNS JSONB
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
DECLARE
    _dt  TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
    _res JSONB;
BEGIN
    DELETE
    FROM whsync.clientsync es
    WHERE es.log_id <= _log_id
      AND es.sync_dt IS NOT NULL;

    WITH sync_cte AS (SELECT es.log_id,
                             es.client_id,
                             es.name,
                             es.phone_number,
                             es.company_id,
                             es.ch_employee,
                             es.sync_dt

                      FROM whsync.clientsync es
                      ORDER BY es.log_id
                      LIMIT 1000)

       , cte_upd AS (
        UPDATE whsync.clientsync es
            SET sync_dt = _dt
            FROM sync_cte sc
            WHERE es.log_id = sc.log_id)

    SELECT JSONB_BUILD_OBJECT('data', JSONB_AGG(ROW_TO_JSON(sc)))
    INTO _res
    FROM sync_cte sc;

    RETURN _res;
END
$$;