# "Minneapolis with a Vengeance": Break a CSV file


## Description

Break the Comma Separated Valued (CSV) file _data.csv_ in the _/home/admin/_ directory into exactly 10 smaller files of about the same size named _data-00.csv_, _data-01.csv_, ... , _data-09.csv_ files in the same directory. All the files should have the same header (first line with column names) as _data.csv_. None of the smaller files should be bigger than 32KB.  


Note: unlike the original [Minneapolis scenario](https://sadservers.com/scenario/minneapolis), here the resulting files have to be proper CSV files.  

As a helper tool, you can run the program check_csv.py to check if your data-??.cs files look like proper CSV files.

## Test

The "Check My Solution" button runs the script _/home/admin/agent/check.sh_, which you can see and execute.

**check.sh**

```bash
#!/usr/bin/bash
# DO NOT MODIFY THIS FILE ("Check My Solution" will fail)

cd /home/admin

expected_header=$(head -n 1 data.csv)
threshold=$((32 * 1024))
minlines=100

for i in {0..9}; do
    file="data-0$i.csv"

    if [[ -f "$file" ]]; then
        file_header=$(head -n 1 "$file")
        if [[ "$file_header" != "$expected_header" ]]; then
            echo -n "NO"
            exit
        fi

        filesize=$(stat -c%s "$file")
        if (( filesize > threshold )); then
            echo -n "NO"
            exit
        fi

        lines=$(wc -l < "$file")
        if (( lines < minlines )); then
            echo -n "NO"
            exit
        fi

        num_fields=$(echo "$expected_header" | awk -F, '{print NF}')
        if ! awk -v num_fields="$num_fields" '{
            # Count fields considering quotes
            gsub(/"[^"]*"/, "");  # Remove quoted fields
            n = split($0, fields, /,/);  # Split by comma
            if (n != num_fields) { exit 1 }
        }' "$file"; then
            echo -n "NO"
            exit
        fi

    else
        echo -n "NO"
        exit
    fi
done

echo -n "OK"
```
