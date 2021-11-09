
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



INSERT INTO bpc_bds.person_type (type) 
VALUES
 ('User'),
 ('Driver'),
 ('Admin'),
 ('Maintainer'),
 ('Tester');

INSERT INTO bpc_bds.person (first_name,last_name,password,date_of_birth,username,person_type_id)
VALUES
  ('Solomon','Salažar','OKP78ELK6RI','1983-01-04','underhello',1),
  ('Hanae','Gamble','MVM83HHY4HO','1998-04-27','failingoveralls',1),
  ('Uma','Hesteč','OWH44XSU5WJ','1987-10-27','beansstripped',2),
  ('Silas','Sullivan','SUS26KUU6YL','2006-05-11','sourdoughgarnish',2),
  ('Kaitlin','Hogaí','UCN59IOP3UA','2008-06-30','koreanbew',1),
  ('Jenna','Wheeler','EXY25FCH2HW','1986-01-27','unrulyscene',1),
  ('Buckminster','Přince','SRQ89TKD1BQ','1990-07-10','beetsmighty',2),
  ('Candice','Macias','PKC49OPB7HO','1981-01-26','blanketnearly',2),
  ('Kasper','Donaldson','WKC77EYO0HU','2005-02-13','paragraphlonely',1),
  ('Uriah','Nichols','PVV75CKU7TL','1978-03-11','generalold',1),
  ('Harper','Levy','DWU55HDF3AV','1981-09-06','justuamerat.ca',2),
  ('Mollie','Lloyd','UGK33RLW6LW','1981-02-05','coyotearmed',2),
  ('Joelle','Becker','HSC38GSH7EW','2006-06-14','salestax',2),
  ('Dalton','Baxter','YYG86DPM2VQ','2010-12-14','drayhog',2),
  ('Chadwick','Solis','MEY54GDO4GR','1975-03-04','noduleominous',2),
  ('Gray','Montoya','SYM63DWO1AD','1980-07-05','metalhandshake',2),
  ('Cedric','Hays','TPP62OOT5MF','1999-09-10','crackerssteak',2),
  ('Kuame','Townsend','DKS19YET5FP','2006-09-27','shellbedstraw',2),
  ('Blossom','Dixon','SFI88IFN0EV','1982-10-25','semtristique.co.uk',2),
  ('Paul','Frank','AQT63RUH5YV','1988-05-16','remaininghosiery',2),
  ('Nolan','Fischer','SNW26TQU3GD','1994-11-11','passelclunk',1),
  ('Charde','Hood','CVH89XHJ5LI','1982-02-26','mutationvirtuous',1),
  ('Asher','Wiggins','QCB11PGJ9RK','1989-05-15','muslinassorted',2),
  ('Len','Moody','TML57IJV2EE','2000-04-18','shutnative',2),
  ('Moana','Brown','KEX12BLL2JK','2008-01-14','greatcotton',1),
  ('Blaze','Coleman','FLT55ZNH8SX','2014-06-19','inningcheater',1),
  ('Zorita','Hammond','FTQ04CFM6GL','1975-12-27','esuetproin.edu',2),
  ('Willow','Stephens','ALH53NVJ2VZ','2006-01-15','gardenhopeless',2),
  ('Ramona','Turner','MPW50VGN7QI','1989-11-29','madlyhumburger',1),
  ('Kiayada','White','MHV14XJH7SD','2016-09-03','picayunepanties',1),
  ('Zane','Roy','XMW17SOH6VW','1974-11-22','voicelessfailure',2),
  ('Russell','Neal','KGY73HZS4HT','1981-07-30','bellowneedy',2),
  ('Cheryl','Cash','KPZ75SUI0HQ','2011-05-12','vocalrevered',1),
  ('Herrod','Harding','XZJ87GPS3PH','2011-10-18','hungryplover',1),
  ('Lesley','Hurley','VBH75CJU2IW','1980-10-13','articlerecording',2),
  ('Peter','Newman','USI27DSD5MH','2008-03-26','ranbehave',2),
  ('Bevis','Holden','QNC85YMN6XL','1989-04-18','lobortig',1),
  ('Galvin','Benton','AQX83EFY1NH','1996-07-21','wardroomparcel',1),
  ('Destiny','Gonzales','RMU75WEI7SR','1995-01-08','torpidbowed',2),
  ('Hayfa','Hunt','YRT74RIQ9IZ','2013-08-23','macedonianflakey',2),
  ('Wing','Hurst','RYB11BHA6TC','2009-10-01','unfinishedbeneficent',1),
  ('Solomon','Hood','VOE02OIU8VT','2018-06-11','variationsanction',1),
  ('Adam','Sullivan','EXG16FQJ5MR','1982-05-05','hypothesisunhelpful',2),
  ('Oliver','Harmon','LON46YIK1SC','1974-10-06','boatnoon',2),
  ('Nash','Bass','QLK76HXL3KP','1987-04-05','arousedclerk',1),
  ('Jillian','Sawyer','GFW66YLS1XY','1985-03-12','gateaudiscreet',1),
  ('Alan','Lambert','RVV36QWS9MY','1982-09-08','sweatycluster',2),
  ('Jena','Reed','QPK32IUS9WX','1982-11-05','mourningsmoggy',2),
  ('Hadassah','Monroe','XDQ71FWN8DX','1991-11-12','hardcoati',1),
  ('Cooper','Blanchard','USA25NWF8HV','2007-01-07','alivevolunteer',1),
  ('Maxine','Mason','IYZ81ONC9YE','1990-04-23','teapurpose',3),
  ('Kylie','Shelton','NCU72XXI5YD','1987-04-09','suspendiss.ca',3),
  ('Garth','Hale','YEB13GLY0IQ','1974-04-05','criticizemistake',4),
  ('Dale','Dickerson','RAY76LXM4CP','1994-04-15','gregariousalderman',4),
  ('Amela','Hickman','ISV43QVR4UJ','1993-07-29','garlickyfaraway',3);


