USE marketplace;
DELETE FROM genre;
START TRANSACTION;

INSERT INTO genre (genre_name) VALUES
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
    ('MOBA')
    ;

COMMIT;