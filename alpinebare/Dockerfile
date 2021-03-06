FROM            alpine:3.2
MAINTAINER      Howard Mei      <howardmei@mubiic.com>
ENV             BUILDTAG        alpinebare:3.2/r20150527/sg/A


# Add apk repository mirror list and user local bin
COPY            entry           /entry
COPY            etc             /etc
COPY            usr             /usr

# Update bash and basic utils for future usages
RUN             NewPackages="libgcc sed tar gzip zlib libbz2 unzip sudo lsof iputils iproute2" && chmod 0755 /entry && \
                chmod 0644 /etc/apk/repositories && chmod 0755 /usr/bin/apk-install /usr/bin/apk-cleanup && \
                apk upgrade --update-cache --available && apk-install ${NewPackages} && \
                mv -f /etc/sudoers.tpl /etc/sudoers && chmod 0440 /etc/sudoers && \
                printf "\\n%s \\n%s \\n%s \\n%s \\n" "# Build Layer 1 Meta Info" \
                "Package ++: ${NewPackages}" \
                "Maintainer: Howard Mei <howardmei@mubiic.com>" "Build Tag: $BUILDTAG" >> /etc/kube-imagemeta

# Create sudoer groups: sudo[NOPASSWD] similar to existing group wheel[NOPASSWD], sudoer & admin[PASSWD]
# and creat a www-data user in www-data group
RUN             addgroup -S sudo && addgroup admin && addgroup sudoer && \
                adduser -S -s /bin/false -g 'WWW-Data User in WWW-Data Group' -G www-data -D -H www-data && \
                mkdir -p /var/www && touch /var/www/.placeholder && chown -R www-data:www-data /var/www

# Set Default User and Wordking Dir
USER            root
ENV             HOME            /root
WORKDIR         /root

# Define base volume as a common attach point
VOLUME          ["/var/www"]

# Define the Entry Point and/or Default Command
ENTRYPOINT      ["/entry"]
CMD             ["cat","/etc/kube-imagemeta"]
## Notice: Use ["/entry"] as ENTRYPOINT instead of ["/bin/sh","-ilc"] to avoid arg parsing issue
## /bin/sh -ilc "arg1 arg2 ... argn" has its own builtin args parser which demands full quoted args
## where CMD ["cat","/etc/kube-imagemeta"] will cause errors and "cat /etc/kube-imagemeta" will work
## but it's incompatible with the default docker run convention. The /entry works on both styles.