INSERT INTO bpc_bds.car (person_id, plate, type, brand)
VALUES
 (3, '7DMW960', 'Sedan', 'Fiat'),
 (4, 'BGY4540', 'Sedan', 'Peugeot'),
 (7, '4SAH241', NULL, 'Volvo'),
 (8, '6JIM110', 'Sedan', 'Volkswagen'),
 (11, 'FIRE31', NULL, 'Fiat'),
 (12, '7ZEK546', NULL, 'Volvo');

INSERT INTO bpc_bds.shift (start_time, end_time)
VALUES
 ('2020-01-01 08:00:00', '2020-01-01 18:00:00'),
 ('2020-01-02 08:00:00', '2020-01-02 18:00:00'),
 ('2020-01-03 08:00:00', '2020-01-03 18:00:00'),
 ('2020-01-04 08:00:00', '2020-01-04 18:00:00'),
 ('2020-01-05 08:00:00', '2020-01-05 18:00:00'),
 ('2020-01-06 08:00:00', '2020-01-06 18:00:00'),
 ('2020-01-07 08:00:00', '2020-01-07 18:00:00');

INSERT INTO bpc_bds.driver_has_shift (person_id, shift_id)
VALUES 
(1, 1),
(1, 2),
(1, 3),
(2, 1),
(2, 2),
(2, 3);

INSERT INTO bpc_bds.cuisine (cuisine_name)
VALUES 
 ('Italian'),
 ('Czech'),
 ('American'),
 ('Korean'),
 ('Japanese'),
 ('Chinese'),
 ('Turkish'),
 ('Vietnamese'),
 ('Slovak');


