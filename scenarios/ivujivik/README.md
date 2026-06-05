# Scenario 29: "Ivujivik": Parlez-vous Français?

## Description

Given the CSV file <i>/home/admin/table_tableau11.csv</i>, find the <i>Electoral District Name/Nom de circonscription</i> that has the largest number of <i>Rejected Ballots/Bulletins rejetés</i> and also has a population of less than 100,000.
<br><br>
The initial CSV file may be corrupted or invalid in a way that can be fixed without changing its data.
<br><br>
Installed in the VM are: Python3, Go, sqlite3, <a href="https://miller.readthedocs.io/en/latest/" target="_blank">miller</a> directly and PostgreSQL, MySQL in Docker images.
<br><br>
Save the solution in the /home/admin/mysolution , with the name as it is in the file, for example: <kbd>echo "Trois-Rivières" > ~/mysolution</kbd> (the solution must be terminated by newline).

## Test

<kbd>md5sum</kbd> /home/admin/mysolution returns <kbd>e399d171f21839a65f8f8ab55ed1e1a1</kbd>

<b>check.sh</b>

```
#!/usr/bin/bash
res=$(md5sum /home/admin/mysolution |awk '{print $1}')
res=$(echo $res|tr -d '\r')

if [[ "$res" = "e399d171f21839a65f8f8ab55ed1e1a1" ]]
then
  echo -n "OK"
else
  echo -n "NO"
fi

```
