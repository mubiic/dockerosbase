FROM            mubiic/alpinebash
MAINTAINER      Howard Mei      <howardmei@mubiic.com>
ENV             TIMEZONE        Asia/Singapore
ENV             LOCALE          en_US.UTF-8
ENV             KUBECONF        **None**
ENV             APPCONF         **None**

# Update the locale and timezone according to the env variables set above
ENV             LANG            $LOCALE
ENV             LANGUAGE        $LOCALE
ENV             LC_ALL          $LOCALE

RUN             apk update && apk add --update tzdata && \
                cp -f /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
                echo $TIMEZONE > /etc/timezone && date && \
                apk del tzdata && rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

# Add conf to fix permissions and
COPY            etc             /etc
COPY            usr             /usr

# Add s6suite overlay to provide init manager
ADD             https://github.com/just-containers/s6-overlay/releases/download/v1.9.1.3/s6-overlay-amd64.tar.gz /tmp/s6-overlay.tar.gz
RUN             tar xvfz /tmp/s6-overlay.tar.gz -C / && rm -f /tmp/s6-overlay.tar.gz && chmod +x /usr/bin/ts

# Create a devops user as sudoer and initialize its directories
# Create a www daemon user as sudoer without shell access nor home dir
RUN             adduser -S -s /bin/bash -g 'Sudo Users For DevOps' \
                -G sudoer -D -h /home/devops devops && \
                cp -f /root/.bashrc /root/.bash_profile /root/.bash_prompt /root/.inputrc \
                      /root/.gitconfig /root/.gitignore /root/.gitattributes /home/devops && \
                chown -R devops:sudoer /home/devops && \
                mkdir -p /opt/app && touch /opt/app/.placeholder && chown -R devops:sudoer /opt/app

# Define base volume as a common attach point.
VOLUME          ["/opt/app"]

ENTRYPOINT ["/init"]
CMD []
