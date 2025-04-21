USE marketplace;

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