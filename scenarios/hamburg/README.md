# "Hamburg": Find the AWS EC2 volume

## Description

We have a lot of AWS EBS volumes, the description of which we have save to a file with:  <kbd>aws ec2 describe-volumes > aws-volumes.json</kbd>.
<br>One of the volumes contains important data and we need to identify which volume (its ID), but we only remember these characteristics: gp3, created before 30/09/2025 , Size < 64 , Iops < 1500, Throughput > 300.
<br><br>
Find the correct volume and put its <b>InstanceId</b> into the <i>~/mysolution</i> file, e.g.: <kbd>echo "i-00000000000000000" > ~/mysolution</kbd>

## Test

Running <kbd>md5sum /home/admin/mysolution</kbd> returns <kbd>e7e34463823bf7e39358bf6bb24336d8</kbd> (we also accept the file without a new line at the end).
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/usr/bin/bash

check_user="admin"
base_path="/home/$check_user"
ms_path="$base_path/mysolution"

# Perform operations
md5=$(md5sum "$ms_path" | awk '{print $1}')
[ "$md5" == "e7e34463823bf7e39358bf6bb24336d8" ] || { echo -n "NO"; exit ; }

echo -n "OK"
```
