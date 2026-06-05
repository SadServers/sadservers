# "Podgorica": Docker to Podman migration

## Description

You have been tasked with migrating this future web server from using Docker (which uses a daemon) to <b>rootless Podman</b>.
<br>There is already an Nginx Podman image on the server, and your objective is to manage the container created from it using systemd, so the it starts automatically on reboot and continues running unless explicity stopped (the same behaviour expected from a Docker-managed container).
<br>Create a systemd service named <i>container-nginx.service</i> that manages the Podman Nginx container. Enable and start this service.
<br><br>
There is no need to reboot the VM, although if you want you could reboot it from the command line with <kbd>/sbin/shutdown -r now</kbd> and refresh or reopen the web console.

## Test

The checker script will test if the <i>container-nginx.service</i> is active and enabled, and if it can stop and start the service. It will also verify that <kbd>curl localhost:8888</kbd> returns the default "Welcome to nginx" web page.
<br><br>
The "Check My Solution" button runs the script <i>/home/admin/agent/check.sh</i>, which you can see and execute.


**check.sh**

```bash
#!/usr/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

# Perform operations
systemctl --user is-active container-nginx.service | grep -vq '^active$' && { echo -n "NO"; exit ; }
systemctl --user is-enabled container-nginx.service | grep -vq '^enabled$' && { echo -n "NO"; exit ; }
curl -s localhost:8888 | grep -Eo "Welcome to nginx" 2>&1 >/dev/null || { echo -n "NO"; exit ; }
systemctl --user stop container-nginx.service
curl -s localhost:8888 && { echo -n "NO"; exit ; }
systemctl --user start container-nginx.service
curl -s localhost:8888 | grep -Eo "Welcome to nginx" 2>&1 >/dev/null && { echo "OK"; exit ; }

echo -n "NO"
```
