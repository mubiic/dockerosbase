FROM            mubiic/alpinebare:3.1
MAINTAINER      Howard Mei      <howardmei@mubiic.com>


# Update/install bash and add curl with https support
RUN             apk update && apk add --update bash coreutils curl ca-certificates && apk-cleanup && \
                mkdir -p /opt/bin /opt/sbin /opt/shbin && chmod -R 755 /opt/bin /opt/sbin /opt/shbin

ENV             PATH            /opt/bin:/opt/sbin:/opt/shbin:$PATH
# Add bash environment files like bash_profile
COPY            root            /root

# Set Default User and Wordking Dir
USER            root
ENV             HOME            /root
WORKDIR         /root

# Define base volume as a common attach point.
VOLUME          ["/opt/shbin"]

# Define default command as the entry point.
CMD             ["/bin/bash"]