INSERT INTO bpc_bds.address (zip,street_number,floor,street,city)
VALUES
  ('37672',166,4,'Las Palmas','Bạc Liêu'),
  ('38691',480,7,'Lower Hutt','Kursk'),
  ('40306',498,10,'Joinville','Caerphilly'),
  ('203767',239,8,'Owerri','Galway'),
  ('77605',377,1,'Newark','Westport'),
  ('31004',296,8,'Baddeck','Quetta'),
  ('46-446',348,1,'Sicuani','Ereğli'),
  ('41312',308,5,'Jundiaí','Chapecó'),
  ('621292',418,9,'Rio Grande','Telde'),
  ('V6 2VG',373,0,'Raurkela','Mastung'),
  ('24536',412,4,'Lagos','Palangka Raya'),
  ('728851',363,5,'Blenheim','Nelson'),
  ('98047',250,1,'Balikpapan','Dublin'),
  ('21293',89,1,'Quillota','Mercedes'),
  ('35314',340,0,'Logroño','Greymouth'),
  ('352553',435,8,'Idaho Falls','Langenhagen'),
  ('63327',397,10,'Mustafakemalpaşa','Wakefield'),
  ('48556',453,5,'Niort','Aguazul'),
  ('7511 DE',95,5,'Albisola Superiore','Matamoros'),
  ('2334',133,7,'Crato','Peñalolén'),
  ('18641',347,6,'Pamplona','Ruette'),
  ('85450',291,5,'Jamshedpur','Piotrków Trybunalski'),
  ('YB5 7QL',477,4,'Sechura','Seogwipo'),
  ('46150',308,8,'Guápiles','Saint-Malo'),
  ('656547',347,5,'Cairns','Curaco de Vélez'),
  ('26946',130,3,'Tongyeong','San Chirico Nuovo'),
  ('572414',39,5,'Birecik','Montes Claros'),
  ('48973',351,1,'Cajamarca','Ostrowiec Świętokrzyski'),
  ('469478',78,6,'Iksan','Mercedes'),
  ('12-852',22,4,'Volgograd','Bắc Kạn'),
  ('23222-411',346,4,'Wadgassen','Jönköping'),
  ('157384',448,8,'Jeju','Saratov'),
  ('317376',479,6,'Auxerre','Nicoya'),
  ('3127',37,10,'Seogwipo','Tuyên Quang'),
  ('428525',463,7,'Bad Kreuznach','Asan'),
  ('17574',180,1,'March','Söderhamn'),
  ('32509',386,3,'Fumal','Stargard Szczeciński'),
  ('94615',487,1,'Timon','Franeker'),
  ('2484',412,5,'Tomsk','Vetlanda'),
  ('3269',70,2,'Borghetto di Vara','Ełk'),
  ('75769-306',120,6,'Pabianice','Skovorodino'),
  ('51572',180,0,'Koszalin','Dehradun'),
  ('857664',332,1,'Iquitos','Yahyalı'),
  ('34563-13610',224,7,'Bắc Kạn','Amersfoort'),
  ('39997',306,3,'Pachuca','Arequipa'),
  ('871653',446,10,'Villahermosa','Mataram'),
  ('75386',41,7,'Alingsås','Puerto López'),
  ('4446',472,3,'Devonport','Columbia'),
  ('178651',457,4,'Landeck','Barranca'),
  ('T3Y 5L5',442,3,'Chungju','Lima'),
  ('157626',193,2,'Arequipa','Morwell'),
  ('04673',404,5,'Halisahar','Manavgat'),
  ('4922',104,9,'Medio Atrato','Khotkovo'),
  ('2340',360,6,'Katsina','Belfast'),
  ('12119',455,2,'Sint-Lambrechts-Woluwe','Charlottetown'),
  ('61164-295',154,1,'Patos','Whitehorse'),
  ('808758',371,7,'Strausberg','Tirrases'),
  ('27866',386,0,'Graz','Jecheon'),
  ('0054 CP',282,3,'FlŽnu','Hòa Mạc'),
  ('86472',123,2,'Cuernavaca','Rechnitz'),
  ('08289',486,2,'Novosibirsk','Upper Hutt'),
  ('3516',152,3,'Saint Petersburg','Evere'),
  ('61484',168,10,'Maracanaú','Darwin'),
  ('68-250',268,3,'Jelenia Góra','Stafford'),
  ('68569',388,6,'Pacasmayo','Cork'),
  ('5220',96,2,'Yeosu','Nässjö'),
  ('92056',468,7,'Tuy Hòa','Mulchén'),
  ('K5A 7C3',202,8,'Deventer','Roosdaal'),
  ('39534',456,5,'Kupang','Olsztyn'),
  ('50108',246,7,'Adana','New Plymouth'),
  ('32-425',427,2,'Cajamarca','Solingen'),
  ('758176',115,5,'Mount Gambier','Borlänge'),
  ('50844-508',371,9,'Whitehorse','Evansville'),
  ('12523',490,3,'Farrukhabad-cum-Fatehgarh','Manavgat'),
  ('41623',14,2,'Santa Rita','Chungju'),
  ('84024',119,5,'Telfs','Edremit'),
  ('395623',323,7,'Dublin','Shillong'),
  ('BB09 4GS',380,5,'Hassan','Darwin'),
  ('49767-83547',25,10,'Hof','Évreux'),
  ('68532',238,6,'Santa Cruz de Tenerife','Piracicaba'),
  ('8914',404,8,'Nedlands','Lagos'),
  ('783247',15,7,'Rockingham','Riohacha'),
  ('2632',125,2,'Badajoz','Hindeloopen'),
  ('228312',244,7,'María Elena','Cusco'),
  ('54895-667',327,8,'Ramskapelle','Mjölby'),
  ('8861',278,4,'Oviedo','Opwijk'),
  ('81586',347,5,'Stockholm','Toledo'),
  ('73562',344,8,'Águas Lindas de Goiás','Belfast'),
  ('972657',345,2,'Lens-Saint-Servais','Kotamobagu'),
  ('97727',299,7,'Swan Hill','Galway'),
  ('36656',131,0,'Antakya','Sankt Wendel'),
  ('6362',29,5,'Ikot Ekpene','Driekapellen'),
  ('12803',475,8,'Christchurch','Alto del Carmen'),
  ('89133-850',438,9,'Isnes','Wałbrzych'),
  ('3977346',38,2,'Banda Aceh','Canberra'),
  ('50210',481,6,'Tapachula','Arequipa'),
  ('215680',187,1,'Ełk','Awka'),
  ('34448',461,1,'Soye','Söderhamn'),
  ('40384',377,9,'Dannevirke','Cork'),
  ('29118',374,6,'Arequipa','Pontianak');


