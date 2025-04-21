import subprocess
import os

# Configuration
container_name = "test-db"
db_name = "marketplace"
db_user = "root"
db_password = "password"

# Prompt for dump file name
dump_file = input("Enter the name of the SQL dump file (e.g., marketplace_dump.sql): ").strip()
dump_path = f"assignment/schema/part2-scripts/dump/dumps/{dump_file}"

# Validate file path
if not os.path.isfile(dump_path):
    print(f"Error: File '{dump_path}' not found.")
    exit(1)

# Step 1: Ensure the database exists
create_db_command = (
    f"docker exec {container_name} "
    f"mysql -u{db_user} -p{db_password} "
    f"-e 'CREATE DATABASE IF NOT EXISTS {db_name};'"
)

try:
    subprocess.run(create_db_command, shell=True, check=True)
    print(f"Database '{db_name}' ensured.")
except subprocess.CalledProcessError as e:
    print("Failed to create the database:")
    print(e)
    exit(1)

# Step 2: Restore the dump
restore_command = (
    f"docker exec -i {container_name} "
    f"mysql -u{db_user} -p{db_password} {db_name}"
)

try:
    with open(dump_path, "rb") as file:
        subprocess.run(restore_command, shell=True, stdin=file, check=True)
    print(f"Successfully restored '{dump_file}' into database '{db_name}' on container '{container_name}'.")
except subprocess.CalledProcessError as e:
    print("An error occurred while restoring the database:")
    print(e)