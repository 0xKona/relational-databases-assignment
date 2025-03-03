# Relational Databases Module Exercises

- This repo contains exercises completing in the Realtional Databases module.

## Starting a mySQL instance with docker

- Start by running `docker compose up`

### Access Database

- Command line:

    ```
        // USE DOCKER PS TO FIND THE SQL CONTAINER ID

        docker ps

        // use docker container id to access

        docker exec -it <containerID> mysql -u root -p

        // Will prompt for password which is 'password' by default;

    ```

- You can also connect using mysql workbench

## Starting a mySQL instance using local install

- Simply access using localhost:3306 in sql workbench