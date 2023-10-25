CREATE OR REPLACE FUNCTION history.deletepartitions(_name_inh TEXT) RETURNS JSONB
    SECURITY DEFINER
    LANGUAGE plpgsql
AS
$$
DECLARE
    _name_part VARCHAR(64)[];

BEGIN

SELECT ARRAY_AGG(c.relname)
         into _name_part
                   FROM pg_catalog.pg_inherits i
                            INNER JOIN pg_catalog.pg_class c ON c.oid = i.inhrelid
                   WHERE split_part(c.relname::text, concat(_name_inh, '_'), 2) <=
                         TO_CHAR((now() - INTERVAL '3 month')::date, 'YYYY_MM')
                     AND i.inhparent::REGCLASS::TEXT = CONCAT('history.', _name_inh) ;

 IF (ARRAY_LENGTH(_name_part, 1) IS NULL)
    THEN
        RETURN public.errmessage(_errcode := 'history.deletepartitions',
                                 _msg     := 'Таблиц для удаления нет!',
                                 _detail  := 'Нет таблиц за определенную дату');
    END IF;

    FOR i IN 1..ARRAY_LENGTH(_name_part, 1)
        LOOP
             EXECUTE FORMAT('DROP TABLE %I', _name_part[i]);
        END LOOP;
 RETURN JSONB_BUILD_OBJECT('data', NULL);

END
$$;