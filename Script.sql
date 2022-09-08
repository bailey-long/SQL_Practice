DROP TABLE IF EXISTS `order_item`;

DROP TABLE IF EXISTS `product_ingredient`;

DROP TABLE IF EXISTS `order`;

DROP TABLE IF EXISTS `ingredient`;

DROP TABLE IF EXISTS `product`;

DROP TABLE IF EXISTS `employee`;

DROP TABLE IF EXISTS `customer`;

DROP TABLE IF EXISTS `branch`;

DROP TABLE IF EXISTS `company`;

-- Create the tables

CREATE TABLE `company`
(
	`company_id` INT PRIMARY KEY AUTO_INCREMENT,
	`name` VARCHAR(50) NOT NULL,
	`street` VARCHAR(100),
	`city` VARCHAR(100),
	`postal_code` VARCHAR(4)
);

CREATE TABLE `branch`
(
	`branch_id` INT PRIMARY KEY AUTO_INCREMENT,
	`company_id` INT NOT NULL,
	`name` VARCHAR(50) NOT NULL,
	`street` VARCHAR(100),
	`city` VARCHAR(100),
	`postal_code` VARCHAR(4)
);

CREATE TABLE `employee`
(
	`employee_id` INT PRIMARY KEY AUTO_INCREMENT,
	`branch_id` INT NOT NULL,
	`manager_id` INT,
	`first_name` VARCHAR(50) NOT NULL,
	`last_name` VARCHAR(50) NOT NULL,
	`email` VARCHAR(50) UNIQUE NOT NULL,
	`phone` VARCHAR(50) NOT NULL,
	`position` VARCHAR(50) NOT null,
	`salary` DECIMAL not NULL
);


CREATE TABLE `customer`
(
	`customer_id` INT PRIMARY KEY AUTO_INCREMENT,
	`company_id` INT NOT NULL,
	`first_name` VARCHAR(50) NOT NULL,
	`last_name` VARCHAR(50) NOT NULL,
	`email` VARCHAR(50) UNIQUE NOT NULL,
	`phone` VARCHAR(50) NOT NULL,
	`street` VARCHAR(100),
	`city` VARCHAR(100),
	`postal_code` VARCHAR(4)
);

CREATE TABLE `product`
(
	`product_id` INT PRIMARY KEY AUTO_INCREMENT,
	`branch_id` INT NOT NULL,
	`name` VARCHAR(50) NOT NULL,
	`sku` VARCHAR(50) NOT NULL,
	`price` DECIMAL(10,2) NOT NULL,
	`created_date` DATETIME DEFAULT CURRENT_TIMESTAMP,
	`modified_date` DATETIME,
	`description` VARCHAR(255)
);

CREATE TABLE `product_ingredient`
(
	`product_id` INT NOT NULL,
	`ingredient_id` INT NOT NULL,
	`amount` FLOAT NOT NULL,
    PRIMARY KEY (`product_id`, `ingredient_id`)
);

CREATE TABLE `ingredient`
(
	`ingredient_id` INT PRIMARY KEY AUTO_INCREMENT,
	`name` VARCHAR(50) NOT NULL,
	`unit` VARCHAR(20) NOT NULL,
	`weight` FLOAT NOT NULL
);

CREATE TABLE `order`
(
	`order_id` INT PRIMARY KEY AUTO_INCREMENT,
	`customer_id` INT NOT NULL,
	`order_date` DATETIME DEFAULT CURRENT_TIMESTAMP,
	`shipped_date` DATETIME DEFAULT NULL,
	`status` ENUM('Unpaid','Paid') NULL 
);

CREATE TABLE `order_item`
(
	`order_id` INT NOT NULL,
	`product_id` INT NOT NULL,
	`quantity` INT NOT NULL,
	`price` DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (`order_id`, `product_id`)
);

-- Add the foreign key constraints 
 
ALTER TABLE `customer`
ADD CONSTRAINT FK_customer_company
FOREIGN KEY (`company_id`) REFERENCES 
`company` (`company_id`);

