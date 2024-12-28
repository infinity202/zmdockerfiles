FROM almalinux:latest
MAINTAINER Greg Cockburn

# Update base packages
RUN dnf update -y \
    && dnf upgrade -y

# Install pre-reqs
RUN dnf install epel-release -y

# Configure Zoneminder PPA
#RUN dnf install dnf-plugins-core -y
#RUN dnf config-manager --set-enabled powertools -y

RUN dnf install dnf-plugins-core  -y

RUN dnf config-manager --set-enabled crb

RUN dnf install httpd.x86_64 httpd-tools.x86_64 mariadb.x86_64 mariadb-common.x86_64 -y
# Install zoneminder
RUN dnf install zoneminder-httpd -y
#RUN dnf install zoneminder  -y

#RUN systemctl restart apache2

# Setup Volumes
VOLUME /var/cache/zoneminder/events /var/cache/zoneminder/images /var/lib/mysql /var/log/zm

# Expose http port
EXPOSE 80

# Configure entrypoint
COPY utils/entrypoint.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
