# "Pokhara": SSH and other sshenanigans

## Description

A user <kbd>client</kbd> was added to the server, as well as their SSH public key.<br>
The objective is to be able to SSH locally (there's only one server) as this user <i>client</i> using their ssh keys. This is, if as root you change to this user <kbd>sudo su; su client</kbd>, you should be able to login with ssh: <kbd>ssh localhost</kbd>.<br><br>

## Test

As user <i>admin</i>: <kbd>sudo -u client ssh client@localhost 'pwd'</kbd> returns <kbd>/home/client</kbd>

<b>check.sh</b>

```
#!/usr/bin/bash
res=$(sudo -u client ssh client@localhost 'pwd')
res=$(echo $res|tr -d '\r')

if [[ "$res" = "/home/client" ]]
then
  echo -n "OK"
else
  echo -n "NO"
fi
```
