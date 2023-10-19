CREATE OR REPLACE FUNCTION projects.report_upd(_src JSONB) RETURNS JSONB
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _id           integer;
    _id_agreement integer;
    _date_ending  date;
    _result       json;
    _dt           TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
BEGIN
    SELECT COALESCE(c.id, nextval('projects.reportsq')) as id,
           s.id_agreement,
           s.date_ending,
           s.result
    INTO _id, _id_agreement, _date_ending, _result
    FROM jsonb_to_record(_src) AS s (id integer,
                                     id_agreement integer,
                                     date_ending date,
                                     result json)
             LEFT JOIN projects.report c
                       ON c.id = s.id;

    WITH ins_cte AS (
        INSERT INTO projects.report AS e (id,
                                          id_agreement,
                                          date_ending,
                                          result)
            SELECT _id,
                   _id_agreement,
                   _date_ending,
                   _result
            ON CONFLICT (id) DO UPDATE
                SET
                    id_agreement = excluded.id_agreement,
                    date_ending = excluded.date_ending,
                    result = excluded.result
            RETURNING e.*)
    INSERT
    INTO history.report AS ec (id,
                               id_agreement,
                               date_ending,
                               result,
                               ch_dt)
    SELECT ic.id,
           ic.id_agreement,
           ic.date_ending,
           ic.result,
           _dt
    FROM ins_cte ic;


    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;