INSERT INTO bpc_bds.restaurant (address_id, name, cuisine_id)
VALUES 
 (1, 'McDonnald', 3),
 (2, 'Pho Now', 8),
 (3, 'Go', 8), 
 (4, 'Dreveny orel', 2),
 (5, 'KFC', 3)
;


INSERT INTO bpc_bds.dish (name)
VALUES
 ('Hoeddeok'),
 ('Bulgogi'),
 ('Samgyeopsal'),
 ('Japchae'),
 ('Kimchi'),
 ('Samgyeopsal'),
 ('Japchae')
;


INSERT INTO bpc_bds.user_has_address (person_id, address_id)
VALUES
 (11, 6),
 (12, 7),
 (13, 8),
 (14, 9),
 (15, 10)
;

INSERT INTO bpc_bds.contact (value, type, person_id)
VALUES
  ('non.feugiat@protonmail.org','email',1),
  ('sed.neque@protonmail.ca','email',2),
  ('aliquam.rutrum@protonmail.org','email',3),
  ('erat.vitae.risus@yahoo.org','email',4),
  ('vulputate.ullamcorper@hotmail.org','email',5),
  ('est.nunc@outlook.com','email',6),
  ('etiam@outlook.ca','email',7),
  ('aliquam@hotmail.couk','email',8),
  ('iaculis.lacus@yahoo.ca','email',9),
  ('consectetuer.adipiscing@google.edu','email',10),
  ('tempus.scelerisque@protonmail.couk','email',11),
  ('imperdiet.non@protonmail.com','email',12),
  ('malesuada.fames@aol.ca','email',13),
  ('vel@google.ca','email',14),
  ('luctus.ut@protonmail.org','email',15),
  ('vestibulum.ante@yahoo.org','email',16),
  ('iaculis.quis@protonmail.net','email',17),
  ('vel.arcu@icloud.couk','email',18),
  ('cursus.purus.nullam@google.net','email',19),
  ('quisque.imperdiet@yahoo.ca','email',20),
  ('litora@aol.couk','email',21),
  ('vel.pede.blandit@google.com','email',22),
  ('cursus.diam@icloud.couk','email',23),
  ('auctor.velit@icloud.edu','email',24),
  ('1-213-539-5708','phone',25),
  ('1-322-315-8171','phone',26),
  ('1-514-589-8823','phone',27),
  ('1-875-688-3427','phone',28),
  ('1-164-268-7147','phone',29),
  ('1-520-775-7187','phone',30),
  ('(964) 324-2254','phone',31),
  ('1-468-359-9237','phone',32),
  ('(444) 744-5442','phone',33),
  ('1-714-527-3749','phone',34),
  ('1-576-251-5375','phone',35),
  ('1-913-651-2629','phone',36),
  ('(875) 845-5077','phone',37),
  ('(231) 584-5376','phone',38),
  ('1-858-105-0276','phone',39),
  ('(631) 276-0673','phone',40),
  ('1-892-581-5335','phone',41),
  ('(616) 469-4978','phone',42),
  ('1-849-715-7675','phone',43),
  ('1-381-621-3468','phone',44),
  ('(540) 734-7262','phone',45),
  ('1-648-361-8094','phone',46),
  ('(815) 776-4517','phone',47),
  ('(895) 373-4532','phone',48),
  ('(176) 253-4297','phone',49);

