CREATE DATABASE IF NOT EXISTS bank;
use bank;

DROP TABLE IF EXISTS depositor;
DROP TABLE IF EXISTS account;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS branch;


CREATE TABLE IF NOT EXISTS customer (
  customer_name VARCHAR(20),
  customer_street VARCHAR(30),
  customer_city VARCHAR(30),
  PRIMARY KEY(customer_name)
);

CREATE TABLE IF NOT EXISTS branch (
  branch_name VARCHAR(20),
  branch_city VARCHAR(20),
  assets int,
  PRIMARY KEY(branch_name)
);

CREATE TABLE IF NOT EXISTS account (
  account_number VARCHAR(10),
  branch_name VARCHAR(15),
  balance numeric(12,2),
  PRIMARY KEY (account_number),
  FOREIGN KEY (branch_name) REFERENCES branch(branch_name)
);

CREATE TABLE  IF NOT EXISTS depositor (
  customer_name VARCHAR(20),
  account_number VARCHAR(10),
  FOREIGN KEY (customer_name) REFERENCES customer(customer_name),
  FOREIGN KEY (account_number) REFERENCES account(account_number),
  PRIMARY KEY (customer_name, account_number)
  -- Could also use:   UNIQUE (customer_name, account_number)
);

INSERT INTO customer VALUES('Smith',	'North',	'Horseneck');
INSERT INTO customer VALUES('Hayes',	'Main',	'Harrison');
INSERT INTO customer VALUES('Curry',	'North',	'Horseneck');
INSERT INTO customer VALUES('Lindsay',	'Park',	'Pittsfield');
INSERT INTO customer VALUES('Turner',	'Putnam',	'Stamford');
INSERT INTO customer VALUES('Williams',	'Nassau',	'Princeton');
INSERT INTO customer VALUES('Adams',	'Spring',	'Pittsfield');
INSERT INTO customer VALUES('Johnson',	'Alma',	'Palo Alto');
INSERT INTO customer VALUES('Glenn',	'Sand Hill',	'Woodside');
INSERT INTO customer VALUES('Brooks',	'Senator',	'Brooklyn');
INSERT INTO customer VALUES('Green',	'Walnut',	'Stamford');
INSERT INTO customer VALUES('Majeris',	'	Cherry',	'Brooklyn');
INSERT INTO customer VALUES('Jones','Main','Harrison');

INSERT INTO branch VALUES('Downtown',	'Brooklyn',	900000);
INSERT INTO branch VALUES('Redwood',	'Palo Alto',	2100000);
INSERT INTO branch VALUES('Perryridge',	'Horseneck',	1700000);
INSERT INTO branch VALUES('Mianus',	'Horseneck',	400200);
INSERT INTO branch VALUES('Round Hill',	'Horseneck',	8000000);
INSERT INTO branch VALUES('Pownal',	'Bennington',	400000);
INSERT INTO branch VALUES('North Town',	'Rye',	3700000);
INSERT INTO branch VALUES('Brighton',	'Brooklyn',	7000000);
INSERT INTO branch VALUES('Central',	'Rye',	400280);

INSERT INTO account VALUES ('A-101',	'Downtown',	500);
INSERT INTO account VALUES ('A-215',	'Mianus',	700);
INSERT INTO account VALUES ('A-102',	'Perryridge',	400);
INSERT INTO account VALUES ('A-305',	'Round Hill',	350);
INSERT INTO account VALUES ('A-201',	'Perryridge',	900);
INSERT INTO account VALUES ('A-222',	'Redwood',	700);
INSERT INTO account VALUES ('A-217',	'Brighton',	750);
INSERT INTO account VALUES ('A-333',	'Central',	850);
INSERT INTO account VALUES ('A-444',	'North Town',	625);

INSERT INTO depositor VALUES('Johnson',	'A-101');
INSERT INTO depositor VALUES('Smith',	'A-215');
INSERT INTO depositor VALUES('Hayes',	'A-102');
INSERT INTO depositor VALUES('Hayes',	'A-101');
INSERT INTO depositor VALUES('Turner',	'A-305');
INSERT INTO depositor VALUES('Johnson',	'A-201');
INSERT INTO depositor VALUES('Jones',	'A-217');
INSERT INTO depositor VALUES('Lindsay',	'A-222');
INSERT INTO depositor VALUES('Majeris',	'A-333');
INSERT INTO depositor VALUES('Smith',	'A-444');