ALTER TABLE `branch`
ADD CONSTRAINT FK_branch_company
FOREIGN KEY (`company_id`) REFERENCES 
`company` (`company_id`);

ALTER TABLE `employee`
ADD CONSTRAINT FK_employee_branch
FOREIGN KEY (`branch_id`) REFERENCES 
`branch` (`branch_id`);

ALTER TABLE `employee`
ADD CONSTRAINT FK_employee_employee
FOREIGN KEY (`manager_id`) REFERENCES 
`employee` (`employee_id`);

ALTER TABLE `product`
ADD CONSTRAINT FK_product_branch
FOREIGN KEY (`branch_id`) REFERENCES 
`branch` (`branch_id`);

ALTER TABLE `product_ingredient`
ADD CONSTRAINT FK_product_ingredient_product
FOREIGN KEY (`product_id`) REFERENCES 
`product` (`product_id`);

ALTER TABLE `product_ingredient`
ADD CONSTRAINT FK_product_ingredient_ingredient
FOREIGN KEY (`ingredient_id`) REFERENCES 
`ingredient` (`ingredient_id`);

ALTER TABLE `order`
ADD CONSTRAINT FK_order_customer
FOREIGN KEY (`customer_id`) REFERENCES 
`customer` (`customer_id`);

ALTER TABLE `order_item`
ADD CONSTRAINT FK_order_item_order
FOREIGN KEY (`order_id`) REFERENCES 
`order` (`order_id`);

ALTER TABLE `order_item`
ADD CONSTRAINT FK_order_item_product
FOREIGN KEY (`product_id`) REFERENCES 
`product` (`product_id`);
-- Set default value
ALTER TABLE `order`
ALTER status SET DEFAULT "Unpaid";
-- Change default value
alter table `order`
change column order_date order_date datetime default current_timestamp;
-- restrict the value of price to >= 0
alter table product
change column price price decimal not null check (price >= 0);
-- RESTRICT THE VALUE OF QUANTITY AND PRICE IN table 
alter table order_item
add check (quantity>=1),
add check (price>=1);

SET FOREIGN_KEY_CHECKS = 0; 

-- DELETE FROM product_ingredient;

TRUNCATE TABLE `company` ;
TRUNCATE TABLE `customer`;
TRUNCATE TABLE `employee`;
TRUNCATE TABLE `branch`;
TRUNCATE TABLE `order`;
TRUNCATE TABLE `ingredient`;
TRUNCATE TABLE `product`;
TRUNCATE TABLE `product_ingredient`;
TRUNCATE TABLE `order_item`;

SET FOREIGN_KEY_CHECKS = 1;  

-- Insert my data

INSERT INTO `company` (`name`) VALUES ('Fine Vines Ltd');

INSERT INTO `branch` (`branch_id`, `company_id`, `name`, `street`, `city`, `postal_code`) VALUES
	(1, 1, 'Nelson Vines', '12 Water street', 'Nelson', '7010'),
	(2, 1, 'Richmond Vines', '24 Kensington Point', 'Richmond', '7020'),
	(3, 1, 'Brightwater Vines', '300 Main Road', 'Brightwater', '7022');

