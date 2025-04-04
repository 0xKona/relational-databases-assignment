-- -----------------------------------------------------
-- S183038 Schema: Marketplace
-- -----------------------------------------------------
DROP DATABASE marketplace;
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
  PRIMARY KEY (`account_id`),
  UNIQUE(`email`),
  UNIQUE(`username`));
  
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
  `publisher_admin` INT NOT NULL,
  PRIMARY KEY (`publisher_id`),
  UNIQUE INDEX `publisher_id_UNIQUE` (`publisher_id` ASC) VISIBLE,
  INDEX `publisher_admin_idx` (`publisher_admin` ASC) VISIBLE,
  CONSTRAINT `publisher_admin`
    FOREIGN KEY (`publisher_admin`)
    REFERENCES `marketplace`.`account` (`account_id`)
    -- If a publisher is removed then all of their games should be aswell
    ON DELETE CASCADE
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
  PRIMARY KEY (`game_id`),
  UNIQUE INDEX `game_id_UNIQUE` (`game_id` ASC) VISIBLE,
  INDEX `publisher_idx` (`publisher` ASC) VISIBLE,
  INDEX `system_requirements_idx` (`system_requirements` ASC) VISIBLE,
  CONSTRAINT `game_publisher`
    FOREIGN KEY (`publisher`)
    REFERENCES `publisher` (`publisher_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `system_requirements`
    FOREIGN KEY (`system_requirements`)
    REFERENCES `system_requirements` (`requirements_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


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
    ON DELETE NO ACTION
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
    ON DELETE NO ACTION
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
    ON DELETE NO ACTION
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
