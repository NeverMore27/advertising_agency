CREATE OR REPLACE FUNCTION history.history_report_insert()
RETURNS TRIGGER AS $$
DECLARE
  v_partition_name TEXT;
BEGIN

  v_partition_name := 'history.report_' || TO_CHAR(NEW.ch_dt, 'YYYY_MM');

  IF NOT EXISTS (SELECT FROM pg_class WHERE relname = v_partition_name) THEN
    EXECUTE format('CREATE TABLE IF NOT EXISTS %I (CHECK (ch_dt >= DATE %L AND ch_dt < DATE %L)) INHERITS (history.report)',
                   v_partition_name, NEW.ch_dt, NEW.ch_dt + INTERVAL '1 month');
  END IF;

  EXECUTE format('INSERT INTO %I VALUES ($1.*)', v_partition_name) USING NEW;

  RETURN NULL;

END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER report_insert
BEFORE INSERT ON history.report
FOR EACH ROW
EXECUTE PROCEDURE history.history_report_insert();