INSERT INTO `employee` (`branch_id`, `manager_id`, `first_name`, `last_name`, `email`, `phone`, `position`, `salary`) VALUES
	 (1,NULL,'Opaline','Clell','oclell0@goodreads.com','648-449-2035','Manager', 89000),
	 (2,NULL,'Aubrette','Dillingstone','adillingstone1@loc.gov','622-641-0718','Manager', 85500),
	 (3,NULL,'Parker','Foreman','pforeman2@dropbox.com','708-339-7120','Manager', 82000),
	 (1,1,'Emmit','Nilles','enilles3@walmart.com','567-223-0764','Engineer', 75450),
	 (2,2,'Raine','Walczynski','rwalczynski4@trellian.com','661-794-9885','Labourer', 41500),
	 (2,2,'Gerry','Onion','gonion5@unc.edu','868-841-2812','Sales', 42050),
	 (1,1,'Lev','Scullion','lscullion6@myspace.com','807-553-1282','Engineer', 70100),
	 (2,2,'Doti','Wallett','dwallett7@hibu.com','700-550-4559','Assistant Manager', 60250),
	 (2,2,'Donetta','McMurray','dmcmurray8@sohu.com','672-593-3865','Sales', 55000),
	 (2,1,'Stillman','Bowdery','sbowdery9@paginegialle.it','746-721-6960','Labourer', 45500),
	 (1,1,'Muffin','Kupka','mkupkaa@chron.com','169-652-7066','Sales', 43020),
	 (1,1,'Tisha','Dorgan','tdorganb@booking.com','423-823-4802','Labourer', 45500),
	 (2,1,'Heidi','Francesch','hfranceschc@google.com','233-478-4866','Accounts',53000),
	 (3,3,'Torrance','Dibner','tdibnerd@imageshack.us','626-171-5092','Sales', 38440),
	 (1,1,'Shell','Gilliland','sgillilande@stanford.edu','839-776-5784','Labourer', 45500),
	 (2,2,'Hazel','Beltzner','hbeltznerf@comcast.net','905-959-0926','Tax Accountant', 68030),
	 (3,3,'Ynes','McCuis','ymccuisg@weather.com','985-245-5783','Labourer', 42550),
	 (2,2,'Minta','Rushmare','mrushmareh@booking.com','271-263-5669','Sales', 43020),
	 (1,1,'Ruperto','Bleasdille','rbleasdillei@livejournal.com','828-223-2700','Sales', 43020),
	 (1,1,'Juanita','Dmitrichenko','jdmitrichenkoj@youtube.com','936-914-5540','Labourer', 45500),
	 (1,1,'Jesselyn','Valadez','jvaladezk@tamu.edu','641-149-0591','Labourer', 45500),
	 (2,2,'Verney','Lobe','vlobel@cnbc.com','235-627-4400','Labourer', 45500),
	 (2,2,'Fred','Pestricke','fpestrickem@ning.com','483-804-6238','Engineer', 76000),
	 (2,2,'Hall','Toulson','htoulsonn@intel.com','618-283-2560','Sales', 60000),
	 (2,2,'Howie','Durno','hdurnoo@cam.ac.uk','317-770-0503','Accounts', 56000),
	 (3,3,'Harbert','Fissenden','hfissendenp@hao123.com','887-726-4381','Accounts', 55600),
	 (3,3,'Lorene','Worswick','lworswickq@vinaora.com','703-561-3271','Labourer', 46500),
	 (3,2,'Augustina','Rozec','arozecr@livejournal.com','773-548-5226','Labourer', 45500),
	 (3,3,'Elspeth','Reith','ereiths@jiathis.com','927-193-3422','Labourer', 45500),
	 (1,3,'Rabi','Noore','rnooret@squidoo.com','757-411-5743','Labourer', 40400);

