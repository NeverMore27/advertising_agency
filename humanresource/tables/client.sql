CREATE TABLE IF NOT EXISTS humanresource.client
(
    client_id   integer      NOT NULL
        CONSTRAINT pk_client PRIMARY KEY,
    client_name varchar(255) NOT NULL,
    phone       varchar(11)
        CONSTRAINT uq_client_phone UNIQUE,
    company_id  integer,
    ch_employee integer      NOT NULL
);