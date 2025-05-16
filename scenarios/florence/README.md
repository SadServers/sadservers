# "Florence": Database Migration Hell

## Description

You are working as a DevOps Engineer in a company and another devops left the company and left docker-compose unfinished.
Generally, the problem revolves around migration and docker compose.
You need to deploy application with database Postgresql via docker-compose.
Additionally on front of the application there is an Nginx server and you need to fix it as well.
You can test it with  ``` curl --cacert /etc/nginx/certs/sadserver.crt  https://sadserver.local ```
The source of code is in `/home/admin/app`

## Test

The "Check My Solution" button runs the script `/home/admin/agent/check.sh`, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
export COMPOSE_FILE=/home/admin/app/docker-compose.yml
# Function to check if all specified services are up
check_services_status() {
    local services=("api" "db" "api_aggregator")
    local service
    local status

    for service in "${services[@]}"; do
        status=$(docker compose ps | grep -w "$service" | grep -w "Up")
        if [[ -z "$status" ]]; then
            return 1
        fi
    done
    return 0
}

# Function to check database migration status
check_db_migration() {
    local db_status1=$(docker compose exec db psql -h localhost -U postgres -d postgres -c "SELECT * FROM users;")
    local db_status2=$(docker compose exec db psql -h localhost -U postgres -d postgres -c "SELECT * FROM comments;")

    if [[ -z "$db_status1" ]] || [[ -z "$db_status2" ]]; then
        return 1
    else
        return 0
    fi
}

curl --silent --output /dev/null --cacert /etc/nginx/certs/sadserver.crt  https://sadserver.local
CHECK_WEB_SERVER=$?
if check_services_status; then
    if [[ check_db_migration -eq 0 ]]  && [[ "${CHECK_WEB_SERVER}" -eq 0 ]]; then
        echo "YES"
    else
        echo "NO"
    fi
else
    echo "NO"
fi
```
