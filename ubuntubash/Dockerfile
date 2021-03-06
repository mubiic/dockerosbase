FROM            mubiic/ubuntubare:15.04
MAINTAINER      Howard Mei      <howardmei@mubiic.com>
ENV             TIMEZONE        Asia/Singapore
ENV             LOCALE          en_US.UTF-8
ENV             BUILDTAG        ubuntubash:15.04/r20150527/sg/A

# Add bash profile for interactive terminal
COPY            entry           /entry
COPY            root            /root

# Creat additonal binary path and set proper permissions
RUN             chmod 0755 /entry && mkdir -p /opt/bin /opt/sbin /opt/shbin && \
                chmod -R 0755 /opt/bin /opt/sbin /opt/shbin

ENV             PATH            /opt/bin:/opt/sbin:/opt/shbin:$PATH

# Update timezone & locale, Install bash, curl and add HTTPS support to APT
RUN             NewPackages="gawk xz-utils bzip2 ca-certificates tree wget curl apt-transport-https locales tzdata e2fsprogs" && \
                DEBIAN_FRONTEND=noninteractive && apt-get-min update && apt-install-min ${NewPackages} && \
                cp -f /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && echo $TIMEZONE > /etc/timezone && \
                dpkg-reconfigure -f noninteractive tzdata && date && \
                locale-gen en_US.UTF-8 $LOCALE && update-locale LANG=$LOCALE LC_CTYPE=$LOCALE && apt-cleanup-min && \
                printf "\\n%s \\n%s \\n%s \\n%s \\n" "# Build Layer 2 Meta Info" \
                "Package ++: ${NewPackages}" \
                "Maintainer: Howard Mei <howardmei@mubiic.com>" "Build Tag: $BUILDTAG" >> /etc/kube-imagemeta

ENV             LANG            $LOCALE
ENV             LANGUAGE        $LOCALE
ENV             LC_ALL          $LOCALE

# Set Default User and Wordking Dir
USER            root
ENV             HOME            /root
WORKDIR         /root

# Define base volume as a common attach point.
VOLUME          ["/opt/shbin"]

# Define the Entry Point and/or Default Command
ENTRYPOINT      ["/entry"]
CMD             ["cat","/etc/kube-imagemeta"]
