CREATE TABLE IF NOT EXISTS humanresource.employee
(
    employee_id     integer      NOT NULL
        CONSTRAINT pk_employee PRIMARY KEY,
    employee_name   varchar(255) NOT NULL,
    phone           varchar(11)
        CONSTRAINT uq_employee_phone UNIQUE,
    payment_detalis varchar(255) NOT NULL
)