USE marketplace;

-- Gets number of accounts
SELECT count(account_id) from public_account;

-- Get non-private account data
SELECT * FROM public_account;

-- Finds user based on username
SELECT * FROM public_account WHERE username = 'user9856';

-- Show all genres
SELECT genre_name FROM genre

