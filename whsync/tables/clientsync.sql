CREATE TABLE IF NOT EXISTS whsync.clientsync
(
    log_id       BIGSERIAL                NOT NULL
        CONSTRAINT pk_clientsync PRIMARY KEY,
    client_id    BIGINT                   NOT NULL,
    name         VARCHAR(255)             NOT NULL,
    phone_number VARCHAR(11)              NOT NULL,

    company_id   integer                  NOT NULL,
    ch_employee  integer                  NOT NULL,
    sync_dt      TIMESTAMP WITH TIME ZONE NULL
);