INSERT INTO `customer` (`customer_id`, `company_id`, `first_name`, `last_name`, `email`, `phone`, `street`, `city`, `postal_code`) VALUES
	(1, 1, 'Marve', 'MacAnelley', 'mmacanelley0@tuttocitta.it', '522-792-9391', '9 Roth Road', 'Nelson', '7010'),
	(2, 1, 'Ainslie', 'Bater', 'abater1@posterous.com', '124-795-3786', '11 Northfield Circle', 'Nelson', '7010'),
	(3, 1, 'Brendon', 'Doerffer', 'bdoerffer2@google.com.br', '920-165-6657', '9 Lerdahl Park', 'Nelson', '7010'),
	(4, 1, 'Adelbert', 'Cultcheth', 'acultcheth3@miitbeian.gov.cn', '685-552-1895', '6796 Miller Crossing', 'Nelson', '7040'),
	(5, 1, 'Rusty', 'Govern', 'rgovern4@army.mil', '986-248-6208', '795 Luster Circle', 'Nelson', '7010'),
	(6, 1, 'Cos', 'Kyle', 'ckyle5@eepurl.com', '950-901-1164', '7954 Lake View Junction', 'Richmond', '7020'),
	(7, 1, 'Demetris', 'Skirvane', 'dskirvane6@opera.com', '892-463-7334', '286 Hermina Crossing', 'Nelson', '7010'),
	(8, 1, 'Madeleine', 'Stemson', 'mstemson7@mysql.com', '707-524-6656', '1 Cordelia Park', 'Nelson', '7010'),
	(9, 1, 'Robert', 'Borthram', 'rborthram8@altervista.org', '910-208-4799', '86977 Northland Road', 'Stoke', '7011'),
	(10, 1, 'Jennilee', 'Duval', 'jduval9@dmoz.org', '284-177-5227', '88 Shopko Parkway', 'Nelson', '7040'),
	(11, 1, 'Ariella', 'Thormwell', 'athormwella@macromedia.com', '123-966-7358', '24 Hazelcrest Crossing', 'Nelson', '7040'),
	(12, 1, 'Ilyssa', 'Casetti', 'icasettib@tripadvisor.com', '860-397-2597', '8197 Eastwood Terrace', 'Nelson', '7040'),
	(13, 1, 'Ilaire', 'Aisbett', 'iaisbettc@theguardian.com', '578-974-6115', '14801 Stuart Plaza', 'Stoke', NULL),
	(14, 1, 'Terencio', 'Wederell', 'twederelld@pen.io', '684-163-5262', '718 La Follette Circle', 'Stoke', '7011'),
	(15, 1, 'Seth', 'Iianon', 'siianone@cpanel.net', '304-999-6013', '22 Farragut Drive', 'Stoke', '7011'),
	(16, 1, 'Mareah', 'Cleeve', 'mcleevef@elpais.com', '565-345-5889', '252 Golf View Circle', 'Nelson', '7010'),
	(17, 1, 'Elysha', 'Huegett', 'ehuegettg@columbia.edu', '951-926-2966', '6052 Briar Crest Court', 'Nellson', '7010'),
	(18, 1, 'Roley', 'Fensome', 'rfensomeh@weather.com', '594-213-9892', '902 Shoshone Alley', 'Nelson', '7040'),
	(19, 1, 'Steffi', 'Orsi', 'sorsii@timesonline.co.uk', '992-869-8266', '5 Saint Paul Park', 'Christchurch', '7674'),
	(20, 1, 'Brynn', 'Weatherburn', 'bweatherburnj@google.ru', '770-164-8116', '0192 Knutson Alley', 'Stoke', '7011'),
	(21, 1, 'Emily', 'Rigglesford', 'erigglesfordk@godaddy.com', '698-626-3415', '1 Towne Trail', 'Nelson', '7040'),
	(22, 1, 'Cristina', 'Joddins', 'cjoddinsl@archive.org', '930-116-6926', '171 Carioca Court', 'Christchurch', '7476'),
	(23, 1, 'Kippy', 'Gulberg', 'kgulbergm@hhs.gov', '301-730-2716', '81889 Monument Pass', 'Christchurch', '8011'),
	(24, 1, 'Northrup', 'Southernwood', 'nsouthernwoodn@smh.com.au', '592-790-2106', '176 Carey Parkway', 'Stoke', NULL),
	(25, 1, 'Orazio', 'Tiron', 'otirono@tripadvisor.com', '497-289-4039', '2 Ronald Regan Place', 'Stoke', '7011'),
	(26, 1, 'Jennica', 'Pillans', 'jpillansp@pbs.org', '575-144-3415', '093 Nobel Place', 'Nelson', '7040'),
	(27, 1, 'Sianna', 'Pidwell', 'spidwellq@msu.edu', '438-534-3976', '0563 Westend Circle', 'Richmond', '7020'),
	(28, 1, 'Amandy', 'Scocroft', 'ascocroftr@scientificamerican.com', '801-384-1245', '3 Aberg Pass', 'Richmond', '7020'),
	(29, 1, 'Angelita', 'Westphal', 'awestphals@gizmodo.com', '491-658-2397', '7 Valley Edge Point', 'Richmond', '7020'),
	(30, 1, 'Audy', 'Goodlett', 'agoodlettt@auda.org.au', '316-159-7550', '2 Maple Wood Lane', 'Nelson', '7010'),
	(31, 1, 'Alistair', 'Coverley', 'ecoverleyu@unblog.fr', '818-658-1449', '7 Eggendart Terrace', 'Nelson', '7040'),
	(32, 1, 'Elissa', 'Maple', 'emaplev@netscape.com', '316-355-5302', '636 Warner Crossing', 'Stoke', '7011'),
	(33, 1, 'Alastair', 'Todor', 'htodorw@i2i.jp', '835-195-0459', '446 Kensington Court', 'Stoke', '7011'),
	(34, 1, 'Fara', 'Heijnen', 'fheijnenx@sciencedaily.com', '115-162-2753', NULL, NULL, NULL),
	(35, 1, 'Terry', 'Bandy', 'tbandyy@bravesites.com', '588-213-7100', '5 Sheridan Trail', 'Nelson', '7040'),
	(36, 1, 'Elnora', 'Golston', 'egolstonz@miibeian.gov.cn', '256-741-7468', '0 Carberry Pass', 'Nelson', '7010'),
	(37, 1, 'Gavin', 'Mitchenson', 'gmitchenson10@ovh.net', '561-668-9200', '39 Lake View Alley', 'Nelson', '7010'),
	(38, 1, 'Sibylle', 'Cuttelar', 'scuttelar11@ask.com', '972-928-4653', '7885 Oneill Junction', 'Dunedin', '9012'),
	(39, 1, 'Mavra', 'Comazzo', 'mcomazzo12@freewebs.com', '384-572-2082', '48 Meadow Valley Hill', 'Dunedin', '9010'),
	(40, 1, 'Callie', 'De Roberto', 'cderoberto13@wiley.com', '163-439-3707', '0036 Eagle Crest Avenue', 'Nelson', '7010'),
	(41, 1, 'Joelie', 'Carriage', 'jcarriage14@tripadvisor.com', '241-553-5804', NULL, NULL, NULL),
	(42, 1, 'Giacomo', 'Iddons', 'giddons15@utexas.edu', '742-716-5574', '336 7th Trail', 'Stoke', '7011'),
	(43, 1, 'Dahlia', 'Rogliero', 'drogliero16@ucoz.ru', '848-821-0987', '854 Rockefeller Center', 'Nelson', '7010'),
	(44, 1, 'Frank', 'Gouldstone', 'fgouldstone17@imageshack.us', '838-135-7466', '1 Arapahoe Park', 'Nelson', '7010'),
	(45, 1, 'Carlynn', 'Morrilly', 'cmorrilly18@phoca.cz', '613-407-9269', '9771 Boyd Plaza', 'Nelson', '7010'),
	(46, 1, 'Ronni', 'Pattrick', 'rpattrick19@ox.ac.uk', '221-220-8778', '47 Butternut Parkway', 'Nelson', NULL),
	(47, 1, 'Yuma', 'Armfirld', 'yarmfirld1a@unicef.org', '395-268-1436', '1 Merrick Center', 'Richmond', '7020'),
	(48, 1, 'Terese', 'Rogers', 'trogers1b@irs.gov', '692-488-6457', '694 Kensington Point', 'Richmond', '7020'),
	(49, 1, 'Reinhard', 'Jacobovitch', 'rjacobovitch1c@bizjournals.com', '431-715-2515', '061 Arkansas Terrace', NULL, NULL),
	(50, 1, 'Nonah', 'Deane', 'ndeane1d@paginegialle.it', '728-879-2382', NULL, NULL, NULL);

