CREATE OR REPLACE FUNCTION humanresource.get_employee_job(_log_id BIGINT) RETURNS JSON
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
BEGIN
    RETURN JSONB_BUILD_OBJECT('data', json_agg(row_to_json(res)))
        FROM (select *
              from humanresource.employee e
                       join connections.employee_job ep on e.employee_id = ep.id_employee
                       join dictionary.job j on j.id = ep.id_job
              where e.employee_id = _log_id) res;

END
$$;
