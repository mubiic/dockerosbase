FROM            alpine:3.1
MAINTAINER      Howard Mei      <howardmei@mubiic.com>
ENV             BUILDTAG        alpinebare:3.1/r20150506/sg/A


# Add apk repository mirror list and user local bin
COPY            etc             /etc
COPY            usr             /usr

# Update bash and basic utils for future usages
RUN             NewPackages="sudo lsof iputils" && \
                chmod 0644 /etc/apk/repositories && chmod 0755 /usr/bin/apk-cleanup && \
                apk update && apk add --update ${NewPackages} && apk-cleanup && \
                mv -f /etc/sudoers.tpl /etc/sudoers && chmod 0440 /etc/sudoers && \
                printf "\\n%s \\n%s \\n%s \\n%s \\n" "# Build Layer 1 Meta Info" \
                "Package ++: ${NewPackages}" \
                "Maintainer: Howard Mei <howardmei@mubiic.com>" "Build Tag: $BUILDTAG" >> /etc/kube-imagemeta

# Create sudoer groups: sudo[NOPASSWD] similar to existing group wheel[NOPASSWD], sudoer & admin[PASSWD]
# and creat a www user in www-data group
RUN             addgroup -S sudo && addgroup admin && addgroup sudoer && \
                adduser -S -s /bin/false -g 'WWW User in WWW-Data Group' -G www-data -D -H www && \
                mkdir -p /var/www && touch /var/www/.placeholder && chown -R www:www-data /var/www

# Set Default User and Wordking Dir
USER            root
ENV             HOME            /root
WORKDIR         /root

# Define base volume as a common attach point
VOLUME          ["/var/www"]

# Define the Entry Point and/or Default Command
ENTRYPOINT      ["/bin/sh","-ilc"]
CMD             ["cat /etc/kube-imagemeta"]
## Notice: /bin/sh -c 'arg1 arg2 ... argn' has its own builtin args parser
## CMD ["cat","/etc/kube-imagemeta"] will cause errors, always quote all args