INSERT INTO `product` (branch_id, name, sku, price, created_date, description) VALUES
	 (2, 'Cabernet Sauvignon', 'CS-7343', 12.17, '2021-09-05 15:06:03', 'This blend contains Cabernet Sauvignon,  Merlot and Malbec. The nose is darkly perfumed and warm with nutmeg and cedar notes. The palate is fleshy and full with dark plums and sweet tarry notes.'), 
	 (1, 'Chardonnay', 'C-9395', 18.44, '2021-09-05 15:06:03', 'The wine has about 20% new oak,  all up,  which adds smoothness,  creamy notes and complexity. A great value Chardonnay'), 
	 (1, 'Pinot Gris', 'PG-1092', 25.48, '2021-09-05 15:06:03', 'A lively,  lovely off dry Pinot Gris made in a super popular style,  offering good value'), 
	 (3, 'Gewürztraminer', 'PN-5963', 20.74, '2021-09-05 15:06:03', 'This is a very fragrant,  full-bodied Gewurztraminer. The nose is concentrated and intense,  with notes of rose petals,  Turkish delight,  musk and ginger.'), 
	 (1, 'Sauvignon Blanc', 'SB-9169', 13.04, '2021-09-05 15:06:03', 'This wine is light bodied and intensely fruity in taste with refreshing acidity adding zesty appeal to every sip. It is great value for money.'), 
	 (1, 'Riesling', 'R-0249', 18.44, '2021-09-05 15:06:03', ' It''s a succulent little number which rocks a lime zest flavour and drinks beautifully now but can age for at least a decade'), 
	 (1, 'Merlot', 'M-9180', 16.28, '2021-09-05 15:06:03', NULL), 
	 (3, 'Shiraz', 'S_0676', 24.93, '2021-09-05 15:06:03', NULL), 
	 (1, 'Pinot Noir', 'PN-1786', 31.09, '2021-09-05 15:06:03', NULL), 
	 (1, 'Semillon', 'SE-0069', 24.93, '2021-09-05 15:06:03', '');

