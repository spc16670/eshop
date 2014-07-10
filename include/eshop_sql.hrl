
-define(POOL,eshop_utls:pool_name()).

-define(SCHEMA,eshop_utls:get_env(project)).

-define(CREATE_SCHEMA,
    "CREATE SCHEMA IF NOT EXISTS " ++ ?SCHEMA ++ ";"
  ).

-define(DROP_SCHEMA,
    "DROP SCHEMA " ++ ?SCHEMA ++ " CASCADE;"
  ).

-define(CREATE_SHOPPER,
    "CREATE TABLE IF NOT EXISTS " ++ ?SCHEMA ++ ".shopper (" 		
      "id                    BIGSERIAL       PRIMARY KEY"	
      ",email                VARCHAR(128)    NOT NULL"	
      ",password             VARCHAR(128)    NOT NULL"
      ",fname                VARCHAR(128)    NOT NULL"
      ",lname                VARCHAR(128)    NOT NULL"
      ",gender               VARCHAR(1)      NOT NULL"
      ",delivery_address     BIGSERIAL       REFERENCES shopper_address (id)"
      ",abode_address        BIGSERIAL       REFERENCES shopper_address (id)"
      ",card_address         BIGSERIAL       REFERENCES shopper_address (id)"
    ");"
  ).

-define(INDEX_EXISTS(Name),
    "SELECT 1 FROM pg_class C "
    "JOIN pg_namespace N ON N.oid = C.relnamespace "
    "WHERE C.relname = '" ++ Name ++ "' AND N.nspname = '" ++ ?SCHEMA ++ "';"
  ).

-define(CREATE_SHOPPER_IX,
    "CREATE INDEX shopper_ix ON " ++ ?SCHEMA ++ ".shopper ("
      "email"
      ",password"
      ",delivery_address"
      ",abode_address"
      ",card_address"
    ");"
  ).

-define(CREATE_SHOPPER_ADDRESS,
    "CREATE TABLE IF NOT EXISTS " ++ ?SCHEMA ++ ".shopper_address ("
      "id                    BIGSERIAL       NOT NULL	PRIMARY KEY"
      ",addr_line1           VARCHAR(128)    NOT NULL"
      ",addr_line2           VARCHAR(128)    NULL"
      ",postcode             VARCHAR(16)     NOT NULL"
      ",city                 VARCHAR(64)     NOT NULL"
      ",country              VARCHAR(64)     NULL"
    ");"
  ).
 
-define(CREATE_SHOPPER_ADDRESS_IX,
    "CREATE INDEX shopper_address_ix ON " ++ ?SCHEMA ++ ".shopper_address ("
        "id"
        ",addr_line1"
        ",addr_line2"
        ",postcode"
        ",city"
     ");"
  ).

-define(INSERT_ADDRESS(L1,L2,P,CT,CO),
    "INSERT INTO " ++ ?SCHEMA ++ ".shopper_address "
    "(addr_line1,addr_line2,postcode,city,country) VALUES ("
      "'" ++ L1 ++ "','" ++ L2 ++ "','" ++ P ++ "','" ++ CT ++ "','" ++ CO ++ "'"
    ") RETURNING id;"
  ).

-define(INSERT_SHOPPER(E,P,F,L,G,A),
    "INSERT INTO " ++ ?SCHEMA ++ ".shopper (email,password,fname,lname,gender,"
      "delivery_address,abode_address,card_address) VALUES ("
      "'" ++ E ++ "','" ++ P ++ "','" ++ F ++ "','" ++ L ++ "','" ++ G ++ "',"
      "" ++ A ++ "," ++ A ++ "," ++ A ++ ""
    ");"
  ).

-define(UPDATE(T,C,V),
    "UPDATE " ++ ?SCHEMA ++ "." ++ T ++ " SET " ++ C ++ " = " ++ V ++ ";"
  ).

-define(SELECT_SHOPPER(E),
    "SELECT id, email, password, fname, lname, gender FROM " 
    ++ ?SCHEMA ++ ".shopper WHERE email = '" ++ E ++ "';"
  ).

-define(SELECT_SHOPPER_ADDRESS(E),
    "SELECT * FROM " ++ ?SCHEMA ++ ".shopper S JOIN " ++ ?SCHEMA 
    ++ ".shopper_address A ON S.id = A.id WHERE S.email = '" ++ E ++ "';"
  ).


