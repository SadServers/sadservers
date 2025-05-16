# "Yokohama": Linux Users Working Together

## Description

There are four Linux users working together in a project in this server: abe, betty, carlos, debora.  

First, they have asked you as the sysadmin, to make it so each of these four users can read the project files of the other users in the <i>/home/admin/shared</i> directory, but none of them can modify a file that belongs to another user. Users should be able modify their own files.  

Secondly, they have asked you to modify the file shared/ALL so that any of these four users can write more content to it, but previous (existing) content cannot be altered.  


## Test

All users (abe, betty, carlos, debora) can write to their own files. None of them can write to another user's file.
All users can add more content (append)) to the shared/project_ALL file but none can change its current content.

The "Check My Solution" button runs the script _/home/admin/agent/check.sh_, which you can see and execute.

**check.sh**

```bash
#!/usr/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

users=(abe betty carlos debora)
shared_file="/home/admin/shared/ALL"
status="OK"

# Check that each user can write to their own file but not others'
for user in "${users[@]}"; do
    sudo -u "$user" bash -c "echo 'test' >> /home/admin/shared/project_$user" 2>/dev/null || status="NO"
    for other in "${users[@]}"; do
        if [[ "$user" != "$other" ]]; then
            sudo -u "$user" bash -c "echo 'fail' >> /home/admin/shared/project_$other" 2>/dev/null && status="NO"
        fi
    done
done

# Check that all users can append to shared file but not modify existing content
for user in "${users[@]}"; do
    # Ensure user can append
    sudo -u "$user" bash -c "echo 'new line' >> $shared_file" 2>/dev/null || status="NO"

    # Try truncating the file (which should fail if append-only)
    if sudo -u "$user" bash -c ": > $shared_file" 2>/dev/null; then
        status="NO"
    fi
done


echo -n "$status"
```
