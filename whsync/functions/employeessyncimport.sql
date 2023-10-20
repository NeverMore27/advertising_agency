CREATE OR REPLACE FUNCTION whsync.employeessyncimport(_src JSONB) RETURNS JSONB
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
BEGIN
    INSERT INTO humanresource.employee AS e (employee_id,
                                             employee_name,
                                             phone,
                                             payment_detalis)
    SELECT s.employee_id,
           s.employee_name,
           s.phone,
           s.payment_detalis
    FROM jsonb_to_recordset(_src) AS s (employee_id BIGINT,
                                        employee_name VARCHAR(255),
                                        phone VARCHAR(11),
                                        payment_detalis varchar(255))
    ON CONFLICT (employee_id) DO UPDATE
        SET phone           = excluded.phone,
            employee_name   = excluded.employee_name,
            payment_detalis = excluded.payment_detalis;

    RETURN JSONB_BUILD_OBJECT('data', NULL);
END
$$;