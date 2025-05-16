# "Saint Paul": Merge Many CSVs files

## Description

Join (merge) all the 338 files in _/home/admin/polldayregistrations_enregistjourduscrutin?????.csv_ into one single _/home/admin/all.csv_ file with the contents of all the CSV files in any order. There should be only one line with the names of the columns as a header.


## Test

The "Check My Solution" button runs the script _/home/admin/agent/check.sh_, which you can see and execute.

**check.sh**

```bash
#!/usr/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

cd /home/admin

expected_header=$(head -n 1 polldayregistrations_enregistjourduscrutin62001.csv)
expected_lines=72461

# count number of lines in the all.csv file
lines=$(wc -l all.csv | cut -d ' ' -f 1)

# if lines is not exaclty expected_lines, print "NO"
if [ $lines -ne $expected_lines ]; then
  echo -n "NO"
  exit
fi

# if expected_header is more than once in all.csv, print "NO"
if [ $(grep -c "$expected_header" all.csv) -gt 1 ]; then
  echo -n "NO"
  exit
fi

# get a random existing file from the current directory
random_file=$(ls polldayregistrations_enregistjourduscrutin?????.csv| shuf -n 1)

# get a random line from any of the pollbypoll_bureauparbureau?????.csv
random_line=$(grep -v "$expected_header" $random_file | shuf -n 1)

# check if random_line is in all.csv file
if grep -q "$random_line" all.csv; then
  echo -n "OK"
  exit
else
  echo -n "NO"
fi
```
