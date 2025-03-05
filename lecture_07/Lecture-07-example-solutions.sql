/* UoS - Relational Databases
Lecture-07-example-solutions.sql
 */
 
 
/* Lecture 07 Practical Solution Queries */

/* 1. Ordering the results of a query
-------------------------------------------------------------------

Use the ORDER BY clause in a SELECT expression to do the following: 

	1.1 order the customer table alphabetically by the customer’s name. */
      
SELECT * 
	FROM customer 
	ORDER BY customer_name; 


/* 1.2 order the account table starting with the highest balance. */

SELECT * 
	FROM account 
    ORDER BY balance DESC;

/* 2. Using aggregate functions: 
-------------------------------------------------------------------

	Use MAX, AVG and COUNT in a SELECT expression to do the following: 
	
	2.1 find the branch with the greatest assets. */
SELECT MAX(assets)
	FROM branch;

/* 	2.2 find the average balance of all accounts. */

SELECT AVG(balance)
    FROM account;

/* 	2.3 find how many branches are in the bank database. */

SELECT COUNT(branch_name) 
	FROM branch; 

/* 2.4	Use a function and a join to find the average balance 
		of accounts in Horseneck */

SELECT AVG(balance)
	FROM account, branch
	WHERE account.branch_name = branch.branch_name AND branch.branch_city = 'Horseneck'; 

/* 	2.5 Use a function and a GROUP BY clause to find how many 
		branches are in each city. */

SELECT COUNT(branch_name), branch_city 
    FROM branch
	GROUP BY branch_city; 

/* 	2.6	 Use a function and the GROUP BY and HAVING clauses to 
		find the city whose branches have an average assets of 
        greater than 2500000. */
        
SELECT branch_city, AVG(assets) 
	FROM branch
	GROUP BY branch_city
	HAVING AVG(assets) > 2500000; 

/* 2.7	The following query aims to find the number of customers at each branch */

SELECT branch_name, COUNT(customer_name)
	FROM depositor, account
	WHERE depositor.account_number = account.account_number 
    GROUP BY branch_name;

/* Try running the query. It will give the following results. 
branch_name	COUNT(customer_name)
Brighton	1 
Downtown	2
Mianus	1
North Town	1
Perryridge	2
Redwood	1
Round Hill	1

viii.	Now execute the following two SQL statements and run the query again. */

INSERT INTO account VALUES('A-103', 'Downtown', 250); 
INSERT INTO depositor VALUES('Hayes', 'A-103');

SELECT branch_name, COUNT(customer_name)
	FROM depositor, account
	WHERE depositor.account_number = account.account_number 
    GROUP BY branch_name;

/* Can you explain what is wrong with the results and how you 
   would rectify the situation? 
   
   Hayes is now counted twice. There aren’t 3 customers at Downtown, 
   there are two but Hayes has opened a new account at the branch. 
   To rectify the situation we must use DISTINCT: */
   
SELECT branch_name, COUNT(DISTINCT customer_name)
	FROM depositor, account
	WHERE depositor.account_number = account.account_number 
    GROUP BY branch_name;
    
/* 3. Set Membership
-------------------------------------------------------------------
	Rewrite the following queries from last week’s 
	practical using membership testing of a subquery i.e. the ‘in’ test. 
    
	3.1.	Where does the customer with account number A-102 live? */
    
SELECT customer_street, customer_city
	FROM customer
	WHERE customer_name IN (
		SELECT customer_name 
        FROM depositor 
        WHERE account_number = "A-102"); 

/* 	3.2		In what city is the branch where account number A-102 is held? */

SELECT branch_city
	FROM branch
	WHERE branch_name IN (
		SELECT branch_name 
			FROM account 
            WHERE account_number = "A-102"); 

/* 	3.3	 Use the ‘not in’ test to answer the following query: 
		List the accounts that are neither held in the city of 
        ‘Horseneck’ or the city of ‘Brooklyn’. */
        
SELECT account_number 
	FROM account 
    WHERE branch_name NOT IN (
		SELECT branch_name 
        FROM branch 
        WHERE branch_city = 'Horseneck' 
			OR branch_city = 'Brooklyn'); 

/* 4. Set Comparison: Using Set comparison
-------------------------------------------------------------------

	4.1. rewrite query xi using <> all and satisfy yourself 
		that this generated the same results. */
        
SELECT account_number 
	FROM account
	WHERE branch_name <> ALL (
		SELECT branch_name 
			FROM branch 
			WHERE branch_city = 'Horseneck' 
				OR branch_city = 'Brooklyn'); 

/* 	4.2 find what is the name of the branch with the greatest 
			assets, and what are those assets? */

SELECT branch_name, assets 
	FROM branch
	WHERE assets =(
		SELECT MAX(assets) 
			FROM branch); 
            
/* 4.3	Find the names of all branches that have assets greater 
		than those of at least one branch located in “Brooklyn”. */
        
SELECT branch_name 
	FROM branch
	WHERE assets > SOME (
		SELECT assets 
			FROM branch 
            WHERE branch_city = "Brooklyn"); 

/* 5. Updating the database: Perform the following modifications to 
the database using the UPDATE command.
-------------------------------------------------------------------
*/

/* 5.1.	Change Johnson’s address to Riverdale, Maryland */

UPDATE customer 
	SET customer_street = 'Riverdale' 
    WHERE customer_name = 'Johnson'; 
    
UPDATE customer 
	SET customer_city = 'Maryland' 
	WHERE customer_name = 'Johnson'; 

/* 5.2.	Increase account balances by 2% to reflect an 
		interest payment. 
		(Note: This may not work – go to edit > preferences >
        > sqleditor > untoggle safe updates and reconnect)*/

UPDATE account 
	SET balance = balance * 1.02;
    
SELECT * 
	FROM account; 

/* 5.3.	Now increase account balances by 5% on accounts 
			whose balance is greater than 500 */
            
UPDATE account 
	SET balance = balance * 1.05  
	WHERE balance > 500;


/* 6. Creating views 
-------------------------------------------------------------------

The advantage of creating a virtual view of your tables was 
	discussed during lecture today. To do this is MySQL Workbench 
    you can either click Add View in the Object Browser or in the 
    Overview tab. Once done you are presented with the new_view 
    dialog box. You will see the following SQL in the DDL area 
    
CREATE VIEW your_table.new_view AS 

	Rename your view by replacing ‘new_view’ with your choice of 
    name. A complete query expression can be put after AS. So for example 
    
CREATE VIEW bank.allbranches AS (
	SELECT * 
		FROM branch);
 
	<allbranches> appears as a view and double clicking it results 
    in all columns from branch being displayed. 
    
    6.1 Choose two queries that you have implemented today and create 
    views for them as described. */
    
CREATE VIEW bank.brancheslist AS (
	SELECT branch_name 
		FROM branch
		WHERE assets > SOME (
			SELECT assets 
				FROM branch 
				WHERE branch_city = "Brooklyn")
);

SELECT * 
	FROM brancheslist;
    
CREATE VIEW branches_per_city AS (
SELECT COUNT(branch_name), branch_city 
    FROM branch
	GROUP BY branch_city
    );

SELECT *
	FROM branches_per_city;

