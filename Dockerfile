FROM amazonlinux:2023

# Update the base image and install necessary packages
# Layered image caching might not work with yum update as it fetches the latest package versions
RUN dnf upgrade -y \
    dnf install -y \
    httpd \
    openssh-server \
    openssh-clients \
    openssl \
    unzip \
    wget \
    mariadb105-server \
    php-fpm \
    php-mysqli \
    php-json \
    php \
    php-devel && \
    # passwd && \
    dnf clean all

# systemd does not run in docker containers
# Enable Apache HTTP server (httpd) and mariadb (MySQL)
# RUN systemctl enable httpd && \
#     systemctl enable mariadb

# Configure SSH
# The SSH daemon (sshd) requires this directory to store runtime files, including the process ID file (sshd.pid)
RUN mkdir -p /run/sshd && \
    # Sets the root user's password
    # echo 'root:password' | chpasswd && \
    # echo "root:password" | tee /etc/shadow && \
    echo "root:password" | tee /etc/shadow
    # Generates the necessary host key pairs for the SSH server. These are stored in /etc/ssh by default.
    # ssh-keygen -A

# Expose ports for HTTP, HTTPS, and SSH
EXPOSE 22 80 443

# Copy the default index.php to the container's web root
COPY index.php /var/www/html/

# Start both httpd and sshd services
# CMD ["/bin/bash", "-c", "/usr/sbin/httpd -D FOREGROUND & /usr/sbin/mysqld", "cat /etc/system-release"]
CMD ["/bin/bash"]
