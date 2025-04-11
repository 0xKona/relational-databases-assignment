USE marketplace;

-- Look at user permissions
SHOW GRANTS FOR 'root'@'localhost';
SHOW GRANTS FOR 'app_user'@'%';
SHOW GRANTS FOR 'readonly_user'@'%';
SHOW GRANTS FOR 'market_admin'@'127.0.0.1';

-- Gets number of accounts
SELECT count(account_id) from public_account;

-- Get non-private account data
SELECT * FROM public_account;

-- Finds user based on username
SELECT * FROM public_account WHERE username = 'AliceGamer';

-- Show all genres
SELECT genre_name FROM genre;

-- Select all games
SELECT * FROM game;

-- See games that 'AliceGamer' has in her library
WITH user_id AS (
	SELECT account_id
	FROM account
	WHERE username = 'AliceGamer'
),
games_ids_owned AS (
	SELECT game
	FROM account_games
	WHERE account IN (SELECT account_id FROM account WHERE username = 'AliceGamer')
) 
SELECT allgames.*
FROM game allgames
JOIN games_ids_owned owned ON allgames.game_id = owned.game;

-- See games that 'BobDev' has in her library (None)
WITH games_ids_owned AS (
	SELECT game
	FROM account_games
	WHERE account IN (SELECT account_id FROM account WHERE username = 'BobDev')
) 
SELECT allgames.*
FROM game allgames
JOIN games_ids_owned owned ON allgames.game_id = owned.game;

-- See games that 'CarolPlays' has in her library
WITH games_ids_owned AS (
	SELECT game
	FROM account_games
	WHERE account IN (SELECT account_id FROM account WHERE username = 'CarolPlays') 
) 
SELECT allgames.*
FROM game allgames
JOIN games_ids_owned owned ON allgames.game_id = owned.game;

-- Find games that both 'AliceGamer and CarolPlays own (So users can easily find games they can both play)
CALL FindCommonGames('AliceGamer', 'CarolPlays'); 

-- Find games not owned by account_id (available for purchase)
CALL FindUnownedGamesByID(1);
CALL FindUnownedGamesByID(2);
CALL FindUnownedGamesByID(3);

-- Login query, will return the public_account details if there is a match that can be then processed by the login server
SELECT * 
FROM public_account
WHERE account_id = (
    SELECT account_id 
    FROM account
    WHERE username = 'BobDev'
      AND password_hash = 'b06779c4959295605d26f9e7eb06356d5b5c6b1bd10cc28da75931f06997c601'
);

-- Get a list of the users friends by account_id using a stored procedure
CALL GetFriendsByAccountID(1);
CALL GetFriendsByAccountID(2); -- No friends
CALL GetFriendsByAccountID(3);









