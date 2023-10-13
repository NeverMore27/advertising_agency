CREATE TABLE IF NOT EXISTS dictionary.price
(
    id serial                  NOT NULL
    CONSTRAINT pk_price PRIMARY KEY,
    name varchar(50)           NOT NULL ,
    min_cost decimal(8, 2) NOT NULL
);