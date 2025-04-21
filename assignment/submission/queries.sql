USE marketplace;

-- ----------------------------------------------------------------
-- SELECT QUERIES
-- ----------------------------------------------------------------

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
EXPLAIN WITH user1_games AS (
		SELECT game
		FROM account_games
		WHERE account = (SELECT account_id FROM public_account WHERE username = 'AliceGamer')
	),
	user2_games AS (
		SELECT game
		FROM account_games
		WHERE account = (SELECT account_id FROM public_account WHERE username = 'CarolPlays')
	),
	shared_games AS (
		SELECT game
		FROM user1_games
		INNER JOIN user2_games USING (game)
	)
	SELECT g.*
	FROM game g
	JOIN shared_games sg ON g.game_id = sg.game;

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
CALL GetFriendsByAccountID(2);
CALL GetFriendsByAccountID(3);

-- Get a list of distinct usernames of users who have written reviews, ordered alphabetically in reverse
SELECT DISTINCT a.username
FROM review r
JOIN account a ON r.written_by = a.account_id
ORDER BY a.username DESC;

-- Show the user with the oldest account by calculating the age of each account
SELECT username, DATEDIFF(CURDATE(), account_created) AS account_age_days
FROM account
WHERE account_created IS NOT NULL
ORDER BY account_age_days DESC
LIMIT 1;

-- Show how many reviews each game has, but only include games with more than 1 review
SELECT g.name, COUNT(r.review_id) AS review_count
FROM review r
JOIN game g ON g.game_id = r.game
GROUP BY g.name
HAVING review_count > 1;

-- Get the 5 most recently released games
SELECT name, release_date
FROM game
ORDER BY release_date DESC
LIMIT 5;

-- View execution plan to verify indexes are being used
EXPLAIN SELECT g.name
FROM game g
JOIN publisher p ON g.publisher = p.publisher_id
WHERE p.publisher_name = 'Indie Galaxy';

-- View structure of the review table
DESCRIBE review;

-- ----------------------------------------------------------------
-- UPDATE QUERIES
-- ----------------------------------------------------------------

-- Query to update an account email ONLY when the provided username and hashed password match what is stored
UPDATE account
SET email = 'aliceupdated@example.com'
WHERE username = 'AliceGamer'
	AND password_hash = 'b06779c4959295605d26f9e7eb06356d5b5c6b1bd10cc28da75931f06997c601';

-- Similar to the above query but using a stored procedure instead to update the profile picture
CALL UpdateAccountPicture('AliceGamer', 'b06779c4959295605d26f9e7eb06356d5b5c6b1bd10cc28da75931f06997c601', 'www.newpfp.example.com');

-- Update the last login (could be fired upon a successful login)
UPDATE account
SET last_login = NOW()
WHERE username = 'BobDev'
  AND password_hash = 'b06779c4959295605d26f9e7eb06356d5b5c6b1bd10cc28da75931f06997c601';

-- Soft delete a user by updating active_account and setting a deletion date
UPDATE account
SET active_account = 0, deleted_on = NOW()
WHERE username = 'AliceGamer';


-- ----------------------------------------------------------------
-- DELETE QUERIES
-- ----------------------------------------------------------------

-- Delete friend
DELETE FROM friends
WHERE (account1 = LEAST(1, 3) AND account2 = GREATEST(1, 3));

-- Delete an account
-- email hash would be generated by server in reality
CALL SoftAccountDelete(2, 'example_email_hash');

-- Delete account fully after retention period
CALL FullAccountDelete(2);

-- Delete a review that has an offensive message (example condition)
DELETE FROM review
WHERE review_text LIKE '%offensive%';











