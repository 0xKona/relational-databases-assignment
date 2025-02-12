-- SETUP TABLES FOR BANK DB

CREATE DATABASE IF NOT EXISTS bank;

CREATE TABLE IF NOT EXISTS branch (
	branch_name VARCHAR(100) NOT NULL,
    branch_city VARCHAR(50) NOT NULL,
    assets NUMERIC(12, 2),
    PRIMARY KEY (branch_name)
);

CREATE TABLE IF NOT EXISTS customer (
	customer_name VARCHAR(100) NOT NULL,
    customer_street VARCHAR(100) NOT NULL,
    customer_city VARCHAR(50) NOT NULL,
    PRIMARY KEY (customer_name)
);

CREATE TABLE IF NOT EXISTS account (
	account_number VARCHAR(10),
    branch_name VARCHAR(100),
    balance NUMERIC(12,2),
    PRIMARY KEY (account_number),
    FOREIGN KEY (branch_name) REFERENCES branch(branch_name)
);

CREATE TABLE IF NOT EXISTS depositor (
	customer_name VARCHAR(100) NOT NULL,
    account_number VARCHAR(10),
    PRIMARY KEY (customer_name, account_number),
    FOREIGN KEY (customer_name) REFERENCES customer(customer_name),
    FOREIGN KEY (account_number) REFERENCES account(account_number)
);