FROM            mubiic/ubuntucore:15.04
MAINTAINER      Howard Mei      <howardmei@mubiic.com>
ENV             BUILDTAG        ubuntubare:15.04/r20150512/sg/A


# Add apt repository mirror list, user local bin
COPY            entry           /entry
COPY            etc             /etc
COPY            usr             /usr

# Set proper permission to configuration files and helper scripts and create *min files
# for apt* and dpkg* in order to avoid issues with locales and interactive interfaces
# Add support to debonly installation, all *.deb packages in /opt/debonly will be managed by
# apt-debonly, apt-install and apt-remove, apt-cleanup
RUN             chmod 0777 /entry && chmod 0755 /usr/bin/apt-install /usr/bin/apt-debonly \
                /usr/bin/apt-dpkg-wrapper /usr/bin/apt-remove /usr/bin/apt-cleanup && \
                ls /usr/bin/apt* /usr/bin/dpkg* |                        \
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
RUN             NewPackages="apt-utils gpgv sudo procps lsof gawk xz-utils unzip ubuntu-keyring \
                inetutils-ping iproute2" && DEBIAN_FRONTEND=noninteractive && apt-get-min update && \
                apt-install-min ${NewPackages} && \
                mv -f /etc/sudoers.tpl /etc/sudoers && chmod 0440 /etc/sudoers && apt-cleanup-min && \
                printf "\\n%s \\n%s \\n%s \\n%s \\n" "# Build Layer 1 Meta Info" \
                "Package ++: ${NewPackages}" \
                "Maintainer: Howard Mei <howardmei@mubiic.com>" "Build Tag: $BUILDTAG" >> /etc/kube-imagemeta

# Create sudoer groups: sudoer & admin [PASSWD] and creat a www user in www-data group
RUN             addgroup admin && addgroup sudoer && \
                adduser --system --shell /bin/false --gecos 'WWW User in WWW-Data Group' \
                --ingroup www-data --disabled-password --no-create-home www && \
                mkdir -p /var/www && touch /var/www/.placeholder && chown -R www:www-data /var/www && \
                unset DEBIAN_FRONTEND && env --unset=DEBIAN_FRONTEND

# Set Default User and Wordking Dir
USER            root
ENV             HOME            /root
WORKDIR         /root

# Define base volume as a common attach point.
VOLUME          ["/var/www"]

# Define the Entry Point and/or Default Command
ENTRYPOINT      ["/entry"]
CMD             ["cat","/etc/kube-imagemeta"]
## Notice: Use ["/entry"] as ENTRYPOINT instead of ["/bin/bash","-ilc"] to avoid arg parsing issue
## /bin/bash -ilc "arg1 arg2 ... argn" has its own builtin args parser which demands full quoted args
## CMD ["cat","/etc/kube-imagemeta"] will cause errors and "cat /etc/kube-imagemeta" will work
## but it's incompatible with the default docker run convention. The /entry works on both styles.
