
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
  ('Solomon','Salazar','OKP78ELK6RI','1983-01-04','suspendisse.sed@utnisi.net',1),
  ('Hanae','Gamble','MVM83HHY4HO','1998-04-27','in.ornare@tellusnunc.ca',1),
  ('Uma','Hester','OWH44XSU5WJ','1987-10-27','sit.amet@metuseuerat.edu',2),
  ('Silas','Sullivan','SUS26KUU6YL','2006-05-11','ultricies@mauriss.com',2),
  ('Kaitlin','Hogan','UCN59IOP3UA','2008-06-30','duis.sit.amet@non.com',1),
  ('Jenna','Wheeler','EXY25FCH2HW','1986-01-27','sodales@inloremdonec.edu',1),
  ('Buckminster','Prince','SRQ89TKD1BQ','1990-07-10','eleifend.egestas@sagittisnullam.co.uk',2),
  ('Candice','Macias','PKC49OPB7HO','1981-01-26','adipiscing.elit@penatibuset.com',2),
  ('Kasper','Donaldson','WKC77EYO0HU','2005-02-13','imperdiet.nec@pellentesqueultricies.com',1),
  ('Uriah','Nichols','PVV75CKU7TL','1978-03-11','accumsan.interdum@risus.ca',1),
  ('Harper','Levy','DWU55HDF3AV','1981-09-06','justo@aliquamerat.ca',2),
  ('Mollie','Lloyd','UGK33RLW6LW','1981-02-05','cras.lorem.lorem@facilisismagna.ca',2),
  ('Joelle','Becker','HSC38GSH7EW','2006-06-14','est.mauris@anteipsum.org',2),
  ('Dalton','Baxter','YYG86DPM2VQ','2010-12-14','quisque.fringilla@sitamet.net',2),
  ('Chadwick','Solis','MEY54GDO4GR','1975-03-04','eleifend.vitae.erat@dictum.com',2),
  ('Gray','Montoya','SYM63DWO1AD','1980-07-05','urna.ut.tincidunt@ipsumprimis.ca',2),
  ('Cedric','Hays','TPP62OOT5MF','1999-09-10','nisl@actellus.edu',2),
  ('Kuame','Townsend','DKS19YET5FP','2006-09-27','odio.sagittis@scelerisquescelerisquedui.co.uk',2),
  ('Blossom','Dixon','SFI88IFN0EV','1982-10-25','sem@loremtristique.co.uk',2),
  ('Paul','Frank','AQT63RUH5YV','1988-05-16','odio.etiam@dolorelitpellentesque.net',2),
  ('Nolan','Fischer','SNW26TQU3GD','1994-11-11','ante.ipsum@aliquetdiam.co.uk',1),
  ('Charde','Hood','CVH89XHJ5LI','1982-02-26','convallis@euultrices.co.uk',1),
  ('Asher','Wiggins','QCB11PGJ9RK','1989-05-15','non.sapien@sagittisnullam.com',2),
  ('Len','Moody','TML57IJV2EE','2000-04-18','blandit.enim@musaenean.com',2),
  ('Moana','Brown','KEX12BLL2JK','2008-01-14','tempor.arcu@dictum.edu',1),
  ('Blaze','Coleman','FLT55ZNH8SX','2014-06-19','enim.mi@mauriseu.co.uk',1),
  ('Zorita','Hammond','FTQ04CFM6GL','1975-12-27','est@aliquetproin.edu',2),
  ('Willow','Stephens','ALH53NVJ2VZ','2006-01-15','ultrices.a@porttito.co.uk',2),
  ('Ramona','Turner','MPW50VGN7QI','1989-11-29','sem.ut@vitaeerat.net',1),
  ('Kiayada','White','MHV14XJH7SD','2016-09-03','nec.urna@idsapien.org',1),
  ('Zane','Roy','XMW17SOH6VW','1974-11-22','quisque.varius@nec.edu',2),
  ('Russell','Neal','KGY73HZS4HT','1981-07-30','amet@purusinmolestie.ca',2),
  ('Cheryl','Cash','KPZ75SUI0HQ','2011-05-12','quisque@volutpatnulla.edu',1),
  ('Herrod','Harding','XZJ87GPS3PH','2011-10-18','ac.libero.nec@sedcongue.com',1),
  ('Lesley','Hurley','VBH75CJU2IW','1980-10-13','nunc.pulvinar@arcuvivamussit.net',2),
  ('Peter','Newman','USI27DSD5MH','2008-03-26','enim.mauris.quis@leovivamusnibh.edu',2),
  ('Bevis','Holden','QNC85YMN6XL','1989-04-18','lobortis@a.org',1),
  ('Galvin','Benton','AQX83EFY1NH','1996-07-21','vitae.erat@accumsaninterdum.ca',1),
  ('Destiny','Gonzales','RMU75WEI7SR','1995-01-08','auctor.vitae.aliquet@faucibusutnulla.com',2),
  ('Hayfa','Hunt','YRT74RIQ9IZ','2013-08-23','sit.amet.ante@eratvolutpat.ca',2),
  ('Wing','Hurst','RYB11BHA6TC','2009-10-01','non.vestibulum@imperdietnon.co.uk',1),
  ('Solomon','Hood','VOE02OIU8VT','2018-06-11','id.blandit@sagittis.co.uk',1),
  ('Adam','Sullivan','EXG16FQJ5MR','1982-05-05','nibh.vulputate@sitamet.ca',2),
  ('Oliver','Harmon','LON46YIK1SC','1974-10-06','et@inmagna.org',2),
  ('Nash','Bass','QLK76HXL3KP','1987-04-05','nunc@ultricesposuere.com',1),
  ('Jillian','Sawyer','GFW66YLS1XY','1985-03-12','non@fringilladonec.co.uk',1),
  ('Alan','Lambert','RVV36QWS9MY','1982-09-08','semper.cursus@adipiscingelitcurabitur.net',2),
  ('Jena','Reed','QPK32IUS9WX','1982-11-05','fermentum.fermentum@nonlorem.edu',2),
  ('Hadassah','Monroe','XDQ71FWN8DX','1991-11-12','habitant.morbi@scelerisquesed.ca',1),
  ('Cooper','Blanchard','USA25NWF8HV','2007-01-07','sapien@utquamvel.ca',1),
  ('Maxine','Mason','IYZ81ONC9YE','1990-04-23','suspendisse.dui@sodalespurus.net',2),
  ('Kylie','Shelton','NCU72XXI5YD','1987-04-09','suspendisse@diam.ca',2),
  ('Garth','Hale','YEB13GLY0IQ','1974-04-05','curabitur.dictum@susealiquet.com',1),
  ('Dale','Dickerson','RAY76LXM4CP','1994-04-15','mauris.eu@dictumeu.edu',1),
  ('Amela','Hickman','ISV43QVR4UJ','1993-07-29','lorem.ipsum@risus.net',2),
  ('Helen','Delaney','ETL95VPX3KY','2004-11-11','velit@arcueuodio.com',2),
  ('Constance','Holcomb','UCX59ZLR3LO','1997-09-07','faucibus.orci.luctus@antebibendumu.co.uk',1),
  ('Minerva','Albert','UNZ39DRJ3OB','1999-11-28','orci.luctus@magnacras.net',1),
  ('Ferdinand','Lara','VWU78JJC8QW','1982-03-07','elementum.dui.quis@egestashendreritneque.edu',2),
  ('Barrett','Reyes','ITI91FPI2KR','2005-06-26','feugiat.sed@malesuada.co.uk',2),
  ('Brianna','Cobb','DLB66BUK6ET','1993-06-10','sed.auctor.odio@curaedonec.org',1),
  ('Savannah','Dejesus','AGJ27PUN5JI','2018-05-09','aliquam.enim@arcuvel.edu',1),
  ('Paul','Francis','DGM58PVN7KV','2017-09-06','et@est.com',2),
  ('Stewart','Acosta','VFE42MAR1VI','1978-12-15','amet.risus@hendrerita.com',2),
  ('Connor','Dotson','IZI10SDB3LY','1976-09-28','suspendisse@facilisised.co.uk',1),
  ('Harriet','Goff','NIS53JXR1VN','2003-02-19','sed@purusaccumsan.net',1),
  ('Mira','Kirkland','KVB25ELC8PR','2011-09-19','morbi.neque@craseu.edu',2),
  ('Frances','Bennett','WGM68JPL7BG','1977-07-17','ipsum.primis@maurissit.com',2),
  ('Unity','Foster','RRK70DAX3MN','1992-05-11','ultricies.adipiscing@donecsollicitudin.co.uk',1),
  ('Ishmael','Dyer','FSO28HFH4DD','2010-10-29','faucibus.morbi@ut.com',1),
  ('Noelani','Frank','GFY00RUE7ES','1993-11-10','sed.dictum@convallisincursus.ca',2),
  ('Lucas','Ochoa','XRS03APT9PS','1987-03-24','quisque.nonummy@tempordiam.co.uk',2),
  ('Olga','Hardy','QYZ65OHV9LW','1999-10-11','tristique.aliquet@placerategetvenenatis.ca',1),
  ('Chanda','Washington','XXV56ECJ8TI','1989-03-09','id@orcilacusvestibulum.net',1),
  ('Jana','Byers','YNN15JBQ6LG','2008-09-30','sodales.at@sapienaeneanmassa.ca',2),
  ('Keefe','Fields','SUN44RFX7WM','2006-05-09','leo.elementum@ametultricies.net',2),
  ('Veda','Albert','HQK45QII9HP','2002-02-12','aptent@suspendisseacmetus.edu',1),
  ('Katelyn','Holden','XVV33KJK1NO','1976-06-20','eu.nibh@arcu.co.uk',1),
  ('Kyla','Morrison','LFI37VVE2BO','1992-05-11','et.rutrum@ultricesa.ca',2),
  ('Ignacia','Jenkins','DBN60ZHA2SW','1984-01-07','in.condimentum@proinmi.net',2),
  ('Sarah','Burks','VIY27OYG1HQ','2001-10-02','donec.elementum@duifuscediam.com',1),
  ('Jacob','Wise','XKI21VFR8UI','1986-06-09','at.pede.cras@arcuvestibulum.ca',1),
  ('Garrett','Obrien','TBE97VFD7KT','2018-10-23','mauris@consequatnec.net',2),
  ('Hammett','Snyder','ZNS35QIJ3SU','1981-07-20','turpis.nulla@egestas.edu',2),
  ('Macon','Thomas','NGF20SYY5NF','2004-10-30','fringilla.cursus@venenatisvelfaucibus.ca',1),
  ('Zelenia','Talley','YPQ45USU5HB','2002-10-07','eget@elitetiamlaoreet.ca',1),
  ('Benedict','Woods','JEG28XWK2XF','1983-12-09','cursus.luctus@dictum.edu',2),
  ('Jena','Haley','KTI33KTW9SW','2014-05-01','massa@consequatdolorvitae.ca',2),
  ('Brody','Terrell','BSL43SXW6QY','1974-01-24','eu.sem@etiamlaoreetlibero.ca',1),
  ('Austin','Pate','ULI44UMT2QS','1973-11-26','luctus.lobortis.class@lacusquisque.org',1),
  ('Jordan','Obrien','LPR06MBC4WQ','1983-07-11','vitae.sodales@nequetellusimperdiet.co.uk',3),
  ('Megan','Skinner','KNL37VIT5HR','1983-09-26','lobortis.ndisse@intco.uk',3),
  ('Lucius','Gillespie','SAV65GCP8JA','1991-06-24','ac.urna@egetmagna.com',4),
  ('Shannon','Holcomb','ZDZ78DTO1NV','2006-10-03','proin.ultrices.duis@diamproin.ca',5),
  ('Xanthus','Houston','CEN08QYZ2LI','1992-08-30','auctor.mauris@elit.com',3),
  ('Aiko','Hernandez','EGD45IEG3AG','1973-11-04','scelerisque.lorem@aliquet.com',3),
  ('Daria','Rice','YCK10GIJ1CQ','2002-12-08','non.bibendum@dignissimmnare.com',4),
  ('Hiroko','Ellison','MVB98BYQ8YP','1990-06-21','dui@neceuismod.com',5),
  ('Driscoll','Lamb','PWG84VKQ0DN','2004-12-08','eu.tellus@consectetueripsumnunc.edu',3),
  ('Susan','Howe','MDY54RML3UQ','1975-09-15','cras.sed@eget.net',5);


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

INSERT INTO bpc_bds.contact (person_id, type, value)
VALUES
 (11, 'phone', '+420165465465'),
 (12, 'phone', '+420654654654'),
 (13, 'phone', '+420602312123'),
 (14, 'phone', '+420298541985'),
 (15, 'facebook', 'marty')
;

INSERT INTO bpc_bds.delivery (person_id, driver_id, arrival, delivery_fee)
VALUES 
 (11, 1, NULL, 17),
 (11, 1, '2020-01-07 15:20:00', 30),
 (12, 2, NULL, 30),
 (13, 1, NULL, 20),
 (14, 5, '2020-01-07 16:24:00', 55),
 (14,1, NULL, 20),
 (11, 2, '2020-01-07 15:21:00', 30)
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