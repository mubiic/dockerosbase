FROM            mubiic/alpinebash:3.1
MAINTAINER      Howard Mei      <howardmei@mubiic.com>
ENV             TIMEZONE        Asia/Singapore
ENV             LOCALE          en_US.UTF-8
ENV             KUBECONF        **TBD**
ENV             APPCONF         **TBD**
ENV             BUILDTAG        alpineproc:3.1/r20150507/sg/A

# Add conf to fix s6 init suite permissions
COPY            entry           /entry
COPY            etc             /etc

# Remove sudo package in proc image, use /usr/bin/gosu instead for better security
RUN             NewPackages="procps procps-dev" && chmod 0777 /entry && \
                apk update && apk add --update ${NewPackages} tzdata && \
                cp -f /usr/share/zoneinfo/${TIMEZONE} /etc/localtime && \
                echo $TIMEZONE > /etc/timezone && date && apk del tzdata && apk-cleanup && \
                printf "\\n%s \\n%s \\n%s \\n%s \\n" "# Build Layer 3 Meta Info" \
                "Package ++: [s6 suite overlay], ${NewPackages}" \
                "Maintainer: Howard Mei <howardmei@mubiic.com>" "Build Tag: $BUILDTAG" >> /etc/kube-imagemeta


# Update the locale env variables only, because no language-pack or locales apk are found.
ENV             LANG            $LOCALE
ENV             LANGUAGE        $LOCALE
ENV             LC_ALL          $LOCALE

# Add s6 suite overlay to provide init manager
ADD             https://github.com/just-containers/s6-overlay/releases/download/v1.10.0.0/s6-overlay-amd64.tar.gz /tmp/s6-overlay.tar.gz
RUN             tar xvfz /tmp/s6-overlay.tar.gz -C / && rm -f /tmp/s6-overlay.tar.gz

# Create a devops user in sudo group and initialize its home directory
RUN             adduser -S -s /bin/bash -g 'DevOps User in Sudo Group' \
                -G sudo -D -h /home/devops devops && \
                cp -f /root/.bashrc /root/.bash_profile /root/.bash_prompt /root/.inputrc \
                      /root/.gitconfig /root/.gitignore /root/.gitattributes /home/devops && \
                chown -R devops:sudo /home/devops && \
                mkdir -p /opt/app && touch /opt/app/.placeholder && chown -R devops:sudo /opt/app

# Set Default User and Wordking Dir
USER            root
ENV             HOME            /root
WORKDIR         /opt/app

# Define base volume as a common attach point.
VOLUME          ["/opt/app"]

# Define the Entry Point and/or Default Command
ENTRYPOINT      ["/init"]
CMD []
