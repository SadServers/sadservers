# "Melbourne": WSGI with Gunicorn

## Description

There is a Python <a href="https://en.wikipedia.org/wiki/Web_Server_Gateway_Interface">WSGI</a> web application at <i>/home/admin/wsgi.py</i> that should serve the string <kbd>Hello, world!</kbd>. It is run by <a href="https://docs.gunicorn.org/en/stable/">Gunicorn</a>, fronted by nginx (both under systemd). Request flow: client (<kbd>curl</kbd>) → nginx (:80) → Gunicorn (Unix domain socket) → <i>wsgi.py</i>.
<br><br>
Gunicorn is already configured to listen on the Unix socket file <i>/run/gunicorn/gunicorn.sock</i> (see <i>/etc/systemd/system/gunicorn.service</i>). Nginx must proxy to <b>that same filesystem path</b>.
<br><br>
Make <kbd>curl</kbd> to localhost on port 80 return <kbd>Hello, world!</kbd> using this nginx → Gunicorn → WSGI setup.

## Test

<kbd>curl -s http://localhost</kbd> returns <kbd>Hello, world!</kbd> (served via Gunicorn and nginx; both services must be running).
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.

## Clues

<b>1.</b> Nginx is not running. Start it with <kbd>sudo systemctl start nginx</kbd>, then try <kbd>curl http://localhost</kbd> — you should get <i>502 Bad Gateway</i>.
<br><br>

<b>2.</b> Compare nginx <kbd>proxy_pass</kbd> in <kbd>/etc/nginx/sites-enabled/default</kbd> with Gunicorn <kbd>--bind</kbd> in <kbd>/etc/systemd/system/gunicorn.service</kbd>. <i>/run/gunicorn/gunicorn.socket</i> and <i>/run/gunicorn/gunicorn.sock</i> are different files. Either fix is valid: (a) point nginx at <i>/run/gunicorn/gunicorn.sock</i>, then restart nginx; or (b) change Gunicorn's <kbd>--bind</kbd> to <i>.socket</i>, then <kbd>sudo systemctl daemon-reload && sudo systemctl restart gunicorn</kbd>.
<br><br>

<b>3.</b> After the paths match, <kbd>curl localhost</kbd> returns an empty body while <kbd>curl -I localhost</kbd> works. Same via <kbd>curl --unix-socket</kbd> against whichever socket file Gunicorn is using. Check response headers for <i>Content-Length</i>.
<br><br>
(Next Clue gives the final step of the solution).
<br><br>

<b>4. Solution:</b> In <i>/home/admin/wsgi.py</i>, remove the wrong <kbd>Content-Length: 0</kbd> header (or set it to at least 13). Restart Gunicorn: <kbd>sudo systemctl restart gunicorn</kbd>.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

if ! systemctl is-active --quiet nginx; then
  echo -n "NO"
  exit 0
fi

if ! systemctl is-active --quiet gunicorn; then
  echo -n "NO"
  exit 0
fi

res=$(curl -s --max-time 2 http://127.0.0.1/ | tr -d '\r')
if [[ "$res" = "Hello, world!" ]]; then
  echo -n "OK"
else
  echo -n "NO"
fi
exit 0
```
