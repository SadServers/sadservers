# "Cork": The catalog won't open

## Description

After last week's host reboot the product catalog Postgres database will not stay up. Inserts into the <i>catalog</i> database fail. Ops moved application data off the root disk onto a dedicated volume some time ago; root itself still looks healthy.
<br><br>
You do not need deep Postgres expertise. The server listens on <kbd>:5432</kbd> when healthy. The data directory is set in <i>/etc/postgresql/*/main/</i> (see <i>data_directory</i>). <i>systemd</i> manages the unit named <i>postgresql</i>.

## Test

As <i>admin</i>: <kbd>sudo -u postgres psql -d catalog -c "INSERT INTO products(name) VALUES ('jane smith');"</kbd>
<br><br>
Should return: <kbd>INSERT 0 1</kbd>
<br><br>
The fix must still work after a reboot.
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

out=$(sudo -u postgres psql -d catalog -c "INSERT INTO products(name) VALUES ('jane smith');" 2>/dev/null | tr -d '\r' || true)
# shellcheck disable=SC2086
flat=$(echo $out)

if [ "$flat" = "INSERT 0 1" ]; then
  echo -n "OK"
else
  echo -n "NO"
fi
exit 0
```
