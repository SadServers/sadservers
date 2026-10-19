# "Auckland": S3 delete & archive old backups

## Description

Ops left years of database dumps in <kbd>s3://auckland-backups</kbd>. Keys use an absolute date prefix:
<br>
<kbd>backups/YYYY-MM-DD/...</kbd>
<br><br>
Apply this retention policy (use the date in the <b>key</b>, ignore <kbd>LastModified</kbd>):
<br>
<ul>
<li><b>Before 2023-01-01</b> — <b>delete</b> those objects</li>
<li><b>From 2023-01-01 through 2024-12-31</b> — keep them but set storage class to <kbd>GLACIER</kbd></li>
<li><b>On or after 2025-01-01</b> — leave as Standard</li>
<li>Keys <b>without</b> that date prefix — leave untouched</li>
</ul>
The AWS CLI is ready (no configuration or authentication needed). You can start with:
<br>
<kbd>aws s3 ls s3://auckland-backups --recursive</kbd>
<br><br>
NOTE: this scenario uses Floci, a local AWS emulator; there are no real AWS resources.

## Test

In <kbd>s3://auckland-backups</kbd>: objects with key date &lt; 2023-01-01 are gone; dates 2023-01-01.. 2024-12-31 are GLACIER (or deep archive); dates ≥ 2025-01-01 and non-dated keys remain Standard.
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

export AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID:-test}"
export AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY:-test}"
export AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:-us-east-1}"
export AWS_EC2_METADATA_DISABLED=true
ENDPOINT="${AWS_ENDPOINT_URL:-http://127.0.0.1:4566}"
BUCKET="${FLOCI_BUCKET:-auckland-backups}"

DELETE_BEFORE=20230101
ARCHIVE_BEFORE=20250101

# One ListObjectsV2 call: Key + StorageClass (avoids per-object HeadObject).
# Output: KEY\tSTORAGECLASS per line (StorageClass empty/None → STANDARD).
listing=$(aws s3api --endpoint-url "$ENDPOINT" list-objects-v2 \
  --bucket "$BUCKET" \
  --query 'Contents[].[Key,StorageClass]' \
  --output text 2>/dev/null) || true

if [[ -z "$listing" || "$listing" == "None" ]]; then
  echo -n "NO"
  exit 0
fi

declare -A SC
found_archive=0
found_keep=0

while read -r key sc; do
  [[ -z "$key" || "$key" == "None" ]] && continue
  if [[ -z "$sc" || "$sc" == "None" || "$sc" == "null" ]]; then
    sc="STANDARD"
  fi
  SC["$key"]=$sc

  if [[ "$key" =~ ^backups/([0-9]{4})-([0-9]{2})-([0-9]{2})/ ]]; then
    d="${BASH_REMATCH[1]}${BASH_REMATCH[2]}${BASH_REMATCH[3]}"
    if (( 10#$d < 10#$DELETE_BEFORE )); then
      echo -n "NO"
      exit 0
    fi
    case "$sc" in
      GLACIER|DEEP_ARCHIVE|GLACIER_IR) glacier=1 ;;
      *) glacier=0 ;;
    esac
    if (( 10#$d < 10#$ARCHIVE_BEFORE )); then
      [[ "$glacier" -eq 1 ]] || { echo -n "NO"; exit 0; }
      found_archive=1
    else
      [[ "$glacier" -eq 0 ]] || { echo -n "NO"; exit 0; }
      found_keep=1
    fi
  fi
done <<< "$listing"

for must in \
  "backups/2023-01-01/db.dump" \
  "backups/2024-12-31/db.dump" \
  "backups/2025-01-01/db.dump" \
  "backups/2026-03-15/db.dump" \
  "backups/README.txt" \
  "current/latest.dat"
do
  [[ -n "${SC[$must]+x}" ]] || { echo -n "NO"; exit 0; }
done

for gone in \
  "backups/2020-06-15/db.dump" \
  "backups/2021-03-01/db.dump" \
  "backups/2022-12-31/db.dump"
do
  [[ -z "${SC[$gone]+x}" ]] || { echo -n "NO"; exit 0; }
done

if [[ "$found_archive" -eq 1 && "$found_keep" -eq 1 ]]; then
  echo -n "OK"
else
  echo -n "NO"
fi
exit 0
```
