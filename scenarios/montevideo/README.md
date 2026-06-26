# "Montevideo": restore test snapshot would clobber production

## Description

This host runs a small app whose live data lives under <kbd>/production/</kbd>. Nightly snapshot backups land under <kbd>/snapshots/</kbd> in an rsnapshot-style layout.
<br><br>
A recent bug in the snapshot job may have pointed some files in the latest rotation (<kbd>/snapshots/daily-2026-06-01/</kbd>) at the live tree instead of making independent copies.
<br><br>
Ops scheduled a dry-run restore from that snapshot into <kbd>/production/</kbd>. If any snapshot path still aliases live data, the restore would overwrite production in place.
<br><br>
Read <kbd>/home/admin/backup-notes.txt</kbd>. Find every incorrectly shared file between <kbd>/production/</kbd> and <kbd>/snapshots/daily-2026-06-01/</kbd>, then repair the snapshot so it is safe to restore from. Do not damage live production data, and do not break intentional space-saving deduplication inside older snapshot rotations.
<br><br>
<b>Note:</b> the tools <i>rsync</i> and <i>dd</i> are available in this server.

## Test

Every file in <kbd>/snapshots/daily-2026-06-01/</kbd> mirroring a name in <kbd>/production/</kbd> must be an independent copy: restoring the snapshot must not alias or overwrite live files.
<br>
Older rotations (<kbd>snapshot-1</kbd>–<kbd>snapshot-3</kbd>) must keep shared <kbd>config.ini</kbd> hard links.
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/usr/bin/env bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

fail() {
  echo -n "NO"
  exit 0
}

PROD=/production
SNAP=/snapshots/daily-2026-06-01

for f in app.conf users.db inventory.db; do
  [ -s "$PROD/$f" ] || fail
  [ -s "$SNAP/$f" ] || fail
done

grep -q 'records=1247' "$PROD/users.db" 2>/dev/null || fail
grep -q 'skus=8912' "$PROD/inventory.db" 2>/dev/null || fail

for f in app.conf users.db inventory.db; do
  pi=$(stat -c '%i' "$PROD/$f" 2>/dev/null) || fail
  si=$(stat -c '%i' "$SNAP/$f" 2>/dev/null) || fail
  [ "$pi" != "$si" ] || fail
done

grep -q 'records=1247' "$SNAP/users.db" 2>/dev/null || fail
grep -q 'skus=8912' "$SNAP/inventory.db" 2>/dev/null || fail

i1=$(stat -c '%i' /snapshots/snapshot-1/config.ini 2>/dev/null) || fail
i2=$(stat -c '%i' /snapshots/snapshot-2/config.ini 2>/dev/null) || fail
i3=$(stat -c '%i' /snapshots/snapshot-3/config.ini 2>/dev/null) || fail
[ "$i1" = "$i2" ] && [ "$i1" = "$i3" ] || fail
[ "$(stat -c '%h' /snapshots/snapshot-1/config.ini 2>/dev/null)" -ge 3 ] || fail

echo -n "OK"
exit 0
```
