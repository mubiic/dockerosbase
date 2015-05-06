FROM            mubiic/ubuntubare:15.04
MAINTAINER      Howard Mei      <howardmei@mubiic.com>
ENV             BUILDTAG        ubuntubare:15.04/r20150507/sg/A

# Add bash profile for interactive terminal
COPY            root            /root

# Creat additonal binary path and set proper permissions
RUN             mkdir -p /opt/bin /opt/sbin /opt/shbin && \
                chmod -R 0755 /opt/bin /opt/sbin /opt/shbin

ENV             PATH            /opt/bin:/opt/sbin:/opt/shbin:$PATH

# Update bash, coreutils and install Curl and add HTTPS support to APT
RUN             NewPackages="xz-utils wget curl ca-certificates apt-transport-https \
                gnupg-curl rsync" && DEBIAN_FRONTEND=noninteractive && \
                apt-get-min update && apt-install-min ${NewPackages} && apt-cleanup-min && \
                printf "\\n%s \\n%s \\n%s \\n%s \\n" "# Build Layer 2 Meta Info" \
                "Package ++: ${NewPackages}" \
                "Maintainer: Howard Mei <howardmei@mubiic.com>" "Build Tag: $BUILDTAG" >> /etc/kube-imagemeta

# Set Default User and Wordking Dir
USER            root
ENV             HOME            /root
WORKDIR         /root

# Define base volume as a common attach point.
VOLUME          ["/opt/shbin"]

# Define the Entry Point and/or Default Command
ENTRYPOINT      ["/bin/bash","-ilc"]
CMD             ["cat /etc/kube-imagemeta"]
