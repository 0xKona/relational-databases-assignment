import random
from faker import Faker

fake = Faker()

NUM_ACCOUNTS = 100
NUM_PUBLISHERS = 10
NUM_GAMES = 50
NUM_REVIEWS = 200
NUM_GENRES = 16 
NUM_CHATS = 20
NUM_MESSAGES = 200
NUM_FRIENDSHIPS = 150

with open("additional_generated_test_data.sql", "w") as f:
    f.write("USE marketplace;\n\n")

    # Accounts
    f.write("-- Accounts\n")
    for i in range(NUM_ACCOUNTS):
        email = fake.unique.email()
        username = fake.unique.user_name()
        password_hash = 'b06779c4959295605d26f9e7eb06356d5b5c6b1bd10cc28da75931f06997c601'  # static hash
        profile_pic_url = f"'{fake.image_url() if random.choice([True, False]) else 'NULL'}'"
        f.write(f"""INSERT IGNORE INTO account (email, username, password_hash, profile_pic_url, account_banned, account_created, last_login) 
                VALUES ('{email}', '{username}', '{password_hash}', {profile_pic_url if profile_pic_url != 'NULL' else 'NULL'}, 0, NOW(), NOW());\n""")

    f.write("\n-- Publishers\n")
    for i in range(NUM_PUBLISHERS):
        name = fake.company()
        bio = fake.catch_phrase()
        admin = random.randint(1, NUM_ACCOUNTS)
        f.write(f"INSERT IGNORE INTO publisher (publisher_name, bio, publisher_admin) VALUES ('{name}', '{bio}', {admin});\n")

    f.write("\n-- System Requirements\n")
    for i in range(10):
        mac = random.randint(0, 1)
        windows = random.randint(0, 1)
        linux = random.randint(0, 1)
        cpu = fake.word().capitalize() + " " + random.choice(["i5", "i7", "Ryzen 5", "Ryzen 7"])
        memory = random.choice(["4GB", "8GB", "16GB"])
        gpu = fake.word().upper() + " " + random.choice(["1050", "2060", "3080"])
        storage = random.choice(["20GB", "50GB", "100GB"])
        f.write(f"INSERT IGNORE INTO system_requirements (mac, windows, linux, min_cpu, min_memory, min_gpu, storage) VALUES ({mac}, {windows}, {linux}, '{cpu}', '{memory}', '{gpu}', '{storage}');\n")

    f.write("\n-- Games\n")
    for i in range(NUM_GAMES):
        name = fake.unique.sentence(nb_words=3).replace("'", "")[:100]
        desc = fake.text(max_nb_chars=300).replace("'", "")
        multiplayer = random.randint(0, 1)
        publisher = random.randint(1, NUM_PUBLISHERS)
        system_req = random.randint(1, 10)
        price = round(random.uniform(5, 60), 2)
        f.write(f"INSERT IGNORE INTO game (name, `desc`, multiplayer, publisher, release_date, system_requirements, price) VALUES ('{name}', '{desc}', {multiplayer}, {publisher}, NOW(), {system_req}, {price});\n")

    f.write("\n-- Genres\n")
    genre_names = ['Adventure', 'Survival', 'Sci-Fi', 'Horror', 'Shooter', 'Strategy', 'Classic', 'Puzzle', 'Battle Royale', 'Card Game', 'Visual Novel', 'Stealth', 'Open World', 'RPG', 'MMO', 'MOBA']
    for genre in genre_names:
        f.write(f"INSERT IGNORE INTO genre (genre_name) VALUES ('{genre}');\n")

    f.write("\n-- Game Genres\n")
    for i in range(NUM_GAMES * 2):
        game = random.randint(1, NUM_GAMES)
        genre = random.randint(1, NUM_GENRES)
        f.write(f"INSERT IGNORE INTO game_genres (game, genre) VALUES ({game}, {genre});\n")

    f.write("\n-- Reviews\n")
    for i in range(NUM_REVIEWS):
        written_by = random.randint(1, NUM_ACCOUNTS)
        game = random.randint(1, NUM_GAMES)
        review_text = fake.sentence().replace("'", "")
        rating = random.randint(1, 10)
        f.write(f"INSERT IGNORE INTO review (written_by, game, review_text, rating) VALUES ({written_by}, {game}, '{review_text}', {rating});\n")

    f.write("\n-- Account Games (Purchases)\n")
    for i in range(NUM_ACCOUNTS * 2):
        account = random.randint(1, NUM_ACCOUNTS)
        game = random.randint(1, NUM_GAMES)
        f.write(f"INSERT IGNORE INTO account_games (account, game) VALUES ({account}, {game});\n")

    f.write("\n-- Friends\n")
    friend_pairs = set()
    while len(friend_pairs) < NUM_FRIENDSHIPS:
        a1, a2 = random.sample(range(1, NUM_ACCOUNTS + 1), 2)
        if a1 > a2:
            a1, a2 = a2, a1
        if (a1, a2) not in friend_pairs:
            friend_pairs.add((a1, a2))
            f.write(f"INSERT IGNORE INTO friends (account1, account2, friends_since) VALUES ({a1}, {a2}, NOW());\n")

    f.write("\n-- Chats\n")
    for i in range(NUM_CHATS):
        name = fake.catch_phrase().replace("'", "")[:30]
        img = f"'{fake.image_url() if random.choice([True, False]) else 'NULL'}'"
        f.write(f"INSERT IGNORE INTO chat (chat_name, chat_image_url) VALUES ('{name}', {img if img != 'NULL' else 'NULL'});\n")

    f.write("\n-- User in Chat\n")
    for i in range(NUM_ACCOUNTS * 2):
        chat = random.randint(1, NUM_CHATS)
        account = random.randint(1, NUM_ACCOUNTS)
        f.write(f"INSERT IGNORE INTO user_in_chat (chat_id, account) VALUES ({chat}, {account});\n")

    f.write("\n-- Messages\n")
    for i in range(NUM_MESSAGES):
        sent_by = random.randint(1, NUM_ACCOUNTS)
        chat = random.randint(1, NUM_CHATS)
        text = fake.sentence().replace("'", "")
        f.write(f"INSERT IGNORE INTO message (sent_by, chat_id, text, timestamp) VALUES ({sent_by}, {chat}, '{text}', NOW());\n")

print("SQL data generation complete. File saved as 'additional_generated_test_data.sql'")