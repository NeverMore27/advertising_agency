create table if not exists history.price

(
    id       serial        NOT NULL
        CONSTRAINT pk_price PRIMARY KEY,
    name     varchar(50)   NOT NULL,
    min_cost decimal(8, 2) NOT NULL,
    ch_dt    TIMESTAMPTZ   NOT NULL
);