INSERT INTO bpc_bds.delivery (person_id, driver_id, arrival, delivery_fee)
VALUES 
 (11, 1, NULL, 17),
 (11, 1, '2020-01-07 15:20:00', 30),
 (12, 2, NULL, 30),
 (13, 1, NULL, 20),
 (14, 5, '2021-01-07 16:24:00', 55),
 (14,1, NULL, 20),
 (11, 2, '2021-01-07 15:21:00', 30)
;


INSERT INTO bpc_bds.dish_has_restaurant (dish_id, restaurant_id, price)
VALUES 
 (1, 1, 200),
 (2, 1, 120),
 (1, 2, 162),
 (2, 3, 123),
 (3, 1, 312),
 (4, 2, 150),
 (5, 3, 320)
;


INSERT INTO bpc_bds.delivery_has_dish_has_restaurant (delivery_id, dish_id, restaurant_id, user_requirements)
VALUES
 (1, 1, 1, NULL),
 (1, 2, 1, NULL),
 (2, 1, 2, NULL),
 (3, 2, 3, NULL),
 (4, 3, 1, NULL),
 (5, 4, 2, NULL),
 (6, 5, 3, NULL)
;

INSERT INTO bpc_bds.review (person_id, dish_id, restaurant_id, driver_id, rating, text)
VALUES
 (11, 1, 1, NULL, 1, 'Nedoporucuji'),
 (11, 2, 1, NULL, 2, 'Nedoporucuji nechutnalo'),
 (11, 1, 2, NULL, 5, 'Bylo super jidlo'),
 (13, NULL, NULL, 1, 5, 'Sympatak'),
 (13, NULL, NULL, 2, 4, NULL),   
 (15, 3, 1, NULL, 4, NULL),
 (15, 4, 2, NULL, 5, NULL)
;


-- 1. Select specific columns from table
-- SELECT first_name, last_name FROM bpc_bds.person; 


