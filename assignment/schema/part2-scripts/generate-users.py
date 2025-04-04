import datetime
import random
import string
from hashlib import sha256

def random_string(length=10):
    characters = string.ascii_letters + string.digits
    return ''.join(random.choice(characters) for _ in range(length))

with open('insert-users.sql', 'w') as file:

    # Remove original contents
    file.truncate(0)

    file.write("USE marketplace;\nDELETE FROM account;\nSTART TRANSACTION;\n")

    # Generate entries 
    numOfEntries = 10000
    for i in range(numOfEntries):

        # Generate a random password and hash it using sha256
        randomPass = random_string()
        hpass = sha256(randomPass.encode('utf-8')).hexdigest()
        # Generate current timestamp
        now = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')

        line = f"INSERT INTO account VALUES (NULL, 'user{i}@test.com', 'user{i}', '{hpass}', 'www.url.com', FALSE, '{now}', '{now}');"
        
        # Write line to file
        file.write(f'{line}\n')
        
    file.write("COMMIT;\n")