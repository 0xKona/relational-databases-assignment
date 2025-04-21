-- -----------------------------------------------------
-- S183038 Schema: Marketplace
-- -----------------------------------------------------
DROP DATABASE IF EXISTS marketplace;
CREATE DATABASE IF NOT EXISTS marketplace;
USE marketplace;
-- -----------------------------------------------------
-- Table account
-- -----------------------------------------------------
DROP TABLE IF EXISTS `account` ;

CREATE TABLE IF NOT EXISTS `account` (
  `account_id` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(320) NOT NULL,
  `username` VARCHAR(45) NOT NULL,
  `password_hash` CHAR(64) NOT NULL, -- SHA-256
  `profile_pic_url` VARCHAR(200) NULL,
  `account_banned` TINYINT NULL,
  `account_created` DATETIME NULL,
  `last_login` DATETIME NULL,
  `active_account` TINYINT NOT NULL DEFAULT 1,
  `deleted_on` DATETIME NULL,
  PRIMARY KEY (`account_id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  UNIQUE INDEX `account_id_UNIQUE` (`account_id` ASC));

-- ----------------------------------------------------------
-- Public account - To keep email and hashed password private
-- ----------------------------------------------------------
CREATE VIEW public_account AS
	SELECT `account_id`, `username`, `profile_pic_url`, `last_login`
	FROM `account`;

-- -----------------------------------------------------
-- Table publisher
-- -----------------------------------------------------
DROP TABLE IF EXISTS `publisher`;

CREATE TABLE IF NOT EXISTS `publisher` (
  `publisher_id` INT NOT NULL AUTO_INCREMENT,
  `publisher_name` VARCHAR(50) NOT NULL,
  `bio` VARCHAR(500) NULL,
  `publisher_admin` INT NULL,
  PRIMARY KEY (`publisher_id`),
  UNIQUE INDEX `publisher_id_UNIQUE` (`publisher_id` ASC) VISIBLE,
  INDEX `publisher_admin_idx` (`publisher_admin` ASC) VISIBLE,
  CONSTRAINT `publisher_admin`
    FOREIGN KEY (`publisher_admin`)
    REFERENCES `marketplace`.`account` (`account_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE);

-- -----------------------------------------------------
-- Table system_requirements
-- -----------------------------------------------------
DROP TABLE IF EXISTS `system_requirements`;

CREATE TABLE IF NOT EXISTS `system_requirements` (
  `requirements_id` INT NOT NULL AUTO_INCREMENT,
  `mac` TINYINT NULL,
  `windows` TINYINT NULL,
  `linux` TINYINT NULL,
  `min_cpu` VARCHAR(50) NULL,
  `min_memory` VARCHAR(8) NULL,
  `min_gpu` VARCHAR(50) NULL,
  `storage` VARCHAR(8) NULL,
  PRIMARY KEY (`requirements_id`));


-- -----------------------------------------------------
-- Table game
-- -----------------------------------------------------
DROP TABLE IF EXISTS `game`;

CREATE TABLE IF NOT EXISTS `game` (
  `game_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `desc` VARCHAR(1000) NULL,
  `multiplayer` TINYINT NULL,
  `publisher` INT NULL,
  `release_date` DATETIME NULL,
  `system_requirements` INT NULL,
  `price` DECIMAL(10, 2) NULL,
  `available` TINYINT NOT NULL DEFAULT 1,
  PRIMARY KEY (`game_id`),
  UNIQUE INDEX `game_id_UNIQUE` (`game_id` ASC) VISIBLE,
  INDEX `publisher_idx` (`publisher` ASC) VISIBLE,
  INDEX `system_requirements_idx` (`system_requirements` ASC) VISIBLE,
  CONSTRAINT `game_publisher`
    FOREIGN KEY (`publisher`)
    REFERENCES `publisher` (`publisher_id`)
    ON DELETE SET NULL
    ON UPDATE NO ACTION,
  CONSTRAINT `system_requirements`
    FOREIGN KEY (`system_requirements`)
    REFERENCES `system_requirements` (`requirements_id`)
    ON DELETE SET NULL
    ON UPDATE NO ACTION,
  UNIQUE(`name`));


-- -----------------------------------------------------
-- Table `marketplace`.`review`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `review` ;

CREATE TABLE IF NOT EXISTS `review` (
  `review_id` INT NOT NULL AUTO_INCREMENT,
  `written_by` INT NOT NULL,
  `game` INT NOT NULL,
  `review_text` VARCHAR(500) NULL,
  `rating` INT NULL,
  PRIMARY KEY (`review_id`),
  UNIQUE INDEX `review_id_UNIQUE` (`review_id` ASC) VISIBLE,
  INDEX `written_by_idx` (`written_by` ASC) VISIBLE,
  INDEX `game_idx` (`game` ASC) VISIBLE,
  CONSTRAINT `written_by`
    FOREIGN KEY (`written_by`)
    REFERENCES `account` (`account_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `review_game`
    FOREIGN KEY (`game`)
    REFERENCES `game` (`game_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `marketplace`.`genre`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `genre` ;

CREATE TABLE IF NOT EXISTS `genre` (
  `genre_id` INT NOT NULL AUTO_INCREMENT,
  `genre_name` VARCHAR(20) NULL,
  PRIMARY KEY (`genre_id`),
  UNIQUE INDEX `genre_id_UNIQUE` (`genre_id` ASC) VISIBLE);


-- -----------------------------------------------------
-- Table `marketplace`.`game_genres`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `game_genres` ;

CREATE TABLE IF NOT EXISTS `game_genres` (
  `game` INT NOT NULL,
  `genre` INT NOT NULL,
  PRIMARY KEY (`game`, `genre`),
  INDEX `genre_idx` (`genre` ASC) VISIBLE,
  CONSTRAINT `game_genre_game`
    FOREIGN KEY (`game`)
    REFERENCES `game` (`game_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `game_genre_genre`
    FOREIGN KEY (`genre`)
    REFERENCES `genre` (`genre_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- -----------------------------------------------------
-- Table `marketplace`.`game_ban`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `game_ban` ;

CREATE TABLE IF NOT EXISTS `game_ban` (
  `ban_id` INT NOT NULL AUTO_INCREMENT,
  `account` INT NULL,
  `game` INT NULL,
  `reason` VARCHAR(50) NULL,
  `expires` DATETIME NULL,
  `started` DATETIME NULL,
  PRIMARY KEY (`ban_id`),
  UNIQUE INDEX `ban_id_UNIQUE` (`ban_id` ASC) VISIBLE,
  INDEX `account_idx` (`account` ASC) VISIBLE,
  INDEX `game_idx` (`game` ASC) VISIBLE,
  CONSTRAINT `ban_account`
    FOREIGN KEY (`account`)
    REFERENCES `account` (`account_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `ban_game`
    FOREIGN KEY (`game`)
    REFERENCES `game` (`game_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `marketplace`.`account_games`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `account_games` ;

CREATE TABLE IF NOT EXISTS `account_games` (
  `account` INT NOT NULL,
  `game` INT NOT NULL,
  PRIMARY KEY (`account`, `game`),
  INDEX `game_idx` (`game` ASC) VISIBLE,
  CONSTRAINT `account`
    FOREIGN KEY (`account`)
    REFERENCES `account` (`account_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `game`
    FOREIGN KEY (`game`)
    REFERENCES `game` (`game_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `marketplace`.`chat`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `chat` ;

CREATE TABLE IF NOT EXISTS `chat` (
  `chat_id` INT NOT NULL AUTO_INCREMENT,
  `chat_name` VARCHAR(30) NULL,
  `chat_image_url` VARCHAR(200) NULL,
  PRIMARY KEY (`chat_id`));


-- -----------------------------------------------------
-- Table `marketplace`.`user_in_chat`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `user_in_chat` ;

CREATE TABLE IF NOT EXISTS `user_in_chat` (
  `chat_id` INT NOT NULL,
  `account` INT NOT NULL,
  PRIMARY KEY (`chat_id`, `account`),
  INDEX `account_idx` (`account` ASC) VISIBLE,
  CONSTRAINT `user_in_chat_chat_id`
    FOREIGN KEY (`chat_id`)
    REFERENCES `chat` (`chat_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `user_in_chat_account`
    FOREIGN KEY (`account`)
    REFERENCES `account` (`account_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `marketplace`.`message`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `message` ;

CREATE TABLE IF NOT EXISTS `message` (
  `message_id` INT NOT NULL AUTO_INCREMENT,
  `sent_by` INT NULL,
  `chat_id` INT NULL,
  `text` VARCHAR(200) NULL,
  `timestamp` DATETIME NULL,
  PRIMARY KEY (`message_id`),
  INDEX `sent_by_idx` (`sent_by` ASC) VISIBLE,
  INDEX `chat_id_idx` (`chat_id` ASC) VISIBLE,
  CONSTRAINT `sent_by`
    FOREIGN KEY (`sent_by`)
    REFERENCES `account` (`account_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `message_chat_id`
    FOREIGN KEY (`chat_id`)
    REFERENCES `chat` (`chat_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `marketplace`.`friends`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `friends` ;

CREATE TABLE IF NOT EXISTS `friends` (
  `account1` INT NOT NULL,
  `account2` INT NOT NULL,
  `friends_since` DATETIME NULL,
  PRIMARY KEY (`account1`, `account2`),
  -- This check ensures that duplicates (A, B) - (B, A) don't happen
  CHECK (`account1` < `account2`),
  INDEX `account2_idx` (`account2` ASC),
  CONSTRAINT `fk_account1`
    FOREIGN KEY (`account1`)
    REFERENCES `account` (`account_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_account2`
    FOREIGN KEY (`account2`)
    REFERENCES `account` (`account_id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION
);

-- ------------------------------------------------------------------------------------------
-- USER ACCOUNTS
-- ------------------------------------------------------------------------------------------

DROP USER IF EXISTS 'app_user'@'%';
DROP USER IF EXISTS 'readonly_user'@'%';
DROP USER IF EXISTS 'market_admin'@'127.0.0.1';

-- User account for a backend server that would handle requests, can read and write data
-- but not allowed to alter the schema
-- % wildcard allows connections from any host, but should be changed to a internal ip in production
CREATE USER 'app_user'@'%' IDENTIFIED BY 'strongpassword';
GRANT SELECT, INSERT, UPDATE, DELETE ON marketplace.* TO 'app_user'@'%';

-- Read only user for analytics and read-only dashboards etc
CREATE USER 'readonly_user'@'%' IDENTIFIED BY 'readonlypass';
GRANT SELECT ON marketplace.* TO 'readonly_user'@'%';

-- Admin User, to used by developers that need full control
CREATE USER 'market_admin'@'127.0.0.1' IDENTIFIED BY 'supersecure';
GRANT ALL PRIVILEGES ON marketplace.* TO 'market_admin'@'127.0.0.1' WITH GRANT OPTION;
-- Allows requests from localhost only, stopping external users from gaining access even if they get password

-- Revoke privileges by running the below command:
-- REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'app_user'@'%';
-- DROP USER 'app_user'@'%';

-- ------------------------------------------------------------------------------------------
-- STORED PROCEDURES
-- ------------------------------------------------------------------------------------------

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






