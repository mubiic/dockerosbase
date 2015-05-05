FROM            mubiic/ubuntucore:15.04
MAINTAINER      Howard Mei      <howardmei@mubiic.com>


ENV             DEBIAN_FRONTEND noninteractive
# Add apt repository mirror list, user local bin
COPY            etc             /etc
COPY            usr             /usr

# Set proper permission to configuration files and helper scripts
RUN             chmod 0644 /etc/apt/sources.list && chmod 0755 /usr/bin/apt-install \
                /usr/bin/apt-cleanup /usr/bin/apt-dpkg-wrapper /usr/bin/apt-remove

# Create *min files for apt* and dpkg* in order to avoid issues with locales
# and interactive interfaces
RUN             ls /usr/bin/apt* /usr/bin/dpkg* |                        \
                while read line; do                                      \
                    pkmin=$line-min;                                     \
                    printf '#!/bin/sh\n/usr/bin/apt-dpkg-wrapper '$line' $@\n' > $pkmin; \
                    chmod 0755 $pkmin;                                   \
                done


# Temporarily disable dpkg fsync to make building faster
RUN             if [ ! -e /etc/dpkg/dpkg.cfg.d/docker-apt-speedup ]; then           \
                    echo force-unsafe-io > /etc/dpkg/dpkg.cfg.d/docker-apt-speedup; \
                fi

# Prevent initramfs updates from trying to run grub and lilo.
# https://journal.paul.querna.org/articles/2013/10/15/docker-ubuntu-on-rackspace/
# http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=594189
ENV             INITRD no

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

# Update existing system and install essential packages
RUN             apt-get-min update && apt-get-min dist-upgrade -yq --no-install-recommends && \
                apt-install-min adduser sudo passwd gnupg gpgv ubuntu-keyring inetutils-ping iproute2 && \
                mv -f /etc/sudoers.tpl /etc/sudoers && chmod 0440 /etc/sudoers && apt-cleanup-min

# Create a www data user without shell access nor home dir
RUN             adduser --system --shell /bin/false --gecos 'WWW User in WWW-Data Group' \
                --ingroup www-data --disabled-password --no-create-home www && \
                mkdir -p /var/www && touch /var/www/.placeholder && chown -R www:www-data /var/www && \
                unset DEBIAN_FRONTEND && env --unset=DEBIAN_FRONTEND

# Set Default User and Wordking Dir
USER            root
ENV             HOME            /root
WORKDIR         /root

# Define base volume as a common attach point.
VOLUME          ["/var/www"]

# Define default command as the entry point.
CMD             ["/bin/bash"]
