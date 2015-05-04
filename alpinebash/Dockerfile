FROM            mubiic/alpinebare
MAINTAINER      Howard Mei      <howardmei@mubiic.com>


# Update/install bash for future usages [optional: coreutils grep sed gawk findutils tar gzip]
RUN             apk update && apk add --update bash && rm -rf /tmp/* /var/cache/apk/* && \
                rm -rf /usr/share/doc/* /usr/share/man/* /usr/share/info/* /usr/share/lintian/* && \
                mkdir -p /opt/bin /opt/sbin /opt/shbin && chmod -R 755 /opt/bin /opt/sbin /opt/shbin

ENV             PATH            /opt/bin:/opt/sbin:/opt/shbin:$PATH
# Add bash environment files like bash_profile
COPY            root            /root

## Set HOME env var to make bashrc working with -l/--login option
## and also set it as Wordking Dir instead of using the default /
USER            root
ENV             HOME            /root
WORKDIR         /root

# Define base volume as a common attach point.
VOLUME          ["/opt/shbin"]

# Define default command as the entry point.
CMD             ["/bin/bash"]
