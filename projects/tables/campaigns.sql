CREATE TABLE IF NOT EXISTS projects.campaigns
(
    id           integer        NOT NULL
        CONSTRAINT pk_campaigns PRIMARY KEY,
    id_agreement integer        NOT NULL,
    name         varchar(50)    NOT NULL,
    details      json           NOT NULL,
    budget       decimal(10, 2) NOT NULL,
    date_start   date           NOT NULL,
    date_end     date           NOT NULL
);

