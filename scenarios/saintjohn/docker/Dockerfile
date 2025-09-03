# saintjohn
#
FROM debian:11.6-slim

# Update packages and install dependencies
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends lsof python3-pip psmisc \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy files to container
COPY files/badlog.py /home/admin/badlog.py
COPY files/check.sh /home/admin/agent/check.sh
COPY files/badlog.conf /etc/supervisor/conf.d/badlog.conf

# Set permissions for badlog.py and check.sh
RUN chmod +x /home/admin/badlog.py
RUN chmod +x /home/admin/agent/check.sh

# Create log file
RUN touch /var/log/bad.log
RUN chown admin:admin /var/log/bad.log

CMD ["/usr/bin/supervisord"]