-- 2. Select with specific email
-- SELECT p.username, c.value FROM bpc_bds.person AS p JOIN bpc_bds.contact AS c ON c.person_id=p.person_id WHERE c.type='email' AND c.value='etiam@outlook.ca';


-- 3. UPDATE|INSERT|DELETE|ALTER TABLE
-- ~!TODO!~

-- USE OF: WHERE - get all usernames born after 2000
-- SELECT p.username, p.date_of_birth FROM bpc_bds.person AS p WHERE p.date_of_birth>='2000-1-1';

-- USE OF: LIKE| NOT LIKE - get all person usernames which starts with 'a' and does not end with 'g'
-- SELECT p.username FROM bpc_bds.person AS p WHERE p.username LIKE 'a%' AND p.username NOT LIKE '%g';

-- USE OF: SUBSTRING|TRIM - get first 5 symbols from phone if there are spaces remove them
-- SELECT TRIM(SUBSTRING(c.value, 1,5)) FROM bpc_bds.contact AS c WHERE c.type='phone';

-- USE OF: COUNT|SUM|MIN|MAX|AVG - get count,sum,min,max,avg from restaurants
-- SELECT COUNT(dr.price), SUM(dr.price), MIN(dr.price), MAX(dr.price), AVG(dr.price) FROM bpc_bds.dish_has_restaurant AS dr GROUP BY dr.restaurant_id;

-- USE OF: – GROUP BY|GROUP BY and HAVING|GROUP BY, HAVING, and WHERE
-- Show all max prices in all restaurants
-- SELECT MAX(dr.price), dr.restaurant_id FROM bpc_bds.dish_has_restaurant AS dr GROUP BY dr.restaurant_id;
-- Get all prices from restaurants and only show the max price when it is under 300
-- SELECT MAX(dr.price), dr.restaurant_id FROM bpc_bds.dish_has_restaurant AS dr GROUP BY dr.restaurant_id HAVING MAX(dr.price)<300;
-- Get all prices under 200 from all restaurants and show only those averages under 125
-- SELECT AVG(dr.price), dr.restaurant_id FROM bpc_bds.dish_has_restaurant AS dr WHERE dr.price<200 GROUP BY dr.restaurant_id HAVING AVG(dr.price)<125;

-- USE OF: – UNION ALL|UNION
-- Joins two queries together first cotnains only developers the second all non user username the UNION ALL allows duplicates
-- (SELECT p.username FROM bpc_bds.person AS p WHERE p.person_type_id=4) UNION (SELECT p.username FROM bpc_bds.person AS p WHERE p.person_type_id!=1 AND p.person_type_id!=1)
-- (SELECT p.username FROM bpc_bds.person AS p WHERE p.person_type_id=4) UNION ALL (SELECT p.username FROM bpc_bds.person AS p WHERE p.person_type_id!=1 AND p.person_type_id!=1)

-- USE OF: DISTINCT 
-- Show all unique names in 
-- SELECT DISTINCT(p.first_name) FROM bpc_bds.person AS p;

-- USE OF: LEFT JOIN|RIGHT JOIN|FULL OUTER JOIN



-- Use in one query: LEFT JOIN, GROUP BY, HAVING, ORDER BY, AVG and DISTINCT
-- SELECT p.username, d.name ,AVG(r.rating) FROM bpc_bds.person AS p LEFT JOIN bpc_bds.review AS r ON p.person_id=r.person_id LEFT JOIN bpc_bds.dish_has_restaurant AS dhr ON r.dish_id=dhr.dish_id LEFT JOIN bpc_bds.dish as d ON d.dish_id=dhr.dish_id WHERE r.dish_id IS NOT NULL GROUP BY r.dish_id, p.username, d.name HAVING AVG(r.rating)>3 ORDER BY AVG(r.rating) DESC;
-- ~!TODO!~ GROUP BY a DISTICT


