# "Tallinn": BuildKit & Docker build mismatch

## Description

This VM runs a tiny container app, <i>tallinn-service</i>, whose only job is to print an API version string (for example <kbd>tallinn-api-version=1.4.0</kbd>). The image is built from <i>/home/admin/tallinn-app</i> with <kbd>docker build</kbd>.
<br><br>
The dev team raised the API contract to <b>2.0.0</b> in <i>src/api_version.txt</i> and ran a new build, but QA still rejects the image tagged <i>tallinn-app:current</i>: it reports <b>1.4.0</b> at runtime. A recent CI log is in <i>/home/admin/build.log</i>.
<br><br>
Fix the <kbd>docker build</kbd> outcome so the deploy image matches what the sources ask for.
<br><br>
Fix the image tagged <i>tallinn-app:current</i> so the on-disk contract file <b>and</b> the shipped binary both report API <kbd>2.0.0</kbd>.

## Test

Image <i>tallinn-app:current</i> exists, <i>/etc/tallinn/api_version</i> is <kbd>2.0.0</kbd>, and <kbd>/usr/local/bin/tallinn-service</kbd> prints <kbd>tallinn-api-version=2.0.0</kbd>.
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

IMAGE=tallinn-app:current
EXPECTED=2.0.0

if ! docker image inspect "$IMAGE" >/dev/null 2>&1; then
  echo -n "NO"
  exit 0
fi

read -r file_ver runtime_ver < <(
  docker run --rm --entrypoint sh "$IMAGE" -c '
    v=$(tr -d "\n\r" </etc/tallinn/api_version)
    r=$(/usr/local/bin/tallinn-service | tr -d "\n\r" | sed "s/^tallinn-api-version=//")
    printf "%s %s\n" "$v" "$r"
  ' 2>/dev/null
)

if [ "$file_ver" = "$EXPECTED" ] && [ "$runtime_ver" = "$EXPECTED" ]; then
  echo -n "OK"
else
  echo -n "NO"
fi
exit 0
```
