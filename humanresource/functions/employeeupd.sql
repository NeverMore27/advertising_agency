CREATE OR REPLACE FUNCTION humanresource.employeesupd(_src JSONB) RETURNS JSONB
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _employee_id  BIGINT;
    _employee_name         VARCHAR(255);
    _phone VARCHAR(11);
    _payment_detalis varchar(255);
    _dt           TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
BEGIN
    SELECT COALESCE(e.employee_id, nextval('humanresource.employeesq')) as employee_id,
           s.employee_name,
           s.phone,
           s.payment_detalis
    INTO _employee_id, _employee_name , _phone, _payment_detalis
    FROM jsonb_to_record(_src) AS s (employee_id BIGINT,
                                    employee_name VARCHAR (255),
                                    phone VARCHAR (11),
                                    payment_detalis varchar (255))
             LEFT JOIN humanresource.employee e
                       ON e.employee_id = s.employee_id;

    IF exists(SELECT 1 FROM humanresource.employee e WHERE e.phone = _phone)
        THEN
            RETURN public.errmessage(_errcode := 'humanresource.employee_ins.phone_exists',
                                     _msg := 'Такой номер телефона уже зарегитрирован!',
                                     _detail := concat('phone = ', _phone));
        END IF;

    WITH ins_cte AS (
        INSERT INTO humanresource.employee AS e ( employee_id,
                                                  employee_name,
                                                  phone,
                                                  payment_detalis)
            SELECT _employee_id,
                   _employee_name,
                   _phone,
                   _payment_detalis
            ON CONFLICT (employee_id) DO UPDATE
                SET phone = excluded.phone,
                    employee_name        = excluded.employee_name,
                    payment_detalis   = excluded.payment_detalis
            RETURNING e.*)

    INSERT INTO whsync.employeessync (employee_id,
                                      name,
                                      phone_number,
                                      payment_detalis,
                                      sync_dt)
    SELECT ic.employee_id,
           ic.phone,
           ic.employee_name,
           ic.payment_detalis,
           _dt
    FROM ins_cte ic;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;