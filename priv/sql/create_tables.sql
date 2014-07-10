--DROP TABLE IF EXISTS shopper;

CREATE TABLE IF NOT EXISTS shopper (
  id 			BIGSERIAL 	PRIMARY KEY
  ,email 		VARCHAR(128) 	NOT NULL
  ,password		VARCHAR(128)	NOT NULL
  ,fname		VARCHAR(128)	NOT NULL
  ,lname		VARCHAR(128)	NOT NULL
  ,gender		BOOLEAN		NOT NULL
  ,delivery_address	BIGSERIAL	NOT NULL
  ,abode_address	BIGSERIAL       NOT NULL
  ,card_address		BIGSERIAL       NOT NULL
  ,city			VARCHAR(64)	NOT NULL
);

--DROP INDEX IF EXISTS shopper_ix;
CREATE INDEX IF NOT EXISTS shoper_ix ON shopper (email,password,delivery_address,abode_address,card_address);


SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'shopper' AND TABLE_TYPE = 'BASE TABLE';

CREATE TABLE IF NOT EXISTS shopper_address (
  id			BIGSERIAL	PRIMARY KEY
  ,addr_line1   	VARCHAR(128)    NOT NULL
  ,addr_line2   	VARCHAR(128)    NULL
  ,postcode     	VARCHAR(16)     NOT NULL
  ,city         	VARCHAR(64)     NOT NULL
  ,country              VARCHAR(64)     NULL
);

DROP INDEX IF EXISTS address_ix;
CREATE INDEX address_ix ON shopper_address (id,addr_line1,postcode,city);

ALTER TABLE shopper ADD CONSTRAINT delivery_address_fk FOREIGN KEY (delivery_address) REFERENCES shopper_address (id);
ALTER TABLE shopper ADD CONSTRAINT abode_address_fk FOREIGN KEY (abode_address) REFERENCES shopper_address (id);
ALTER TABLE shopper ADD CONSTRAINT card_address_fk FOREIGN KEY (card_address) REFERENCES shopper_address (id);




