CREATE OR REPLACE FUNCTION humanresource.get_project_client(_log_id BIGINT) RETURNS JSON
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
DECLARE
    _res JSONB;
BEGIN
    RETURN JSONB_BUILD_OBJECT('data', json_agg(row_to_json(res)))
        FROM (select client_name, phone, company_name, a.id as "ID договора", date_start, date_end, text
              from humanresource.client
                       left join dictionary.company c on client.company_id = c.company_id
                       left join projects.agreement a on client.client_id = a.id_client
              where client_id = _log_id) res;

END
$$;