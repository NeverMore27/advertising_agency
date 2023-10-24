CREATE OR REPLACE FUNCTION delete_agreement(_agr_id integer)
RETURNS void AS
$$
BEGIN
  DELETE FROM projects.agreement
    WHERE id = _agr_id;
  DELETE from projects.promotion_materials
    WHERE  id_agreement = _agr_id;
END;
$$ LANGUAGE plpgsql;
