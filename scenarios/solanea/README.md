# Solânea: A solo database

## Description

You have a ClickHouse installation running on a Kubernetes cluster and a set of requests (located at ~/data/requests.csv) that you must seed the database across all instances.

**OBS**: CHI = ClickHouse Installation.

## Test

```bash
IPS=$(kubectl get po -n clickhouse -o jsonpath='{.items[*].status.podIP}' -l clickhouse.altinity.com/chi=clickhouse)
USER=default
PASSWORD=default
DB=monitoring
TABLE=http_requests
for ip in $IPS; do clickhouse-client --host $ip --user $USER --password $PASSWORD --database $DB -q "SELECT COUNT(*) FROM $TABLE"; done
# all the lines must return 200 rows
```
