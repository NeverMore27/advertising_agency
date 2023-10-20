CREATE OR REPLACE FUNCTION projects.promotion_upd(_src JSONB) RETURNS JSONB
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _id           integer;
    _id_agreement integer;
    _types        varchar(50);
    _link         varchar(255);
    _details      varchar(255);
    _dt           TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
BEGIN
    SELECT COALESCE(c.id, nextval('projects.promotionsq')) as id,
           s.id_agreement,
           s.types,
           s.link,
           s.detalis
    INTO _id, _id_agreement, _types, _link, _details
    FROM jsonb_to_record(_src) AS s (id integer,
                                     id_agreement integer,
                                     types varchar(50),
                                     link varchar(255),
                                     detalis json)
             LEFT JOIN projects.report c
                       ON c.id = s.id;

    WITH ins_cte AS (
        INSERT INTO projects.promotion_materials AS e (id,
                                                       id_agreement,
                                                       types,
                                                       link,
                                                       detalis)
            SELECT _id,
                   _id_agreement,
                   _types,
                   _link,
                   _details
            ON CONFLICT (id) DO UPDATE
                SET
                    id_agreement = excluded.id_agreement,
                    types = excluded.types,
                    link = excluded.link,
                    detalis = excluded.detalis
            RETURNING e.*)
    INSERT
    INTO history.promotion_materials AS ec (id,
                                            id_agreement,
                                            types,
                                            link,
                                            detalis,
                                            ch_dt)
    SELECT ic.id,
           ic.id_agreement,
           ic.types,
           ic.link,
           ic.detalis,
           _dt
    FROM ins_cte ic;


    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;