-- ORDERING

-- Order customer table by customers name
SELECT * FROM customer ORDER BY customer_name;

-- Order the account table starting with the highest balance
SELECT * FROM account ORDER BY balance DESC;

-- ---------------------------------------------------------------------------------------------------
-- AGGREGATE FUNCTIONS

-- Find the branch with the greatest assets.
SELECT branch_name, assets FROM branch WHERE assets = (SELECT MAX(assets) FROM branch);

-- Find the average balance of all accounts.
SELECT AVG(balance) AS average_balance FROM account;

-- Find how many branches are in the bank database.
SELECT COUNT(branch_name) AS number_of_branches FROM branch;

-- Use a function and a join to find the average balance of accounts in Horseneck
SELECT AVG(balance) AS average_balance FROM account INNER JOIN branch ON account.branch_name = branch.branch_name WHERE branch_city = "Horseneck";

-- Use a function and a GROUP BY clause to find how many branches are in each city.
SELECT branch_city, COUNT(branch_name) AS num_branches FROM branch GROUP BY branch_city;

-- Use a function and the GROUP BY and HAVING clauses to find the city whose branches have an average assets of greater than 2,500,000.
SELECT branch_city, AVG(assets) AS avg_assets FROM branch GROUP BY branch_city; -- avg assets by city
SELECT branch_city, AVG(assets) AS avg_assets FROM branch GROUP BY branch_city HAVING avg_assets > 2500000; -- avg assets by city above 2,500,000









