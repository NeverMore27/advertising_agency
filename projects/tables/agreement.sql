CREATE TABLE IF NOT EXISTS project.agreement
(
    id         integer NOT NULL
        CONSTRAINT pk_agr PRIMARY KEY,
    id_client  integer NOT NULL,
    date_start date    NOT NULL,
    date_end   date    NOT NULL,
    text       json    NOT NULL,

);