INSERT INTO `ingredient` (`ingredient_id`, `name`, `unit`, `weight`) VALUES
	(1, 'Sugar', 'kg', 4.6),
	(2, 'Grapes', 'litre', 1.8),
	(3, 'Egg Whites', 'kg', 8.9),
	(4, 'Powdered tannins', 'kg', 8),
	(5, 'Sulfur dioxide', 'kg', 4.3),
	(6, 'Water', 'litre', 0.1),
	(7, 'Yeast', 'kg', 6),
	(8, 'Calcium carbonate', 'kg', 5.5),
	(9, 'Potassium metabisulfite', 'kg', 3.9),
	(10, 'Sulfur dioxide', 'kg', 6.7);

INSERT INTO `product_ingredient` (`product_id`, `ingredient_id`, `amount`) VALUES
	(1, 2, 4.1),
	(1, 6, 7.4),
	(2, 1, 2.2),
	(2, 2, 4.9),
	(2, 3, 1.4),
	(2, 4, 3.5),
	(2, 6, 1.2),
	(2, 7, 2.8),
	(3, 1, 6.5),
	(3, 2, 1.6),
	(3, 4, 6.4),
	(3, 7, 9.2),
	(3, 10, 3.1),
	(4, 1, 2.8),
	(4, 2, 6),
	(4, 3, 6.5),
	(4, 4, 2.5),
	(4, 5, 7.9),
	(4, 6, 4.3),
	(4, 8, 5.6),
	(5, 2, 1.5),
	(5, 3, 5.2),
	(5, 5, 3.3),
	(6, 9, 8.1),
	(7, 1, 7.6),
	(7, 2, 3.7),
	(7, 7, 2.9),
	(7, 9, 1.8),
	(8, 2, 8.8),
	(8, 3, 6.4),
	(8, 4, 2.3),
	(8, 6, 8),
	(8, 9, 6.7),
	(9, 3, 6.5),
	(9, 6, 3.1),
	(9, 7, 2.3),
	(9, 10, 5.1),
	(10, 2, 7.8);

