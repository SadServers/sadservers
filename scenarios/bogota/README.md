# Bogota

## Description

The Bogota office has a web server that logs all incoming requests to the `/var/log/nginx/access.log` file. The system administrators need to analyze this log file to identify the most frequently requested URLs.

Using the `/var/log/nginx/access.log` file, create a new file `/opt/top-urls.txt` containing the top 10 most frequently requested URLs, one URL per line, sorted by the number of requests in descending order.

## Test

Run the validation script to check your solution:

    /opt/sadservers/check.sh
