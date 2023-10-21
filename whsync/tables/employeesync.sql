CREATE TABLE IF NOT EXISTS whsync.employeessync
(
    log_id          BIGSERIAL                NOT NULL
        CONSTRAINT pk_employeessync PRIMARY KEY,
    employee_id     BIGINT                   NOT NULL,
    name            VARCHAR(255)             NOT NULL,
    phone_number    VARCHAR(11)              NOT NULL,

    payment_detalis varchar(255)             NOT NULL,
    sync_dt         TIMESTAMP WITH TIME ZONE NULL
);