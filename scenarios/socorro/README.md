# "Socorro, NM": Optimize Podman image

## Description

The podman image <i>localhost/prod:latest</i> contains a static website.<br> Initially the image size is 261 MB and contains 100 layers.
<br><br>Your task:<br>
1. Optimize the image <i>localhost/prod:latest</i> so that its size is less than 200 MB, using the same tag.<br>
2. Run a container named "check" from the optimized image: <kbd>podman run -d --name check -p 8888:80 localhost/prod:latest</kbd> so that <kbd>curl localhost:8888</kbd> returns 100 lines.

## Test

The podman image <i>localhost/prod:latest</i> size is less than 200 MB and running <kbd>curl localhost:8888</kbd> from a container named "check" created from the image retuns 100 lines.
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/usr/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

poddock="podman"

# Perform operations
layer=$($poddock history localhost/prod:latest | wc -l)

res=$(curl -s localhost:8888)
count=$(echo "$res" | wc -l)
last=$(echo "$res" | tail -n 1)

[ "$layer" != "2" ] && { echo -n "NO"; exit ; }
[ "$count" != "100" ] && { echo -n "NO"; exit ; }
[ "$last" != "this is layer 100" ] && { echo -n "NO"; exit ; }

echo -n "OK";
```
