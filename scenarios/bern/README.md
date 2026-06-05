# "Bern": Docker web container can't connect to db container.

## Description

There are two Docker containers running, a web application (Wordpress or WP) and a database (MariaDB) as back-end, but if we look at the web page, we see that it cannot connect to the database.
<kbd>curl -s localhost:80 |tail -4</kbd> returns:<br><br>
<code>
&lt;body id="error-page"&gt;
	&lt;div class="wp-die-message">&lt;h1&gt;Error establishing a database connection&lt;/h1&gt;&lt;/div&gt;&lt;/body&gt;
&lt;/html&gt;
<br><br>
</code>
This is not a Wordpress code issue (the image is :latest with some network utilities added). What you need to know is that WP uses "WORDPRESS_DB_" environment variables to create the MySQL connection string. See the ./html/wp-config.php WP config file for example (from /home/admin).<br><br>

## Test

<kbd>sudo docker exec wordpress mysqladmin -h mysql -u root -ppassword ping</kbd> . The wordpress container is able to connect to the database in the mariadb container and returns <kbd>mysqld is alive</kbd>.

<b>check.sh</b>

```
#!/usr/bin/bash
res=$(sudo docker exec wordpress mysqladmin -h mysql -u root -ppassword --connect-timeout 2 ping)
res=$(echo $res|tr -d '\r')

if [[ "$res" = "mysqld is alive" ]]
then
  echo -n "OK"
else
  echo -n "NO"
fi
```
