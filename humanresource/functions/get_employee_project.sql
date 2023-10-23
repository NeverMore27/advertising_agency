CREATE OR REPLACE FUNCTION humanresource.get_employee_project(_emp_id BIGINT DEFAULT NULL)
    RETURNS JSON
    LANGUAGE plpgsql AS
$$
DECLARE
BEGIN

    RETURN JSONB_BUILD_OBJECT(
            'data',
            (SELECT json_agg(row_to_json(p))
             FROM (SELECT a.id,
                          a.text,
                          a.date_start,
                          a.date_end,
                          a.id_client
                   FROM humanresource.employee e
                            JOIN connections.employee_project ep ON e.employee_id = ep.id_employee
                            JOIN projects.agreement a ON a.id = ep.id_agreement
                   WHERE e.employee_id = COALESCE(_emp_id, e.employee_id)) p)
        );

END;
$$;
