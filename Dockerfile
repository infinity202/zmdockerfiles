FROM ubuntu:20.04
MAINTAINER Greg Cockburn

# Update base packages
RUN apt update \
    && apt upgrade --assume-yes

# Install pre-reqs
RUN apt install --assume-yes --no-install-recommends gnupg

# Configure Zoneminder PPA
RUN apt install -y software-properties-common

RUN apt install -y mysql-server

RUN add-apt-repository ppa:iconnor/zoneminder-1.36 \
    && apt update

# Install zoneminder
RUN DEBIAN_FRONTEND=noninteractive apt install --assume-yes zoneminder \
    && a2enconf zoneminder \
    && a2enmod rewrite headers cgi

RUN systemctl restart apache2

# Setup Volumes
VOLUME /var/cache/zoneminder/events /var/cache/zoneminder/images /var/lib/mysql /var/log/zm

# Expose http port
EXPOSE 80

# Configure entrypoint
COPY utils/entrypoint.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]