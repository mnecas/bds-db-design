
DROP SCHEMA IF EXISTS bpc_bds CASCADE;
CREATE SCHEMA IF NOT EXISTS bpc_bds;

CREATE TABLE IF NOT EXISTS bpc_bds.person_type (
  person_type_id SERIAL NOT NULL,
  type VARCHAR(45) NOT NULL,
  PRIMARY KEY (person_type_id));

CREATE UNIQUE INDEX person_type_id_UNIQUE ON bpc_bds.person_type (person_type_id ASC);

CREATE TABLE IF NOT EXISTS bpc_bds.person (
  person_id SERIAL NOT NULL,
  person_type_id INT NOT NULL,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  password VARCHAR(45) NOT NULL,
  username VARCHAR(45) NOT NULL,
  date_of_birth DATE NOT NULL,
  PRIMARY KEY (person_id),
  CONSTRAINT fk_user_user_type1
    FOREIGN KEY (person_type_id)
    REFERENCES bpc_bds.person_type (person_type_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE UNIQUE INDEX username_UNIQUE ON bpc_bds.person (username ASC);

CREATE TABLE IF NOT EXISTS bpc_bds.delivery (
  delivery_id SERIAL NOT NULL,
  person_id INT NOT NULL,
  driver_id INT NOT NULL,
  arrival TIMESTAMP NULL,
  delivery_fee INT NULL,
  PRIMARY KEY (delivery_id),
  CONSTRAINT fk_delivery_person1
    FOREIGN KEY (person_id)
    REFERENCES bpc_bds.person (person_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_delivery_person2
    FOREIGN KEY (driver_id)
    REFERENCES bpc_bds.person (person_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE UNIQUE INDEX delivery_id_UNIQUE ON bpc_bds.delivery (delivery_id ASC);

CREATE TABLE IF NOT EXISTS bpc_bds.address (
  address_id SERIAL NOT NULL,
  city VARCHAR(45) NOT NULL,
  street VARCHAR(45) NOT NULL,
  street_number INT NOT NULL,
  zip VARCHAR(20) NOT NULL,
  description VARCHAR(45) NULL,
  floor INT NULL,
  PRIMARY KEY (address_id));

CREATE UNIQUE INDEX address_id_UNIQUE ON bpc_bds.address (address_id ASC);

CREATE TABLE IF NOT EXISTS bpc_bds.cuisine (
  cuisine_id SERIAL NOT NULL,
  cuisine_name VARCHAR(45) NOT NULL,
  PRIMARY KEY (cuisine_id));

CREATE UNIQUE INDEX cuisine_id_UNIQUE ON bpc_bds.cuisine (cuisine_id ASC);

CREATE TABLE IF NOT EXISTS bpc_bds.restaurant (
  restaurant_id SERIAL NOT NULL,
  address_id INT NOT NULL,
  name VARCHAR(45) NOT NULL,
  cuisine_id INT NOT NULL,
  PRIMARY KEY (restaurant_id),
  CONSTRAINT fk_restaurant_address1
    FOREIGN KEY (address_id)
    REFERENCES bpc_bds.address (address_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_restaurant_cuisine1
    FOREIGN KEY (cuisine_id)
    REFERENCES bpc_bds.cuisine (cuisine_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE UNIQUE INDEX restaurant_id_UNIQUE ON bpc_bds.restaurant (restaurant_id ASC);

CREATE TABLE IF NOT EXISTS bpc_bds.dish (
  dish_id SERIAL NOT NULL,
  name VARCHAR(45) NOT NULL,
  PRIMARY KEY (dish_id));

CREATE UNIQUE INDEX dish_id_UNIQUE ON bpc_bds.dish (dish_id ASC);

CREATE TABLE IF NOT EXISTS bpc_bds.dish_has_restaurant (
  dish_id INT NOT NULL,
  restaurant_id INT NOT NULL,
  price FLOAT NOT NULL,
  PRIMARY KEY (restaurant_id, dish_id),
  CONSTRAINT fk_dish_has_restaurant_dish1
    FOREIGN KEY (dish_id)
    REFERENCES bpc_bds.dish (dish_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_dish_has_restaurant_restaurant1
    FOREIGN KEY (restaurant_id)
    REFERENCES bpc_bds.restaurant (restaurant_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE TABLE IF NOT EXISTS bpc_bds.review (
  review_id SERIAL NOT NULL,
  person_id INT NOT NULL,
  restaurant_id INT NULL,
  dish_id INT NULL,
  driver_id INT NULL,
  rating SMALLINT NOT NULL,
  text VARCHAR(500) NULL,
  PRIMARY KEY (review_id),
  CONSTRAINT fk_review_user1
    FOREIGN KEY (person_id)
    REFERENCES bpc_bds.person (person_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_review_dish_has_restaurant1
    FOREIGN KEY (dish_id , restaurant_id)
    REFERENCES bpc_bds.dish_has_restaurant (dish_id , restaurant_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_review_person1
    FOREIGN KEY (driver_id)
    REFERENCES bpc_bds.person (person_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE UNIQUE INDEX review_id_UNIQUE ON bpc_bds.review (review_id ASC);

CREATE TABLE IF NOT EXISTS bpc_bds.car (
  car_id SERIAL NOT NULL,
  person_id INT NOT NULL,
  plate VARCHAR(45) NOT NULL,
  type VARCHAR(45) NULL,
  brand VARCHAR(45) NULL,
  PRIMARY KEY (car_id),
  CONSTRAINT fk_car_person1
    FOREIGN KEY (person_id)
    REFERENCES bpc_bds.person (person_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE UNIQUE INDEX car_id_UNIQUE ON bpc_bds.car (car_id ASC);

CREATE TABLE IF NOT EXISTS bpc_bds.shift (
  shift_id SERIAL NOT NULL,
  start_time TIMESTAMP NOT NULL,
  end_time TIMESTAMP NOT NULL,
  PRIMARY KEY (shift_id));

CREATE UNIQUE INDEX shift_id_UNIQUE ON bpc_bds.shift (shift_id ASC);

CREATE TABLE IF NOT EXISTS bpc_bds.user_has_address (
  person_id INT NOT NULL,
  address_id INT NOT NULL,
  PRIMARY KEY (person_id, address_id),
  CONSTRAINT fk_user_has_address_user
    FOREIGN KEY (person_id)
    REFERENCES bpc_bds.person (person_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_user_has_address_address1
    FOREIGN KEY (address_id)
    REFERENCES bpc_bds.address (address_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE TABLE IF NOT EXISTS bpc_bds.driver_has_shift (
  shift_id INT NOT NULL,
  person_id INT NOT NULL,
  PRIMARY KEY (shift_id, person_id),
  CONSTRAINT fk_driver_has_shift_shift1
    FOREIGN KEY (shift_id)
    REFERENCES bpc_bds.shift (shift_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_driver_has_shift_person1
    FOREIGN KEY (person_id)
    REFERENCES bpc_bds.person (person_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE TABLE IF NOT EXISTS bpc_bds.delivery_has_dish_has_restaurant (
  delivery_id INT NOT NULL,
  dish_id INT NOT NULL,
  restaurant_id INT NOT NULL,
  user_requirements VARCHAR(200) NULL,
  PRIMARY KEY (delivery_id, dish_id, restaurant_id),
  CONSTRAINT fk_order_has_dish_has_restaurant_order1
    FOREIGN KEY (delivery_id)
    REFERENCES bpc_bds.delivery (delivery_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_order_has_dish_has_restaurant_dish_has_restaurant1
    FOREIGN KEY (dish_id , restaurant_id)
    REFERENCES bpc_bds.dish_has_restaurant (dish_id , restaurant_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE TABLE IF NOT EXISTS bpc_bds.contact (
  contact_id SERIAL NOT NULL,
  person_id INT NOT NULL,
  type VARCHAR(45) NOT NULL,
  value VARCHAR(45) NOT NULL,
  PRIMARY KEY (contact_id),
  CONSTRAINT fk_contact_person1
    FOREIGN KEY (person_id)
    REFERENCES bpc_bds.person (person_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE UNIQUE INDEX contact_id_UNIQUE ON bpc_bds.contact (contact_id ASC);

