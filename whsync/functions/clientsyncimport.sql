CREATE OR REPLACE FUNCTION whsync.clientsyncimport(_src JSONB) RETURNS JSONB
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
BEGIN
    INSERT INTO humanresource.client AS e (client_id,
                                           client_name,
                                           phone,
                                           company_id,
                                           ch_employee)
    SELECT s.client_id,
           s.client_name,
           s.phone,
           s.company_id,
           s.ch_employee
    FROM jsonb_to_recordset(_src) AS s (client_id INTEGER,
                                        client_name VARCHAR(255),
                                        phone VARCHAR(11),
                                        company_id integer,
                                        ch_employee integer)
    ON CONFLICT (client_id) DO UPDATE
        SET phone       = excluded.phone,
            client_name = excluded.client_name,
            company_id  = excluded.company_id,
            ch_employee = excluded.ch_employee;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;