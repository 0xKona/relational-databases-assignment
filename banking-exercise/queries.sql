-- QUERY STATEMENTS

-- GET ALL CUSTOMER ON NORTH STREET
SELECT * FROM customer WHERE customer_street="North";

-- GET ALL DISTINCT BRANCHES (EACH ONE APPEARS ONCE LIKE A SET)
SELECT DISTINCT branch_city FROM branch;

-- DOX Glenn
SELECT customer_street, customer_city FROM customer WHERE customer_name="Glenn";