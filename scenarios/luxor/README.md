# "Luxor": PostgreSQL analytics queries crawl

## Description

Our analytics API serves customer sales counts from a PostgreSQL database. Requests to the customer lookup endpoint take several seconds and often time out, even though the database server looks healthy — no obvious CPU, memory, or disk exhaustion.
<br><br>
The API runs as systemd service <i>sad-analytics-api</i> on port <kbd>9090</kbd>. Application code lives under <kbd>/opt/sad/</kbd>. Database credentials for debugging: connect as <i>saduser</i> to database <i>analytics_db</i> (password: <i>sadpassword</i>). The main table is <i>sales_data</i>.
<br><br>
Find why customer lookups are slow and restore acceptable API response times.

## Test

This API request must complete quickly (total response time under 500&nbsp;ms):
<br>
<kbd>curl -s -w "\nTotal time: %{time_total}s\n" http://127.0.0.1:9090/api/customers/1234/sales/count</kbd>
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

API_URL="http://127.0.0.1:9090/api/customers/1234/sales/count"
TIME_LIMIT_SEC="0.5"

systemctl is-active --quiet sad-analytics-api.service || {
  echo -n "NO"
  exit 0
}

RESPONSE=$(curl -sf -w "\n%{time_total}" "$API_URL" 2>/dev/null) || {
  echo -n "NO"
  exit 0
}

BODY=$(echo "$RESPONSE" | head -n -1)
TIME_TOTAL=$(echo "$RESPONSE" | tail -n 1)

echo "$BODY" | grep -q '"count"' || {
  echo -n "NO"
  exit 0
}

if (( $(echo "$TIME_TOTAL < $TIME_LIMIT_SEC" | bc -l) )); then
  echo -n "OK"
else
  echo -n "NO"
fi
exit 0
```