INSERT INTO `order` (`order_id`, `customer_id`, `order_date`, `shipped_date`, `status`) VALUES
	(1, 11, '2021-07-21 00:00:00', '2021-07-22 00:00:00', 'Paid'),
	(2, 8, '2020-09-05 00:00:00', '2020-09-06 00:00:00', 'Paid'),
	(3, 2, '2021-07-07 00:00:00', '2021-07-08 00:00:00', 'Paid'),
	(4, 14, '2020-12-01 00:00:00', '2020-12-02 00:00:00', 'Paid'),
	(5, 10, '2021-07-17 00:00:00', '2021-07-19 00:00:00', 'Paid'),
	(6, 23, '2021-07-26 00:00:00', '2021-07-27 00:00:00', 'Paid'),
	(7, 24, '2021-02-25 00:00:00', '2021-02-26 00:00:00', 'Paid'),
	(8, 7, '2021-01-12 00:00:00', '2021-01-15 00:00:00', 'Paid'),
	(9, 28, '2021-08-09 00:00:00', '2021-08-10 00:00:00', 'Paid'),
	(10, 2, '2021-06-10 00:00:00', '2021-06-11 00:00:00', 'Paid'),
	(11, 28, '2021-06-15 00:00:00', '2021-06-16 00:00:00', 'Paid'),
	(12, 9, '2020-09-02 00:00:00', '2020-09-03 00:00:00', 'Paid'),
	(13, 17, '2021-08-12 00:00:00', '2021-08-14 00:00:00', 'Paid'),
	(14, 29, '2021-03-31 00:00:00', '2021-04-01 00:00:00', 'Paid'),
	(15, 27, '2020-09-05 00:00:00', '2020-09-08 00:00:00', 'Paid'),
	(16, 32, '2021-05-31 00:00:00', '2021-06-05 00:00:00', 'Paid'),
	(17, 4, '2020-12-25 00:00:00', '2020-12-26 00:00:00', 'Paid'),
	(18, 11, '2020-10-21 00:00:00', '2020-10-22 00:00:00', 'Paid'),
	(19, 8, '2021-04-16 00:00:00', '2021-04-29 00:00:00', 'Paid'),
	(20, 1, '2021-03-15 00:00:00', '2021-03-17 00:00:00', 'Paid'),
	(21, 2, '2021-08-06 00:00:00', '2021-08-07 00:00:00', 'Paid'),
	(22, 11, '2020-09-16 00:00:00', '2020-09-17 00:00:00', 'Paid'),
	(23, 28, '2020-11-19 00:00:00', '2020-11-20 00:00:00', 'Paid'),
	(24, 5, '2021-07-22 00:00:00', '2021-07-24 00:00:00', 'Paid'),
	(25, 11, '2021-03-16 00:00:00', '2021-03-19 00:00:00', 'Paid'),
	(26, 19, '2020-10-19 00:00:00', '2020-10-21 00:00:00', 'Paid'),
	(27, 13, '2020-09-03 00:00:00', '2020-09-05 00:00:00', 'Paid'),
	(28, 30, '2020-09-03 00:00:00', '2020-09-04 00:00:00', 'Paid'),
	(29, 10, '2020-09-03 00:00:00', '2020-09-06 00:00:00', 'Paid'),
	(30, 15, '2021-08-25 00:00:00', '2021-08-26 00:00:00', 'Paid'),
	(31, 16, '2020-11-01 00:00:00', '2020-11-02 00:00:00', 'Paid'),
	(32, 4, '2021-01-23 00:00:00', '2021-01-24 00:00:00', 'Paid'),
	(34, 35, '2020-12-02 00:00:00', NULL, 'Paid'),
	(33, 11, '2021-07-03 00:00:00', NULL, 'Unpaid'),
	(35, 16, '2021-07-17 00:00:00', NULL, 'Unpaid');

