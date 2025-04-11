-- Stored Procedures

USE marketplace;

-- Stored Procedure for updating a users picture
DROP PROCEDURE IF EXISTS UpdateAccountPicture;
DELIMITER $$
CREATE PROCEDURE UpdateAccountPicture(IN username_param VARCHAR(45), IN hpassword_param CHAR(64), IN new_url_param VARCHAR(200))
BEGIN
    UPDATE account
    SET profile_pic_url = new_url_param
    WHERE username = username_param
      AND password_hash = hpassword_param;
END$$
DELIMITER ;

-- Stored Procedure to find common games
DROP PROCEDURE IF EXISTS FindCommonGames;
DELIMITER $$
CREATE PROCEDURE FindCommonGames(IN user1_param VARCHAR(45), IN user2_param VARCHAR(45))
BEGIN
	WITH user1_games AS (
		SELECT game
		FROM account_games
		WHERE account = (SELECT account_id FROM public_account WHERE username = user1_param)
	),
	user2_games AS (
		SELECT game
		FROM account_games
		WHERE account = (SELECT account_id FROM public_account WHERE username = user2_param)
	),
	shared_games AS (
		SELECT game
		FROM user1_games
		INNER JOIN user2_games USING (game)
	)
	SELECT g.*
	FROM game g
	JOIN shared_games sg ON g.game_id = sg.game;
END$$
DELIMITER ;

-- Stored procedure to find unowned games
DROP PROCEDURE IF EXISTS FindUnownedGamesByID;
DELIMITER $$
CREATE PROCEDURE FindUnownedGamesByID(IN account_id_param INT)
BEGIN
	WITH games_owned AS (
		SELECT
			game AS owned_game_id
		FROM account_games
		WHERE account = account_id_param
	)
	SELECT *
	FROM game g
	WHERE NOT EXISTS (
		SELECT 1
		FROM games_owned go
		WHERE g.game_id = go.owned_game_id
	);
END $$
DELIMITER ;


-- Returns a list of friends an account has
DROP PROCEDURE IF EXISTS GetFriendsByAccountID;
DELIMITER $$
CREATE PROCEDURE GetFriendsByAccountID(IN account_id_param INT)
BEGIN
    -- Find friend IDs
    WITH friend_ids AS (
        SELECT account2 AS friend_id
        FROM friends
        WHERE account1 = account_id_param

        UNION

        SELECT account1 AS friend_id
        FROM friends
        WHERE account2 = account_id_param
    )

    -- Select friend details
    SELECT a.*
    FROM account a
    INNER JOIN friend_ids f ON a.account_id = f.friend_id;
END$$
DELIMITER ;

-- Soft delete account in accordance with UK GDPR
DROP PROCEDURE IF EXISTS SoftAccountDelete;
DELIMITER $$
CREATE PROCEDURE SoftAccountDelete(IN account_id_param INT, IN hashed_email TEXT)
BEGIN
    UPDATE account
        SET
          email = hashed_email, -- SAVE A HASHED EMAIL IN CASE OF ACCOUNT RECOVERY
          username = CONCAT('deleted_user_', account_id),
          password_hash = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
          profile_pic_url = NULL,
          active_account = 0
        WHERE account_id = account_id_param;
END $$
DELIMITER ;

-- Full Delete after data retention period (1-2 years for audit purposes)
DROP PROCEDURE IF EXISTS FullAccountDelete;
DELIMITER $$
CREATE PROCEDURE FullAccountDelete(IN account_id_param INT)
BEGIN
   DELETE FROM account WHERE account_id = account_id_param;
END $$
DELIMITER ;





