FROM            alpine:3.1
MAINTAINER      Howard Mei      <howardmei@mubiic.com>


# Add apk repository mirror list and user local bin
COPY            etc             /etc
COPY            usr             /usr

# Update bash and basic utils for future usages
RUN             apk update && apk add --update sudo && mv -f /etc/sudoers.tpl /etc/sudoers && \
                chmod 0644 /etc/apk && chmod 0440 /etc/sudoers && \
                chmod 0755 /usr/bin/apk-cleanup && apk-cleanup

# Create a www data user without shell access nor home dir
RUN             adduser -S -s /bin/false -g 'WWW User in WWW-Data Group' -G www-data -D -H www && \
                mkdir -p /var/www && touch /var/www/.placeholder && chown -R www:www-data /var/www

## Set HOME env var to make bashrc working with -l/--login option
## and also set it as Wordking Dir instead of using the default /
USER            root
ENV             HOME            /root
WORKDIR         /root

# Define base volume as a common attach point.
VOLUME          ["/var/www"]

# Define default command as the entry point.
CMD             ["/bin/sh"]
