# "London": Ollama LLM troubles

## Description

An AI agent has been deployed to production as a container called <i>ai-agent</i> managed by the Docker Compose configuration <i>/home/admin/app/docker-compose.yaml</i>. This ai-agent container relies on an Ollama LLM backend to generate a report but hasn't generated any yet. Your mission is to restore the broken agent-to-LLM (Ollama) connectivity, and tune the agent configuration at <i>/home/admin/app/agent/config.yaml</i> so it can produce a report in <i>/home/admin/app/agent/report.json</i>. Example of the expected output:
<pre>
{
  "summary": "Nginx is failing to reach its upstream service",
  "root_causes": [
    {
      "service": "nginx",
      "error": "connection refused to upstream 127.0.0.1:9999",
      "severity": "high"
    }
  ],
  "recommended_actions": "Fix upstream port configuration"
}
</pre>

<i>Note</i>: The system consist of a group of dummy nginx containers generating logs and sending them to a central rsyslog container. The logs are then shared on a volume with the ai-agent container, from there the agent picks up the logs and passes them together with a promt to the LLM server so it can produce the desired answer with the expected JSON format. You don't need to worry about troubleshooting any container other than the container <i>ai-agent</i> or service <i>agent</i> within docker compose.

## Test

The command <kbd>docker compose up -d agent</kbd> under the directory <i>/home/admin/app</i> must create the report file <i>/home/admin/app/agent/report.json</i>. The format of the answer must be as specified in the description.
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

res="ok"

# Check if report exists
report="/home/admin/app/agent/report.json"
[[ ! -f "$report" ]] && res="no"

# Check JSON validity
jq empty "$report" 2>/dev/null
[[ $? -ne 0 ]] && res="no"

# Check required keys
jq -e '.summary' "$report" >/dev/null 2>&1
jq -e '.root_causes' "$report" >/dev/null 2>&1
jq -e '.recommended_actions' "$report" >/dev/null 2>&1
[[ $? -ne 0 ]] && res="no"

# Ensure at least one root cause detected
CAUSES=$(jq '.root_causes | length' "$report" 2>/dev/null)
[[ "$CAUSES" -lt 1 ]] && res="no"

# Validate severity values
INVALID=$(jq '[.root_causes[].severity | select(. != "low" and . != "medium" and . != "high")] | length' "$report" 2>/dev/null)
[[ "$INVALID" -ne 0 ]] && res="no"

if [ "$res" == "ok" ]; then
  echo -n "OK"
else
  echo -n "NO"
fi
```
