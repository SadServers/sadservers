# "Lisbon": etcd SSL cert troubles

## Description

There's an <i>etcd</i> server running on https://localhost:2379 , get the value for the key "foo", ie <kbd>etcdctl get foo</kbd> or <kbd>curl https://localhost:2379/v2/keys/foo</kbd>

## Test

<kbd>etcdctl get foo</kbd> returns <kbd>bar</kbd>.

<b>check.sh</b>

```
#!/usr/bin/bash
export GODEBUG=x509ignoreCN=0
export ETCDCTL_ENDPOINT=https://localhost:2379
res=$(etcdctl get foo)
res=$(echo $res|tr -d '\r')

if [[ "$res" = "bar" ]]
then
  echo -n "OK"
else
  echo -n "NO"
fi
```
