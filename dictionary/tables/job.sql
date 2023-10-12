CREATE TABLE IF NOT EXISTS dictionary.job
(
    id serial                  NOT NULL
    CONSTRAINT pk_job PRIMARY KEY,
    name varchar(50)           NOT NULL ,
    hour_payment decimal(8, 2) NOT NULL
);