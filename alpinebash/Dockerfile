FROM            mubiic/alpinebare:3.1
MAINTAINER      Howard Mei      <howardmei@mubiic.com>
ENV             BUILDTAG        alpinebash:3.1/r20150506/sg/A


# Update/install bash, sed, curl etc and maybe more [coreutils, findutils to replace builtin busybox-*]
RUN             NewPackages="bash sed gawk tar gzip unzip@edge openssl wget curl ca-certificates" && \
                apk update && apk add --update ${NewPackages} && apk-cleanup && \
                mkdir -p /opt/bin /opt/sbin /opt/shbin && chmod -R 755 /opt/bin /opt/sbin /opt/shbin && \
                printf "\\n%s \\n%s \\n%s \\n%s \\n" "# Build Layer 2 Meta Info" \
                "Package ++: ${NewPackages}" \
                "Maintainer: Howard Mei <howardmei@mubiic.com>" "Build Tag: $BUILDTAG" >> /etc/kube-imagemeta

ENV             PATH            /opt/bin:/opt/sbin:/opt/shbin:$PATH
# Add bash environment files like bash_profile
COPY            root            /root

# Set Default User and Wordking Dir
USER            root
ENV             HOME            /root
WORKDIR         /root

# Define base volume as a common attach point.
VOLUME          ["/opt/shbin"]

# Define the Entry Point and/or Default Command
ENTRYPOINT      ["/bin/bash","-ilc"]
CMD             ["cat /etc/kube-imagemeta"]
