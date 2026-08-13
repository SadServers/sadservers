# "Nairn": Phantom Gitea Deploy

## Description

Every deployment through the Gitea Actions pipeline reports full success: checkout, build, deploy, service reload, and health check all pass with green checkmarks. Despite this, users keep seeing the <b>previous</b> version of the app after every deploy.<br><br>
<code>~/webapp</code> is a git clone of the Gitea repo. Edit a file there, commit, and <kbd>git push</kbd> to trigger the Actions pipeline. Then figure out why the running <kbd>webapp</kbd> service never actually serves the version it just deployed — and fix it so a successful pipeline run always results in that version being served. For example:<br>
<pre>cd ~/webapp && echo "v2" > index.html && git commit -am "bump" && git push</pre>

## Test

The file <kbd>/srv/app/current/index.html</kbd> on the host and the content served by the webapp at <kbd>http://localhost:80/</kbd> must match.<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can read and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

set -uo pipefail

SENTINEL="sadcheck-$(date +%s%N)"
RELEASE_DIR="/srv/releases/${SENTINEL}"
CURRENT="/srv/app/current"
WEBAPP_URL="http://localhost:80/"
DEPLOY_WORKFLOW="/home/admin/webapp/.gitea/workflows/deploy.yml"

fail() { echo -n "NO"; exit 0; }
ok()   { echo -n "OK"; exit 0; }

systemctl is-active --quiet webapp.service 2>/dev/null || fail

sudo mkdir -p "${RELEASE_DIR}" 2>/dev/null || fail
echo "<html><body><h1>${SENTINEL}</h1></body></html>" \
  | sudo tee "${RELEASE_DIR}/index.html" >/dev/null 2>/dev/null || fail

sudo ln -sfn "${RELEASE_DIR}" "${CURRENT}" 2>/dev/null || fail

RELOAD_CMD="reload"
if [[ -f "$DEPLOY_WORKFLOW" ]] && grep -qE 'systemctl\s+restart\s+webapp' "$DEPLOY_WORKFLOW" 2>/dev/null; then
    RELOAD_CMD="restart"
fi

sudo systemctl "$RELOAD_CMD" webapp.service 2>/dev/null || fail

sleep 1

SERVED=$(curl -sf --max-time 2 "${WEBAPP_URL}" 2>/dev/null) || fail
[[ "${SERVED}" == *"${SENTINEL}"* ]] && ok

fail
```
