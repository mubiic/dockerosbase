FROM            ubuntu-debootstrap:14.04
MAINTAINER      Howard Mei      <howardmei@mubiic.com>


# Add apt repository mirror list, sudoer conf and bash profile
COPY            etc             /etc
COPY            root            /root
COPY            usr             /usr

# Set proper permission to add configuration files and helper scripts
RUN             chmod 0644 /etc/apt/sources.list && chmod 0440 /etc/sudoers && \
                mkdir -p /opt/bin /opt/sbin /opt/shbin && \
                chmod -R 755 /opt/bin /opt/sbin /opt/shbin && \
                chmod +x /usr/bin/apt-cleanup /usr/bin/apt-dpkg-wrapper /usr/bin/apt-install

ENV             PATH            /opt/bin:/opt/sbin:/opt/shbin:$PATH

# Create *min files for apt* and dpkg* in order to avoid issues with locales
# and interactive interfaces
RUN             ls /usr/bin/apt* /usr/bin/dpkg* |                        \
                while read line; do                                      \
                    min=$line-min;                                       \
                    printf '#!/bin/sh\n/usr/bin/apt-dpkg-wrapper '$line' $@\n' > $min; \
                    chmod +x $min;                                       \
                done

# Temporarily disable dpkg fsync to make building faster
RUN             if [ ! -e /etc/dpkg/dpkg.cfg.d/docker-apt-speedup ]; then         \
                    echo force-unsafe-io > /etc/dpkg/dpkg.cfg.d/docker-apt-speedup; \
                fi

# Prevent initramfs updates from trying to run grub and lilo.
# https://journal.paul.querna.org/articles/2013/10/15/docker-ubuntu-on-rackspace/
# http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=594189
ENV             INITRD no
RUN             export INITRD=no && mkdir -p /etc/container_environment && \
                echo -n no > /etc/container_environment/INITRD

# Fix some issues with APT packages.
# see https://github.com/dotcloud/docker/issues/1024
RUN             dpkg-divert-min --local --rename --add /sbin/initctl && \
                ln -sf /bin/true /sbin/initctl

# replace the 'ischroot' tool to make it always return true.
# prevent initscripts updates from breaking /dev/shm.
# https://journal.paul.querna.org/articles/2013/10/15/docker-ubuntu-on-rackspace/
# https://bugs.launchpad.net/launchpad/+bug/974584
RUN             dpkg-divert-min --local --rename --add /usr/bin/ischroot && \
                ln -sf /bin/true /usr/bin/ischroot

# Install HTTPS support for APT and install add-apt-repository
RUN             apt-get-min update -yq && apt-install-min apt-transport-https ca-certificates \
                software-properties-common && apt-cleanup-min

# Create a devops user as sudoer and initialize its directories
# Create a www daemon user as sudoer without shell access nor home dir
RUN             addgroup --system sudoer && \
                adduser --system --shell /bin/false --gecos 'Sudo Users For WWW Daemons' \
                --ingroup sudoer --disabled-password --no-create-home wwwd && \
                mkdir -p /var/www && touch /var/www/.placeholder && chown -R wwwd:sudoer /var/www

# Define base volume as a common attach point.
VOLUME          ["/var/www"]
# Define default command as the entry point.
CMD             ["/bin/bash"]
