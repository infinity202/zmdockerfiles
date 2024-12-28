FROM almalinux:latest
MAINTAINER Greg Cockburn

# Update base packages
RUN dnf update -y \
    && dnf upgrade -y

# Install pre-reqs
RUN dnf install epel-release -y

# Configure Zoneminder PPA
RUN dnf install --nogpgcheck https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-9.noarch.rpm  -y

RUN dnf install dnf-plugins-core  -y

RUN dnf config-manager --set-enabled crb

# Install zoneminder
RUN dnf install --nogpgcheck http://zmrepo.zoneminder.com/el/9/x86_64/zmrepo-9-2.el9.noarch.rpm  -y \
    dnf install zoneminder  -y

#RUN systemctl restart apache2

# Setup Volumes
VOLUME /var/cache/zoneminder/events /var/cache/zoneminder/images /var/lib/mysql /var/log/zm

# Expose http port
EXPOSE 80

# Configure entrypoint
COPY utils/entrypoint.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
