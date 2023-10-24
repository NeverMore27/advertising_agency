CREATE OR REPLACE FUNCTION projects.campaigns_upd(_src JSONB) RETURNS JSONB
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _id           integer;
    _id_agreement integer;
    _name         varchar(50);
    _details      json;
    _budget       decimal(10, 2);
    _date_start   date;
    _date_end     date;
    _dt           TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
BEGIN
    SELECT COALESCE(c.id, nextval('projects.campaignssq')) as id,
           s.id_agreement,
           s.name,
           s.details,
           s.budget,
           s.date_start,
           s.date_end
    INTO _id, _id_agreement, _name, _details, _budget, _date_start, _date_end
    FROM jsonb_to_record(_src) AS s (id integer,
                                     id_agreement integer,
                                     name varchar(50),
                                     details json,
                                     budget decimal(10, 2),
                                     date_start date,
                                     date_end date)
             LEFT JOIN projects.campaigns c
                       ON c.id = s.id;
    IF (_date_start > _date_end)
    THEN
        RETURN public.errmessage(_errcode := ' projects.camp_ins.date',
                                 _msg := 'Ошибочные даты',
                                 _detail := concat('date_start = ', _date_start, ' date_end = ', _date_end));
    END IF;

    WITH ins_cte AS (
        INSERT INTO projects.campaigns AS e (id,
                                             id_agreement,
                                             name,
                                             details,
                                             budget,
                                             date_start,
                                             date_end)
            SELECT _id,
                   _id_agreement,
                   _name,
                   _details,
                   _budget,
                   _date_start,
                   _date_end
            ON CONFLICT (id) DO UPDATE
                SET id = excluded.id,
                    id_agreement = excluded.id_agreement,
                    name = excluded.name,
                    details = excluded.details,
                    budget = excluded.budget,
                    date_start = excluded.date_start,
                    date_end = excluded.date_end
            RETURNING e.*)
    INSERT
    INTO history.campaigns AS ec (id,
                                  id_agreement,
                                  name,
                                  details,
                                  budget,
                                  date_start,
                                  date_end,
                                  ch_dt)
    SELECT ic.id,
           ic.id_agreement,
           ic.name,
           ic.details,
           ic.budget,
           ic.date_start,
           ic.date_end,
           _dt
    FROM ins_cte ic;


    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;
