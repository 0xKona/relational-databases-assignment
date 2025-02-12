-- INSERT DATA INTO BANK DB

-- START BY DELETING EXISTING DATA
-- NOTE: This is probably horribly unsafe and probably shouldn't be done like this
DELETE FROM branch;
DELETE FROM customer;


-- Insert a Branch.
INSERT INTO branch VALUES ("Natwest", "Natwest Street", 50);


-- Insert customer data

INSERT INTO customer VALUES 
    ("Smith", "North", "Horseneck"),
    ("Hayes", "Main", "Harrison"),
    ("Curry", "North", "Horseneck"),
    ("Linday", "Park", "Pittsfield"),
    ("Turner", "Putnam", "Stamford"),
    ("Williams", "Nassau", "Princeton"),
    ("Adams", "Spring", "Pittsfield"),
    ("Johnson", "Alma", "Palo Alto"),
    ("Glenn", "Sand Hill", "Woodside"),
    ("Majeris", "Cherry", "Brooklyn"),
    ("Brooks", "Senator", "Brooklyn"),
    ("Green", "Walnut", "Stamford"),
    ("Jones", "Main", "Harrison");