CREATE TABLE IF NOT EXISTS history.report
(
    id           integer NOT NULL
        CONSTRAINT pk_report PRIMARY KEY,
    id_agreement integer NOT NULL,
    date_ending  date    NOT NULL,
    result       json    NOT NULL,
    ch_dt      TIMESTAMPTZ    NOT NULL
);