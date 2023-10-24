CREATE OR REPLACE FUNCTION history.history_job_insert_trigger()
    RETURNS TRIGGER AS
$$
DECLARE
    partition_name TEXT;
    start_date     DATE;
    end_date       DATE;
BEGIN

    start_date := DATE_TRUNC('month', NEW.ch_dt);
    end_date := start_date + INTERVAL '1 month';
    partition_name := 'history.job_' || TO_CHAR(start_date, 'YYYY_MM');

    IF (TO_REGCLASS(partition_name) IS NULL) THEN

        EXECUTE format('CREATE TABLE IF NOT EXISTS %I (CHECK (ch_dt >= %L AND ch_dt < %L)) INHERITS (history.job)',
                       partition_name, start_date, end_date);

    END IF;

    EXECUTE format('INSERT INTO %I VALUES ($1.*)', partition_name) USING NEW;

    RETURN NULL;

END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER history_job_insert
    BEFORE INSERT
    ON history.job
    FOR EACH ROW
EXECUTE PROCEDURE history.history_job_insert_trigger();
