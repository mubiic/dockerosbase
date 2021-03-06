FROM            mubiic/alpinebare:3.2
MAINTAINER      Howard Mei      <howardmei@mubiic.com>
ENV             TIMEZONE        Asia/Singapore
ENV             LOCALE          en_US.UTF-8
ENV             BUILDTAG        alpinebash:3.2/r20150527/sg/A


# Add bash environment files like bash_profile
COPY            entry           /entry
COPY            root            /root

ENV             LANG            $LOCALE
ENV             LANGUAGE        $LOCALE
ENV             LC_ALL          $LOCALE

# Update/install bash, sed, curl etc and maybe more [coreutils, findutils to replace builtin busybox-*]
RUN             NewPackages="bash gawk xz bzip2 tree wget curl ca-certificates tzdata e2fsprogs" && \
                apk-install ${NewPackages} && chmod 0755 /entry && \
                mkdir -p /opt/bin /opt/sbin /opt/shbin && chmod -R 755 /opt/bin /opt/sbin /opt/shbin && \
                cp -f /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
                echo $TIMEZONE > /etc/timezone && date && apk-cleanup && \
                printf "\\n%s \\n%s \\n%s \\n%s \\n" "# Build Layer 2 Meta Info" \
                "Package ++: ${NewPackages}" \
                "Maintainer: Howard Mei <howardmei@mubiic.com>" "Build Tag: $BUILDTAG" >> /etc/kube-imagemeta

ENV             PATH            /opt/bin:/opt/sbin:/opt/shbin:$PATH

# Set Default User and Wordking Dir
USER            root
ENV             HOME            /root
WORKDIR         /root

# Define base volume as a common attach point.
VOLUME          ["/opt/shbin"]

# Define the Entry Point and/or Default Command
ENTRYPOINT      ["/entry"]
CMD             ["cat","/etc/kube-imagemeta"]
