import subprocess
import datetime

# Configuration
container_name = "test-db"
db_name = "marketplace"
db_user = "root"
db_password = "password"
timestamp = datetime.datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
output_file = f"assignment/schema/part2-scripts/dump/dumps/marketplace_dump_{timestamp}.sql"

# Construct the command
command = [
    "docker", "exec", container_name,
    "mysqldump",
    f"-u{db_user}",
    f"-p{db_password}",
    db_name
]

# Run the command and capture the output
try:
    with open(output_file, "w") as dump_file:
        subprocess.run(command, stdout=dump_file, check=True)
    print(f"Database dump successful. Saved to: {output_file}")
except subprocess.CalledProcessError as e:
    print("An error occurred while creating the database dump.")
    print(e)