# "Helsingør": The first walls of postgres physical replication

## Description

You're setting up a PostgreSQL database with replication, you decided to use Docker along with Docker Compose to make it easier to manage and test, after a few hours of work you finished the job and the master database is up and running, but you're having trouble with the replica.

You need to figure out what's wrong with the replica and fix it.

Since you are using Docker Compose, you can check the status of the running containers using `docker compose ps` (`docker ps` will do the job too). you may also want to check the logs of the containers.

This is the file structure for this project:

```md
/home/admin
├── postgres
│   ├── master
│   │   ├── initdb.d
│   │   │   ├── 01-roles.sql
|   |   |   |── 02-replication.sql
│   │   │   └── 03-dataset.sql
│   │   └── postgres.conf
│   └── replica
│   │   └── postgres.conf
├── docker-compose.yml
└── README.md
```

All definition for the containers are inside `docker-compose.yml` file. You can get up the environment by running `docker compose up -d` and set it down by running `docker compose down`.

If you make any change to the docker-compose.yml file, you can restart the containers by running `docker compose up -d --force-recreate`.



## Test

Postgres replica container works.

The "Check My Solution" button runs the script _/home/admin/agent/check.sh_, which you can see and execute.

```bash
#!/usr/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

# get the last person_id from the replica
LAST=$(docker compose exec postgres-db-replica psql -U helsingor -d helsingor -tc "select person_id from users order by person_id desc limit 1;" &> /dev/null)

# insert a new user into the master
docker compose exec postgres-db-master psql -U helsingor -d helsingor -tc \
"insert into users (first_name, last_name, age, city, os) values ('Will', 'Smith', '55', 'Philadelphia', 'MacOS')" &> /dev/null

# wait for the replica to sync
sleep 1s

# get the last person_id from the replica
NEW=$(docker compose exec postgres-db-replica psql -U helsingor -d helsingor -tc "select person_id from users order by person_id desc limit 1;" &> /dev/null)

# check if the last person_id has increased by 1
if [ $((NEW-LAST)) -eq 1 ]; then
  echo -n "OK"
else
  echo -n "NO"
fi
```
