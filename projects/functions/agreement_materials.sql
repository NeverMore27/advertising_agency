CREATE OR REPLACE FUNCTION humanresource.agreement_materials(_log_id BIGINT) RETURNS JSON
    LANGUAGE plpgsql
    SECURITY DEFINER
AS
$$
DECLARE
    _res JSONB;
BEGIN
    RETURN JSONB_BUILD_OBJECT('data', json_agg(row_to_json(res)))
        FROM (select types, link, detalis
              from  projects.promotion_materials m
              where m.id_agreement = _log_id) res;

END
$$;