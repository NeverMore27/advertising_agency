CREATE OR REPLACE FUNCTION humanresource.get_project_client(_client_id BIGINT) RETURNS JSON
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
DECLARE
    _res JSONB;
BEGIN
    RETURN JSONB_BUILD_OBJECT('data', json_agg(row_to_json(res)))
        FROM (SELECT client_name, phone, company_name, a.id as "ID договора", date_start, date_end, text
              FROM humanresource.client cl
                       JOIN dictionary.company c on client.company_id = c.company_id
                      JOIN projects.agreement a on client.client_id = a.id_client
              WHERE client_id = COALESCE(_client_id,cl.client_id )) res;

END
$$;