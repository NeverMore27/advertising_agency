CREATE TABLE IF NOT EXISTS  projects.project
(
    project_id integer      NOT NULL
        CONSTRAINT pk_project PRIMARY KEY,
    name       varchar(255) NOT NULL,
    dt_start   timestamp    NOT NULL,
    status     varchar(50)  NOT NULL,

);