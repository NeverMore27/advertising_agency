CREATE OR REPLACE FUNCTION humanresource.get_employee_project(_log_id BIGINT) RETURNS JSON
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
DECLARE
BEGIN
    RETURN JSONB_BUILD_OBJECT('data', json_agg(row_to_json(res)))
        FROM (select a.id, a.text, a.date_start, a.date_end, a.id_client
              from humanresource.employee e
                       join connections.employee_project ep on e.employee_id = ep.id_employee
                       join projects.agreement a on a.id = ep.id_agreement
              where e.employee_id = _log_id) res;

END
$$;