INSERT INTO `order_item` (`order_id`, `product_id`, `quantity`, `price`) VALUES
	(1, 8, 1, 24.93),
	(2, 7, 1, 16.28),
	(3, 9, 8, 31.09),
	(4, 5, 2, 13.04),
	(5, 5, 6, 13.04),
	(6, 2, 7, 14.32),
	(6, 5, 7, 13.04),
	(6, 6, 7, 16.44),
	(7, 1, 2, 12.17),
	(8, 4, 1, 20.74),
	(9, 7, 6, 16.28),
	(10, 4, 8, 20.74),
	(11, 9, 4, 31.09),
	(12, 5, 10, 13.04),
	(12, 6, 10, 16.44),
	(12, 7, 10, 16.28),
	(12, 8, 10, 24.93),
	(13, 3, 8, 25.48),
	(14, 2, 2, 18.44),
	(15, 7, 8, 16.28),
	(16, 1, 8, 12.17),
	(16, 2, 8, 18.44),
	(16, 10, 8, 24.93),
	(17, 6, 2, 18.44),
	(18, 9, 3, 31.09),
	(19, 3, 7, 25.48),
	(20, 5, 5, 13.04),
	(21, 7, 6, 16.28),
	(22, 1, 7, 12.17),
	(23, 7, 6, 16.28),
	(24, 5, 3, 13.04),
	(24, 7, 3, 16.28),
	(24, 8, 3, 24.93),
	(25, 2, 6, 17.32),
	(26, 2, 5, 18.44),
	(27, 10, 2, 24.93),
	(28, 7, 3, 16.28),
	(29, 9, 4, 30.09),
	(30, 1, 8, 12.17),
	(30, 2, 8, 18.44),
	(31, 4, 8, 20.74),
	(32, 3, 3, 25.48),
	(33, 7, 5, 16.28),
	(34, 3, 8, 25.48),
	(35, 2, 5, 18.44),
	(35, 10, 3, 24.93);

-- Q3
select customer_id, first_name, last_name, city
from customer
where city = 'Nelson' or city = 'Richmond'
order by first_name;
-- Q4
select customer_id, first_name, last_name, email, phone
from customer 
where street is NULL 
or city is NULL
or postal_code is NULL
order by first_name;
-- Q5 
select customer_id, first_name, last_name, email, phone
from customer 
where street is not null
and (city is null or postal_code is null)
order by first_name;
-- Q6
select customer_id, first_name, last_name
from customer 
where first_name like 'A%'
or first_name like 'B%'
order by first_name;
-- Q7
select distinct city
from customer
where city is not null
order by city ASC; 
-- Q8
select *
from product p
where branch_id = 1
order by name;
-- Q9
select name, price
from product 
where price >= 20
order by price desc;
-- Q10
select *
from `order` o
where order_date is not null and shipped_date is null;
-- Q11
select *
from `order` 
where order_date >= '2021-07-01' and order_date < '2021-08-01'
order by order_date desc;

-- Aggregate funcitons excercises
/*
 The difference between the two examples is the use of the conditial brackets,
 In the first example, the query returns any products from branch 2 that meet any of the conditions in the brackets.
 The second example returns data from only branch 2 if falling under the first price range, if the price differs from that range,
 then it returns data from any branch
 */
-- Q2
select count(product_id)
from product
where branch_id = 1;
-- Q3
select count(customer_id)
from customer
where city = 'Nelson' and postal_code is not null;
-- Q4
select distinct count(postal_code)
from customer;
-- Q5
select price * 3
from product
where branch_id = 3;
-- Q6
select min(price), max(price), avg(price)
from product;
-- Q7
select DATEDIFF(shipped_date, order_date)
from `order`
where order_date and shipped_date is not null;
-- Q8
select AVG(DATEDIFF(shipped_date, order_date))
from `order`
where order_date and shipped_date is not null;
-- Q9
select order_id, date_format(order_date, '%W %e %M %Y')
from `order`
where order_date is not null
group by order_id;
-- Q10
select order_date, count(order_id) as orders
from `order`
group by order_date
having orders > 1
order by orders desc;
-- Q11
select date_format(order_date, '%W') as `weekday`, count(order_id) as orders
from `order` 
group by `weekday`;
