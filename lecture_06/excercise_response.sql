/* General Table Query */
SELECT * FROM department;
SELECT * FROM dependent;
SELECT * FROM dept_locations;
SELECT * FROM employee;
SELECT * FROM project;
SELECT * FROM works_on;

/* i Retrieve the birth date and address of employees whose name is 'Billie J King' */
SELECT address, bdate FROM employee WHERE fname = 'Billie' AND minit = 'J' AND lname = 'King';

/* ii Using a natural join (via SELECT) retrieve the name and address of all employees
who work for the Research department. (Two tables required) */
SELECT fname, minit, lname, address FROM employee NATURAL JOIN department WHERE dname = 'Research';

/* iii This time use an IN condition on a sub query to answer the query detailed in ii above. */
SELECT fname, minit, lname, address FROM employee WHERE dno IN (SELECT dno FROM department WHERE dname = 'Research');

/* iv Retrieve the name and address of all employees who work on Database Systems.
(Three tables required) */
SELECT fname, minit, lname, address FROM employee LEFT JOIN works_on ON employee.ninumber = works_on.ninumber WHERE pno IN (SELECT pno FROM project WHERE pname = 'Database Systems');

/* v This time use the EXISTS clause on a sub query to answer the query detailed in iv
above. */
SELECT fname, minit, lname, address FROM employee LEFT JOIN works_on ON employee.ninumber = works_on.ninumber WHERE EXISTS (SELECT pno FROM project WHERE works_on.pno = project.pno AND pname = 'Database Systems');

/* vi Find the names of employees who have dependents born in the 1970’s. (Use
substring matching) */
SELECT * FROM employee WHERE EXISTS (SELECT ninumber FROM dependent WHERE employee.ninumber = dependent.ninumber AND dependent.bdate LIKE '197%');

/* vii Retrieve the salary of every employee in a column called 'Employee’s Salaries'. */














