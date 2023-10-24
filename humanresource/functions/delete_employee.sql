CREATE OR REPLACE FUNCTION humanresource.delete_employee(_employee_id integer)
    RETURNS void AS
$$
BEGIN
    DELETE
    FROM connections.employee_project
    WHERE id_employee = _employee_id;
    DELETE
    FROM humanresource.employee
    WHERE employee_id = _employee_id;
    DELETE
    FROM connections.employee_job
    WHERE id_employee = _employee_id;
END;
$$ LANGUAGE plpgsql;
