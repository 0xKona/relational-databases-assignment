USE marketplace;

-- Delete friend
DELETE FROM friends
WHERE (account1 = LEAST(1, 3) AND account2 = GREATEST(1, 3));
