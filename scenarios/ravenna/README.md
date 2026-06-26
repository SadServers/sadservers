# "Ravenna": Logs Missing in ELK Pipeline

## Description

You are on call for the <i>orders-api</i> service. Central logging uses a small ELK stack on <b>Docker Compose</b>: an application container, Filebeat, Logstash, and Elasticsearch.
<br><br>
Operations reports that <b>no order events show up in Elasticsearch</b>, even though the application container is healthy and keeps writing logs. SRE left notes that the service contract specifies <b>plain-text</b> log lines.
<br><br>
The stack lives under <i>/home/admin/ravenna</i> and is managed with Docker Compose. Elasticsearch is reachable on the VM at <kbd>http://127.0.0.1:9200</kbd>.
<br><br>
<b>Notes:</b>
1. Wait until all four containers are <i>Up</i> before debugging (<kbd>docker compose -f /home/admin/ravenna/docker-compose.yml ps</kbd>). Elasticsearch can take up to two minutes to become healthy.<br>
2. Internet access is not needed; container images are preloaded in the local Docker engine.<br>

## Test

At least one document containing <i>order_shipped</i> is indexed in Elasticsearch under the <kbd>orders-*</kbd> index pattern.
<br><br>
Quick check:
<pre>
curl -s 'http://127.0.0.1:9200/orders-*/_search?q=order_shipped&amp;size=1' | jq .
</pre>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can read and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

count=$(curl -sf -H 'Content-Type: application/json' \
  'http://127.0.0.1:9200/orders-*/_count' \
  -d '{"query":{"query_string":{"query":"order_shipped"}}}' \
  2>/dev/null | jq -r '.count // 0')

if [ "${count:-0}" -ge 1 ]; then
  echo -n "OK"
else
  echo -n "NO"
fi
exit 0
```
