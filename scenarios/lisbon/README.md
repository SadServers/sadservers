# "Lisbon": etcd SSL cert troubles

## Description

There's an <i>etcd</i> server running on https://localhost:2379 , get the value for the key "foo", ie <kbd>etcdctl get foo</kbd>

## Test

<kbd>etcdctl get foo --print-value-only</kbd> returns <kbd>bar</kbd>.
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.

## Clues

<b>1.</b> <kbd>etcdctl get foo</kbd> fails with a long gRPC warning ending in <kbd>tls: no application protocol</kbd> — something else is answering on :2379. Try <kbd>curl -k https://localhost:2379/v2/keys/foo</kbd> (you may get HTML, not etcd JSON). Look for a localhost NAT rule with <kbd>sudo iptables -t nat -L -n -v</kbd>; remove it with <kbd>sudo iptables -t nat -F</kbd>.<br><br>

<b>2.</b> After the redirect is gone, <kbd>etcdctl get foo</kbd> still looks similar (<kbd>DeadlineExceeded</kbd>) but the inner cause is <kbd>x509: certificate has expired or is not yet valid</kbd> with a current time about one year ahead. <kbd>curl -k https://localhost:2379/v2/keys/foo</kbd> can succeed while plain <kbd>curl https://localhost:2379/v2/keys/foo</kbd> fails. Fix the clock: <kbd>sudo date -s "last year"</kbd> (or the real date), then <kbd>etcdctl get foo --print-value-only</kbd> → <kbd>bar</kbd>.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

exec 3>&1
exec >/dev/null 2>&1

export ETCDCTL_API=3
export ETCDCTL_ENDPOINTS=https://127.0.0.1:2379
export ETCDCTL_CACERT=/etc/ssl/lisbon/localhost.crt

res=$(etcdctl --dial-timeout=1s --command-timeout=1s \
  get foo --print-value-only | tr -d '\r\n') || true

if [[ "$res" = "bar" ]]; then
  echo -n "OK" >&3
else
  echo -n "NO" >&3
fi
exit 0
```
