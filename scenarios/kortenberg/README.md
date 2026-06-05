# "Kortenberg": Can't touch this!

## Description

Is "All I want for Christmas is you" already everywhere?. A bit unrelated, someone messed up the permissions in this server, the <i>admin</i> user can't list new directories and can't write into new files. Fix the issue.<br>
<b>NOTE: </b> Besides solving the problem in your current admin shell session, you need to fix it permanently, as in a new login shell for user "admin" (like the one initiated by the scenario checker) should have the problem fixed as well.

## Test

The <i>admin</i> user in a separate Bash login session should be able to create a new directory in your /home/admin directory, as well as being able to create a file into this new directory and add text into the new file.<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/usr/bin/bash

check_user="admin"
base_path="/home/$check_user"
directory_name="CHECK_$(date +%s)_$RANDOM"
file_name=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c $((RANDOM%32)))

trap 'rm -rf /home/$check_user/$directory_name 2>/dev/null' EXIT

# Perform operations
sudo -u $check_user -i bash -c "mkdir /home/$check_user/$directory_name 2>/dev/null" 2>/dev/null || { echo "NO"; exit 1; }
sudo -u $check_user -i bash -c "date +%s > /home/$check_user/$directory_name/$file_name 2>/dev/null" 2>/dev/null || { echo "NO"; exit 1; }
sudo -u $check_user -i bash -c "cat /home/$check_user/$directory_name/$file_name 2>/dev/null" >/dev/null 2>&1 || { echo "NO"; exit 1; }
rm -rf /home/$check_user/$directory_name 2>/dev/null

echo "OK"
exit 0
```
