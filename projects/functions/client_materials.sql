CREATE OR REPLACE FUNCTION humanresource.client_materials(_client_id BIGINT) RETURNS JSON
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
BEGIN
    RETURN JSONB_BUILD_OBJECT('data', json_agg(row_to_json(res)))
        FROM (select types, link, detalis
              from projects.promotion_materials p
                       join projects.agreement a on a.id = p.id_agreement
                       join humanresource.client c on a.id_client = c.client_id
              where c.client_id = _client_id) res;

END
$$;