CREATE OR REPLACE FUNCTION humanresource.clientupd(_src JSONB, _ch_employee INTEGER) RETURNS JSONB
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _client_id   integer;
    _client_name VARCHAR(255);
    _phone       VARCHAR(11);
    _company_id  integer;
    _dt          TIMESTAMPTZ := now() AT TIME ZONE 'Europe/Moscow';
BEGIN
    SELECT COALESCE(c.client_id, nextval('humanresource.clientsq')) as client_id,
           s.client_name,
           s.phone,
           s.company_id
    INTO _client_id , _client_name, _phone, _company_id
    FROM jsonb_to_record(_src) AS s (client_id INTEGER,
                                     client_name VARCHAR(255),
                                     phone VARCHAR(11),
                                     company_id integer)
             LEFT JOIN humanresource.client c
                       ON c.client_id = s.client_id;

    IF exists(SELECT 1 FROM humanresource.client c WHERE c.phone = _phone)
        THEN
            RETURN public.errmessage(_errcode := 'humanresource.client_ins.phone_exists',
                                     _msg := 'Такой номер телефона уже зарегитрирован!',
                                     _detail := concat('phone = ', _phone));
        END IF;

    IF NOT exists(SELECT 1 FROM humanresource.employee c WHERE c.employee_id = _ch_employee)
        THEN
            RETURN public.errmessage(_errcode := 'humanresource.client_ins.ch_employee',
                                     _msg := 'Неверный код сотрудника',
                                     _detail := concat('phone = ', _phone));
        END IF;

    WITH ins_cte AS (
        INSERT INTO humanresource.client AS e (client_id,
                                               client_name,
                                               phone,
                                               company_id,
                                               ch_employee)
            SELECT _client_id,
                   _client_name,
                   _phone,
                   _company_id,
                   _ch_employee
            ON CONFLICT (client_id) DO UPDATE
                SET phone = excluded.phone,
                    client_name = excluded.client_name,
                    company_id = excluded.company_id,
                    ch_employee = excluded.ch_employee
            RETURNING e.*)

    INSERT
    INTO whsync.clientsync (client_id,
                            name,
                            phone_number,
                            company_id,
                            ch_employee,
                            sync_dt)
    SELECT ic.client_id,
           ic.client_name,
           ic.phone,
           ic.company_id,
           ic.ch_employee,
           _dt
    FROM ins_cte ic;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;