-- Create a query that will return the data from an arbitrary table for the last one and half days
-- (1day + 12 hours, i.e., 36 hours). Do not hard code the query (e.g., created at > 7-11-2021)!
-- Do it programmatically with DATE functions.
-- SELECT * FROM bpc_bds.delivery WHERE arrival>(NOW()-interval '36 hour');


-- Create a query that will return data from the last month (starting from the first day of the month)
-- SELECT * FROM bpc_bds.delivery WHERE arrival>date_trunc('month', NOW());


-- Write a select that will remove accents on a selected string (e.g., ´a will be converted to a)
-- Beforehand, you will need to save data that contain accents in the database (e.g., save
-- some Czech surname in the database that has accents)
-- CREATE EXTENSION unaccent SCHEMA bpc_bds;
-- SELECT bpc_bds.unaccent('ě š č ř ž ý á í é ň ť ľ');
-- SELECT bpc_bds.unaccent(last_name) FROM bpc_bds.person;


-- Create a query for pagination in an application (use LIMIT and OFFSET)
-- SELECT * FROM bpc_bds.person ORDER BY date_of_birth LIMIT 3 OFFSET 3;


-- Create a query that will use subquery in FROM
-- SELECT * FROM (SELECT first_name, last_name FROM bpc_bds.person as p1) as p2;


-- Create a query that will use subquery in WHERE condition
-- SELECT r.name, d.name, dhr.price FROM bpc_bds.dish AS d JOIN bpc_bds.dish_has_restaurant AS dhr ON dhr.dish_id=d.dish_id JOIN bpc_bds.restaurant AS r ON dhr.restaurant_id=r.restaurant_id WHERE dhr.price>(SELECT AVG(inside.price) FROM bpc_bds.dish_has_restaurant AS inside);


-- Create a query that will use any aggregate function and GROUP BY with HAVING
-- SELECT p.username, d.name ,AVG(r.rating) FROM bpc_bds.person AS p LEFT JOIN bpc_bds.review AS r ON p.person_id=r.person_id LEFT JOIN bpc_bds.dish_has_restaurant AS dhr ON r.dish_id=dhr.dish_id LEFT JOIN bpc_bds.dish as d ON d.dish_id=dhr.dish_id WHERE r.dish_id IS NOT NULL GROUP BY r.dish_id, p.username, d.name HAVING AVG(r.rating)>3 ORDER BY AVG(r.rating) DESC;
-- ~!TODO!~...WHYYY


-- Create a query that will join at least five tables
-- SELECT p.username, c.cuisine_name, rest.name, d.name, dhr.price, rev.rating FROM bpc_bds.person AS p 
-- JOIN bpc_bds.review AS rev ON rev.person_id=p.person_id
-- JOIN bpc_bds.dish_has_restaurant AS dhr ON rev.dish_id=dhr.dish_id
-- JOIN bpc_bds.restaurant AS rest ON dhr.restaurant_id=rest.restaurant_id
-- JOIN bpc_bds.dish AS d ON dhr.dish_id=d.dish_id
-- JOIN bpc_bds.cuisine AS c ON c.cuisine_id=rest.cuisine_id;


-- Create a query that will join at least three tables and will use GROUP BY, HAVING, and WHERE
-- SELECT p.username, d.name ,AVG(r.rating) FROM bpc_bds.person AS p LEFT JOIN bpc_bds.review AS r ON p.person_id=r.person_id LEFT JOIN bpc_bds.dish_has_restaurant AS dhr ON r.dish_id=dhr.dish_id LEFT JOIN bpc_bds.dish as d ON d.dish_id=dhr.dish_id WHERE r.dish_id IS NOT NULL GROUP BY r.dish_id, p.username, d.name HAVING AVG(r.rating)>3 ORDER BY AVG(r.rating) DESC;
-- ~!TODO!~...WHYYY


-- Modify the database from the first project assignment to improve integrity constraints (e.g., reduce the size for varchar columns)
-- Set cascading, explain places where you used cascading and why?