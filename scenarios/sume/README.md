# "Sumé": Tied in a Knot

## Description

A DNS server running Knot DNS is serving the zone <i>sadservers.internal</i> (see <kbd>ls /var/lib/knot/zones/</kbd>), but users are reporting that they cannot access <i>blog.sadservers.internal</i> neither <i>api.sadservers.internal</i>. Your task is to diagnose and fix the DNS issues so the services become accessible.
<br>
You can manage Knot DNS with <kbd>sudo knotc</kbd> commands.
<br><br>
Note: the 203.0.113.0/24 range is part of TEST-NET-3, a block reserved by RFC 5737 for documentation and examples, making it a Bogon IP range.
<br><br>
<b>IMPORTANT</b>. Do not change the <i>Nginx</i> configurations under <i>/opt/services/</i> for the solution to work.

## Test

You are able to access the blog and the API services:
<kbd>curl blog.sadservers.internal</kbd> returns <kbd>Welcome to blog.sadservers.internal</kbd><br>
<kbd>curl api.sadservers.internal</kbd> returns <kbd>{"status": "ok", "service": "api.sadservers.internal"}</kbd>
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

fail() {
  echo -n "NO"
  exit
}

ZONE="sadservers.internal"

if ! systemctl is-active --quiet knot; then
  fail
fi

if ! sudo knotc zone-check $ZONE &>/dev/null; then
  fail
fi

BLOG_CNAME=$(dig blog.$ZONE CNAME +short)
if ! echo "$BLOG_CNAME" | grep -q "www.$ZONE"; then
  fail
fi

if ! sudo knotc zone-read $ZONE www A &>/dev/null; then
  fail
fi

if ! sudo knotc zone-read $ZONE api A &>/dev/null; then
  fail
fi

BLOG=$(curl -s http://blog.$ZONE)
if ! echo "$BLOG" | grep -q "Welcome to blog.$ZONE"; then
  fail
fi

API=$(curl -s http://api.$ZONE)
if ! echo "$API" | grep -q "api.$ZONE"; then
  fail
fi

(cd "/opt/services" && sudo sha256sum --check --status ~/agent/nginx.sha256) || fail

echo -n "OK"
```
