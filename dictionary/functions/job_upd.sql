CREATE OR REPLACE FUNCTION dictionary.job_upd(_src JSONB) RETURNS JSONB
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _name         VARCHAR(50);
    _hour_payment decimal(8, 2);
    _dt           TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
BEGIN
    SELECT s.name,
           s.hour_payment
    INTO _name, _hour_payment
    FROM jsonb_to_record(_src) AS s (
                                     name VARCHAR(50),
                                     hour_payment decimal(8, 2));

    WITH ins_cte AS (
        INSERT INTO dictionary.job AS e (
                                         name,
                                         hour_payment)
            SELECT _name,
                   _hour_payment
            ON CONFLICT (id) DO UPDATE
                SET name = excluded.name,
                    hour_payment = excluded.hour_payment
            RETURNING e.*)

    INSERT
    INTO history.job AS ec (name,
                            hour_payment,
                            ch_dt)
    SELECT ic.name,
           ic.hour_payment,
           _dt
    FROM ins_cte ic;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;