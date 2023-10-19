CREATE TABLE IF NOT EXISTS history.promotion_materials
(
    id           integer      NOT NULL
        CONSTRAINT pk_pm PRIMARY KEY,
    id_agreement integer      NOT NULL,
    types        varchar(50)  NOT NULL,
    link         varchar(255) NOT NULL,
    detalis      varchar(255) NOT NULL,
    ch_dt      TIMESTAMPTZ    NOT NULL
);