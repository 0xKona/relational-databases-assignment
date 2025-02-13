-- INSERT DATA INTO BANK DB

-- START BY DELETING EXISTING DATA
-- NOTE: This is probably horribly unsafe and probably shouldn't be done like this
DELETE FROM depositor;
DELETE FROM account;
DELETE FROM branch;
DELETE FROM customer;

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

-- Insert Branches

INSERT INTO branch VALUES
    ("Downtown", "Brooklyn", 900000),
    ("Redwood", "Palo Alto", 2100000),
    ("Perryridge", "Horseneck", 1700000),
    ("Mianus", "Horseneck", 400200),
    ("Round Hill", "Horseneck", 8000000),
    ("Pownal", "Bennington", 400000),
    ("North Town", "Rye", 3700000),
    ("Brighton", "Brooklyn", 7000000),
    ("Central", "Rye", 400280);

-- Insert Accounts

INSERT INTO account VALUES 
    ('A-101', 'Downtown', 500), 
    ('A-215', 'Mianus', 700),
    ('A-102', 'Perryridge', 400),
    ('A-305', 'Round Hill', 350),
    ('A-201', 'Perryridge', 900),
    ('A-222', 'Redwood', 700),
    ('A-217', 'Brighton', 750),
    ('A-333', 'Central', 850),
    ('A-444', 'North Town', 625);

-- Insert Deposits

INSERT INTO depositor VALUES
    ("Johnson", "A-101"),
    ("Smith", "A-215"),
    ("Hayes", "A-102"),
    ("Hayes", "A-101"),
    ("Turner", "A-305"),
    ("Johnson", "A-201"),
    ("Jones", "A-217"),
    ("Linday", "A-222"),
    ("Majeris", "A-333"),
    ("Smith", "A-444");