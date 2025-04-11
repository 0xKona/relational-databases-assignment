USE marketplace;

-- Accounts
INSERT IGNORE INTO account (email, username, password_hash, profile_pic_url, account_banned, account_created, last_login) VALUES
('alice@example.com', 'AliceGamer', 'b06779c4959295605d26f9e7eb06356d5b5c6b1bd10cc28da75931f06997c601', 'https://example.com/images/alice.jpg', 0, NOW(), NOW()),
('bob@example.com', 'BobDev', 'b06779c4959295605d26f9e7eb06356d5b5c6b1bd10cc28da75931f06997c601', 'https://example.com/images/bob.jpg', 0, NOW(), NOW()),
('carol@example.com', 'CarolPlays', 'b06779c4959295605d26f9e7eb06356d5b5c6b1bd10cc28da75931f06997c601', NULL, 0, NOW(), NOW());

-- Publishers
INSERT IGNORE INTO publisher (publisher_name, bio, publisher_admin) VALUES
('Indie Galaxy', 'We publish creative and story-rich indie games.', 2),
('NextGen Games', 'AAA game studio pushing the boundaries of realism.', 1),
('Mojang', 'We sold our souls to Microsoft!!!', 3);

-- System Requirements
INSERT IGNORE INTO system_requirements (mac, windows, linux, min_cpu, min_memory, min_gpu, storage) VALUES
(1, 1, 0, 'Intel i5', '8GB', 'GTX 1050', '20GB'),
(0, 1, 1, 'AMD Ryzen 5', '16GB', 'RTX 2060', '50GB');

-- Games
INSERT IGNORE INTO game (name, `desc`, multiplayer, publisher, release_date, system_requirements, price) VALUES
('Space Quest', 'Explore galaxies and build civilizations.', 1, 1, '2023-10-01', 1, 29.99),
('Zombie Dawn', 'Survive in a post-apocalyptic world of the undead.', 0, 2, '2024-01-15', 2, 49.99),
('Minecraft', 'The cake is a lie', 1, 3, '2011-01-01', 1, 12.99);

-- Genres
INSERT IGNORE INTO genre (genre_name) VALUES
('Adventure'),
('Survival'),
('Sci-Fi'),
('Horror'),
('Shooter'),
('Strategy'),
('Classic'),
('Puzzle'),
('Battle Royale'),
('Card Game'),
('Visual Novel'),
('Stealth'),
('Open World'),
('RPG'),
('MMO'),
('MOBA');

-- Game Genres
INSERT IGNORE INTO game_genres (game, genre) VALUES
(1, 1),
(1, 3),
(2, 2),
(2, 4);

-- Reviews
INSERT INTO review (written_by, game, review_text, rating) VALUES
(1, 1, 'Absolutely loved exploring planets!', 9),
(3, 2, 'Very intense and scary!', 8);

-- Account-Games (purchases)
INSERT IGNORE INTO account_games (account, game) VALUES
(1, 1),
(1, 2),
(3, 2);

-- Game Ban
INSERT INTO game_ban (account, game, reason, expires, started) VALUES
(3, 2, 'Toxic behavior in reviews', DATE_ADD(NOW(), INTERVAL 30 DAY), NOW());

-- Chats
INSERT INTO chat (chat_name, chat_image_url) VALUES
('Space Fans', 'https://example.com/chat/space.jpg'),
('Zombie Survivors', NULL);

-- User In Chat
INSERT IGNORE INTO user_in_chat (chat_id, account) VALUES
(1, 1),
(1, 3),
(2, 3);

-- Messages
INSERT INTO message (sent_by, chat_id, text, timestamp) VALUES
(1, 1, 'Anyone found the hidden galaxy yet?', NOW()),
(3, 1, 'Yeah! It’s amazing!', NOW()),
(3, 2, 'Looking for team to survive the next wave.', NOW());

-- Friends
INSERT IGNORE INTO friends (account1, account2, friends_since) VALUES
(1, 3, NOW());
