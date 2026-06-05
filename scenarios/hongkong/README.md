# "Hong-Kong": can't write data into database.

## Description

(Similar to "Manhattan" scenario but harder). Your objective is to be able to insert a row in an existing Postgres database. The issue is not specific to Postgres and you don't need to know details about it (although it may help).<br><br>Postgres information: it's a service that listens to a port (:5432) and writes to disk in a data directory, the location of which is defined in the <i>data_directory</i> parameter of the configuration file <i>/etc/postgresql/14/main/postgresql.conf</i>. In our case Postgres is managed by <i>systemd</i> as a unit with name <i>postgresql</i>.

## Test

(from default admin user) <kbd>sudo -u postgres psql -c "insert into persons(name) values ('jane smith');" -d dt</kbd><br><br>Should return:<kbd>INSERT 0 1</kbd>
