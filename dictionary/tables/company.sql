CREATE TABLE IF NOT EXISTS dictionary.company
(
    company_id serial         NOT NULL
    CONSTRAINT pk_company PRIMARY KEY,
    company_name varchar(255) NOT NULL
);