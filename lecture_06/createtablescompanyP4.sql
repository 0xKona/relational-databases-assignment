/* UoS - Relational Databases
createtablescompanyP4.sql
Run this before you run inserttablescompanyP4.sql
 */

/* Create the database */
DROP DATABASE IF EXISTS companies;
CREATE DATABASE companies;
USE companies;

/* Create the department table with its attributes */
DROP TABLE IF EXISTS department;
CREATE TABLE IF NOT EXISTS department(dno varchar(4), dname varchar(25),
primary key (dno),
INDEX (dno));

/* Create the employee table with its attributes */
DROP TABLE IF EXISTS employee;
CREATE TABLE IF NOT EXISTS employee(ninumber varchar(12),fname varchar(15),minit varchar(1),
lname varchar(15), bdate date, address varchar(50), sex char, salary decimal(10,2), superNINumber varchar(12), dno varchar(4),
primary key (ninumber),
foreign key (dno) references department(dno),
foreign key (superNINumber) references employee(NINumber),
index (ninumber));

/* Create the project table with its attributes */
DROP TABLE IF EXISTS project;
CREATE TABLE IF NOT EXISTS project(pno varchar(4), pname varchar(25),
plocation  varchar(15),dno varchar(4),
primary key (pno),
INDEX (pno),
foreign key (dno) references department(dno));

/* Create the dependent table with its attributes */
DROP TABLE IF EXISTS dependent;
CREATE TABLE IF NOT EXISTS dependent(ninumber varchar(12),dependent_name varchar(15),
sex char, bdate date, relationship varchar(8),
primary key (ninumber, dependent_name),
foreign key (ninumber) references employee(ninumber));

/* Create the dept_locations table with its attributes */
DROP TABLE IF EXISTS dept_locations;
CREATE TABLE IF NOT EXISTS dept_locations(dno varchar(4), dlocation varchar(15), 
primary key (dno,dlocation),
foreign key (dno) references department(dno));

/* Create the works_on table with its attributes */
DROP TABLE IF EXISTS works_on;
CREATE TABLE  IF NOT EXISTS works_on(ninumber varchar(12), pno varchar(4),hours decimal(4,1),
primary key (ninumber,pno),
foreign key (ninumber) references employee(ninumber ),
foreign key (pno) references project(pno));




