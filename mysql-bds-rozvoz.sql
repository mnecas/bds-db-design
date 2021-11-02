
DROP SCHEMA IF EXISTS `bpc-bds` ;
CREATE SCHEMA IF NOT EXISTS `bpc-bds` DEFAULT CHARACTER SET utf8 ;
USE `bpc-bds` ;
CREATE TABLE IF NOT EXISTS `bpc-bds`.`person_type` (
  `person_type_id` INT NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`person_type_id`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `person_type_id_UNIQUE` ON `bpc-bds`.`person_type` (`person_type_id` ASC);

CREATE TABLE IF NOT EXISTS `bpc-bds`.`person` (
  `person_id` INT NOT NULL AUTO_INCREMENT,
  `person_type_id` INT NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `username` VARCHAR(45) NOT NULL,
  `date_of_birth` DATE NOT NULL,
  PRIMARY KEY (`person_id`),
  CONSTRAINT `fk_user_user_type1`
    FOREIGN KEY (`person_type_id`)
    REFERENCES `bpc-bds`.`person_type` (`person_type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `username_UNIQUE` ON `bpc-bds`.`person` (`username` ASC);

CREATE TABLE IF NOT EXISTS `bpc-bds`.`delivery` (
  `delivery_id` INT NOT NULL AUTO_INCREMENT,
  `person_id` INT NOT NULL,
  `driver_id` INT NOT NULL,
  `arrival` DATETIME NULL,
  `delivery_fee` INT NULL,
  PRIMARY KEY (`delivery_id`),
  CONSTRAINT `fk_delivery_person1`
    FOREIGN KEY (`person_id`)
    REFERENCES `bpc-bds`.`person` (`person_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION),
  CONSTRAINT `fk_delivery_person2`
    FOREIGN KEY (`driver_id`)
    REFERENCES `mydb`.`person` (`person_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `delivery_id_UNIQUE` ON `bpc-bds`.`delivery` (`delivery_id` ASC);

CREATE TABLE IF NOT EXISTS `bpc-bds`.`address` (
  `address_id` INT NOT NULL AUTO_INCREMENT,
  `city` VARCHAR(45) NOT NULL,
  `street` VARCHAR(45) NOT NULL,
  `street_number` INT NOT NULL,
  `zip` INT NOT NULL,
  `description` VARCHAR(45) NULL,
  `floor` INT NULL,
  PRIMARY KEY (`address_id`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `address_id_UNIQUE` ON `bpc-bds`.`address` (`address_id` ASC);

CREATE TABLE IF NOT EXISTS `bpc-bds`.`cuisine` (
  `cuisine_id` INT NOT NULL AUTO_INCREMENT,
  `cuisine_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`cuisine_id`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `cuisine_id_UNIQUE` ON `bpc-bds`.`cuisine` (`cuisine_id` ASC);

CREATE TABLE IF NOT EXISTS `bpc-bds`.`restaurant` (
  `restaurant_id` INT NOT NULL AUTO_INCREMENT,
  `address_id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `cuisine_id` INT NOT NULL,
  PRIMARY KEY (`restaurant_id`),
  CONSTRAINT `fk_restaurant_address1`
    FOREIGN KEY (`address_id`)
    REFERENCES `bpc-bds`.`address` (`address_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_restaurant_cuisine1`
    FOREIGN KEY (`cuisine_id`)
    REFERENCES `bpc-bds`.`cuisine` (`cuisine_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `restaurant_id_UNIQUE` ON `bpc-bds`.`restaurant` (`restaurant_id` ASC);

CREATE TABLE IF NOT EXISTS `bpc-bds`.`dish` (
  `dish_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`dish_id`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `dish_id_UNIQUE` ON `bpc-bds`.`dish` (`dish_id` ASC);

CREATE TABLE IF NOT EXISTS `bpc-bds`.`dish_has_restaurant` (
  `dish_id` INT NOT NULL,
  `restaurant_id` INT NOT NULL,
  `price` FLOAT NOT NULL,
  PRIMARY KEY (`restaurant_id`, `dish_id`),
  CONSTRAINT `fk_dish_has_restaurant_dish1`
    FOREIGN KEY (`dish_id`)
    REFERENCES `bpc-bds`.`dish` (`dish_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_dish_has_restaurant_restaurant1`
    FOREIGN KEY (`restaurant_id`)
    REFERENCES `bpc-bds`.`restaurant` (`restaurant_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `bpc-bds`.`review` (
  `review_id` INT NOT NULL AUTO_INCREMENT,
  `person_id` INT NOT NULL,
  `restaurant_id` INT NULL,
  `dish_id` INT NULL,
  `driver_id` INT NULL,
  `rating` TINYINT NOT NULL,
  `text` TEXT(500) NULL,
  PRIMARY KEY (`review_id`),
  CONSTRAINT `fk_review_user1`
    FOREIGN KEY (`person_id`)
    REFERENCES `bpc-bds`.`person` (`person_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_review_dish_has_restaurant1`
    FOREIGN KEY (`dish_id` , `restaurant_id`)
    REFERENCES `bpc-bds`.`dish_has_restaurant` (`dish_id` , `restaurant_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_review_person1`
    FOREIGN KEY (`driver_id`)
    REFERENCES `bpc-bds`.`person` (`person_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `review_id_UNIQUE` ON `bpc-bds`.`review` (`review_id` ASC);

CREATE TABLE IF NOT EXISTS `bpc-bds`.`car` (
  `car_id` INT NOT NULL AUTO_INCREMENT,
  `person_id` INT NOT NULL,
  `plate` VARCHAR(45) NOT NULL,
  `type` VARCHAR(45) NULL,
  `brand` VARCHAR(45) NULL,
  PRIMARY KEY (`car_id`),
  CONSTRAINT `fk_car_person1`
    FOREIGN KEY (`person_id`)
    REFERENCES `bpc-bds`.`person` (`person_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `car_id_UNIQUE` ON `bpc-bds`.`car` (`car_id` ASC);

CREATE TABLE IF NOT EXISTS `bpc-bds`.`shift` (
  `shift_id` INT NOT NULL AUTO_INCREMENT,
  `start_time` DATETIME NOT NULL,
  `end_time` DATETIME NOT NULL,
  PRIMARY KEY (`shift_id`))
ENGINE = InnoDB;

CREATE UNIQUE INDEX `shift_id_UNIQUE` ON `bpc-bds`.`shift` (`shift_id` ASC);

CREATE TABLE IF NOT EXISTS `bpc-bds`.`user_has_address` (
  `person_id` INT NOT NULL,
  `address_id` INT NOT NULL,
  PRIMARY KEY (`person_id`, `address_id`),
  CONSTRAINT `fk_user_has_address_user`
    FOREIGN KEY (`person_id`)
    REFERENCES `bpc-bds`.`person` (`person_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_has_address_address1`
    FOREIGN KEY (`address_id`)
    REFERENCES `bpc-bds`.`address` (`address_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `bpc-bds`.`driver_has_shift` (
  `shift_id` INT NOT NULL,
  `person_id` INT NOT NULL,
  PRIMARY KEY (`shift_id`, `person_id`),
  CONSTRAINT `fk_driver_has_shift_shift1`
    FOREIGN KEY (`shift_id`)
    REFERENCES `bpc-bds`.`shift` (`shift_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_driver_has_shift_person1`
    FOREIGN KEY (`person_id`)
    REFERENCES `bpc-bds`.`person` (`person_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `bpc-bds`.`delivery_has_dish_has_restaurant` (
  `delivery_id` INT NOT NULL,
  `dish_id` INT NOT NULL,
  `restaurant_id` INT NOT NULL,
  `user_requirements` TEXT(200) NULL,
  PRIMARY KEY (`delivery_id`, `dish_id`, `restaurant_id`),
  CONSTRAINT `fk_order_has_dish_has_restaurant_order1`
    FOREIGN KEY (`delivery_id`)
    REFERENCES `bpc-bds`.`delivery` (`delivery_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_has_dish_has_restaurant_dish_has_restaurant1`
    FOREIGN KEY (`dish_id` , `restaurant_id`)
    REFERENCES `bpc-bds`.`dish_has_restaurant` (`dish_id` , `restaurant_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `bpc-bds`.`contact` (
  `contact_id` INT NOT NULL AUTO_INCREMENT,
  `person_id` INT NOT NULL,
  `type` VARCHAR(45) NOT NULL,
  `value` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`contact_id`),
  CONSTRAINT `fk_contact_person1`
    FOREIGN KEY (`person_id`)
    REFERENCES `bpc-bds`.`person` (`person_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE UNIQUE INDEX `contact_id_UNIQUE` ON `bpc-bds`.`contact` (`contact_id` ASC);

