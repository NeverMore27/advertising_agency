CREATE OR REPLACE FUNCTION projects.agreement_upd(_src JSONB) RETURNS JSONB
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _id integer;
    _id_client  integer;
    _date_start date;
    _date_end   date;
    _text       json;
    _dt          TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
BEGIN
    SELECT COALESCE(c.id, nextval('projects.reportsq')) as id,
           s.id_client,
           s.date_start,
           s.date_end,
           s.text
    INTO _id, _id_client, _date_start, _date_end, _text
    FROM jsonb_to_record(_src) AS s (id INTEGER,
                                    id_client INTEGER,
                                    date_start date,
                                    date_end   date,
                                    text       json)
             LEFT JOIN projects.report c
                       ON c.id = s.id;

    IF NOT exists(SELECT 1 FROM humanresource.client c WHERE c.client_id = _id_client)
        THEN
            RETURN public.errmessage(_errcode := ' projects.agr_ins.client',
                                     _msg := 'Такого клиента не существует',
                                     _detail := concat('id = ', _id_client));
        END IF;
    IF (_date_start>_date_end)
        THEN
            RETURN public.errmessage(_errcode := ' projects.agr_ins.date',
                                     _msg := 'Ошибочные даты',
                                     _detail := concat('date_start = ', _date_start, ' date_end = ', _date_end));
        END IF;

    INSERT INTO projects.agreement AS e (id,
                                     id_client,
                                     date_start,
                                     date_end,
                                     text)
        SELECT _id,
               _id_client,
               _date_start,
               _date_end,
               _text
        ON CONFLICT (id) DO UPDATE
            SET id_client = excluded.id_client,
                date_start = excluded.date_start,
                date_end = excluded.date_end,
                text = excluded.text;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;