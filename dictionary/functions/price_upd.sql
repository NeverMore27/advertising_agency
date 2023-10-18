CREATE OR REPLACE FUNCTION dictionary.price_upd(_src JSONB) RETURNS JSONB
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _name     VARCHAR(50);
    _min_cost decimal(8, 2);
    _dt       TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
BEGIN
    SELECT s.name,
           s.min_cost
    INTO _name, _min_cost
    FROM jsonb_to_record(_src) AS s (
                                     name VARCHAR(50),
                                     min_cost decimal(8, 2));

    WITH ins_cte AS (
        INSERT INTO dictionary.price AS e (
                                           name,
                                           min_cost)
            SELECT _name,
                   _min_cost
            ON CONFLICT (id) DO UPDATE
                SET name = excluded.name,
                    min_cost = excluded.min_cost
            RETURNING e.*)

    INSERT
    INTO history.price AS ec (name,
                              min_cost,
                              ch_dt)
    SELECT ic.name,
           ic.min_cost,
           _dt
    FROM ins_cte ic;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;