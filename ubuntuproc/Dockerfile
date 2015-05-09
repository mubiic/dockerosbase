FROM            mubiic/ubuntubash:15.04
MAINTAINER      Howard Mei      <howardmei@mubiic.com>
# LANG is tricky, e.g. zh-hans vs zh-hant, check language-pack-* before set
ENV             LANGPACK        en
# LANG and LOCALE env produces the real locale setting: ${LANG}_${LOCALE}.UTF8
ENV             LOCALE          SG
ENV             KUBECONF        **TBD**
ENV             APPCONF         **TBD**
ENV             BUILDTAG        ubuntuproc:15.04/r20150507/sg/A


ENV             LANG            ${LANGPACK}_${LOCALE}.UTF8
ENV             LANGUAGE        ${LANGPACK}_${LOCALE}.UTF8
ENV             LC_ALL          ${LANGPACK}_${LOCALE}.UTF8

ENV             DEBIAN_FRONTEND noninteractive
# Update the timezone and locale according to the env variables set above
RUN             NewPackages="htop procps locales tzdata language-pack-${LANGPACK} language-pack-${LANGPACK}-base" && \
                DEBIAN_FRONTEND=noninteractive && apt-get-min update && apt-install-min ${NewPackages} && \
                 && apt-cleanup-min && \
                locale-gen en_US.UTF-8 $LC_ALL && update-locale LANG=$LANG LC_CTYPE=$LC_ALL && \
                printf "\\n%s \\n%s \\n%s \\n%s \\n" "# Build Layer 2 Meta Info" \
                "Package ++: ${NewPackages}" \
                "Maintainer: Howard Mei <howardmei@mubiic.com>" "Build Tag: $BUILDTAG" >> /etc/kube-imagemeta

ENV             LANG            $LOCALE
ENV             LANGUAGE        $LOCALE
ENV             LC_ALL          $LOCALE

# Add s6suite overlay to provide init manager
ADD             https://github.com/just-containers/s6-overlay/releases/download/v1.9.1.3/s6-overlay-amd64.tar.gz /tmp/s6-overlay.tar.gz
RUN             tar xvfz /tmp/s6-overlay.tar.gz -C / && rm -f /tmp/s6-overlay.tar.gz


# Create a devops user in sudo group and initialize its home directory
# Remember to use gosu devops:sudo to run daemon processes because sudo is removed here
RUN             adduser --system --shell /bin/bash --gecos 'DevOps User in Sudo Group' \
                --ingroup sudo --disabled-password --home /home/devops devops && \
                cp -f /root/.bashrc /root/.bash_profile /root/.bash_prompt /root/.inputrc \
                      /root/.gitconfig /root/.gitignore /root/.gitattributes /home/devops && \
                chown -R devops:sudo /home/devops && \
                mkdir -p /opt/app && touch /opt/app/.placeholder && chown -R devops:sudo /opt/app && \
                unset DEBIAN_FRONTEND && env --unset=DEBIAN_FRONTEND

# Set Default User and Wordking Dir
USER            devops
ENV             HOME            /home/devops
WORKDIR         /opt/app

# Define base volume as a common attach point.
VOLUME          ["/opt/app"]

ENTRYPOINT ["/init"]
CMD []
