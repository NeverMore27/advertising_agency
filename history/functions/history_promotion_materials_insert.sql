CREATE OR REPLACE FUNCTION history.history_promotion_materials_insert()
    RETURNS TRIGGER AS
$$
DECLARE
    v_partition_name TEXT;
BEGIN

    v_partition_name := 'history.promotion_materials_' || TO_CHAR(NEW.ch_dt, 'YYYY_MM');

    IF NOT EXISTS (SELECT FROM pg_class WHERE relname = v_partition_name) THEN
        EXECUTE format(
                'CREATE TABLE IF NOT EXISTS %I (CHECK (ch_dt >= DATE %L AND ch_dt < DATE %L)) INHERITS (history.promotion_materials)',
                v_partition_name, NEW.ch_dt, NEW.ch_dt + INTERVAL '1 month');
    END IF;

    EXECUTE format('INSERT INTO %I VALUES ($1.*)', v_partition_name) USING NEW;

    RETURN NULL;

END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER promotion_materials_insert
    BEFORE INSERT
    ON history.promotion_materials
    FOR EACH ROW
EXECUTE PROCEDURE history.history_promotion_materials_insert();
