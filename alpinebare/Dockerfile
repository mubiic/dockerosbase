FROM            alpine:3.1
MAINTAINER      Howard Mei      <howardmei@mubiic.com>


# Add apk repository mirror list and sudoer conf
COPY            etc/apk        /etc/apk
COPY            etc/sudoers    /etc/sudoers

# Update bash and basic utils for future usages
RUN             chmod 0644 /etc/apk && chmod 0440 /etc/sudoers && \
                apk update && rm -rf /tmp/* /var/cache/apk/*

## Set HOME env var to make bashrc working with -l/--login option
## and also set it as Wordking Dir instead of using the default /
USER            root
ENV             HOME            /root
WORKDIR         /root

# Create a www daemon user as sudoer without shell access nor home dir
RUN             addgroup -S sudoer && \
                adduser -S -s /bin/false -g 'Sudo Users For WWW Daemons' -G sudoer -D -H wwwd && \
                mkdir -p /var/www && touch /var/www/.placeholder && chown -R wwwd:sudoer /var/www

# Define base volume as a common attach point.
VOLUME          ["/var/www"]

# Define default command as the entry point.
CMD             ["/bin/sh"]
