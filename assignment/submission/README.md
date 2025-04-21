README — Database Implementation Submission
==========================================

Student ID: s183038  
Module: Relational Databases  
Assignment: Assessment 2 — Database Implementation

Overview:
---------
This submission contains the full implementation of the Online video game marketplace relational database, based on the design from Assessment 1. It includes the schema, test data, query scripts, and a database dump file. All components were developed and tested using MySQL 9.2 in a Dockerized environment to ensure consistency.

Contents:
---------
1. report.pdf
2. create_schema.sql
3. test_data.sql
4. queries.sql
5. marketplace_dump_<TIMESTAMP_OF_DUMP>.sql
6. generate_test_data.py
   - Python script used to generate additional test data using the Faker library.

Environment Notes:
------------------
- Developed using Docker with MySQL 9.2.
- Scripts are fully compatible with MySQL Workbench or any standard MySQL 9.2 environment.
- To restore the dump:
    mysql -u root -p marketplace < marketplace_dump.sql

Instructions:
-------------
1. Run `create_schema.sql` to create the database and all objects.
2. Run `test_data.sql` to populate tables with the base sample data.
3. Run `additional_generated_test_data.sql` to populate tables with the extra generated sample data.
4. Run `queries.sql` to run the SELECT, UPDATE and DELETE queries.
5. `marketplace_dump.sql` can be imported directly for quick inspection.