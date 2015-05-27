### Alpine/Ubuntu bare Docker images for Mubiic application containers/kubes
#### Author: [Howard Mei](howardmei at mubiic dot com)
#### License: Apache
#### Credits: [textlab@github](https://github.com/textlab/glossa/tree/master/script), [just-containers@github](https://github.com/just-containers/base)

#### Considerations and Intentions:

alpinebare: main data volume base image
alpinebash: main tooling/hub base image
ubuntubash: main tooling/hub base image where alpinebash lacks proper packages/envs
alpineproc: auxiliary application base image where installations and configs are simple

**Java runtime and other musl libc incompatible applications are required to use ubuntuproc,
though there is [a hack for glibc](https://github.com/andyshinn/alpine-pkg-glibc) reliant apps on alpine**

#### Images Building Tree:

```
    alpine:3.2 + apk mirror conf
          --> alpinebare:3.2(latest) + timezone, locale, bash profile settings
                        --> alpinebash:3.2(latest) + s6 init suite overlay
                                      --> alpineproc:3.2(latest)
```

```
    ubuntu-debootstrap:15.04/14.04 - dpkg selections + apt conf and various workarounds
            --> ubuntubare:15.04/14.04(latest) + timezone, locale, bash profile settings
                        --> ubuntubash:15.04/14.04(latest) + s6 init suite overlay
                                     --> ubuntuproc:15.04/14.04(latest)
```

#### Images Sizes:
alpine:3.2 ~ 5MB, alpinebare:3.2 ~ 10MB, alpinebash:3.2 ~ 18MB;
ubuntu-debootstrap:14.04.2 ~ 87MB, ubuntucore:14.04 ~ 56MB, ubuntubare:14.04 ~ 60MB, ubuntubash:14.04 ~ 87MB;
ubuntu-debootstrap:15.04 ~ 110MB, ubuntucore:15.04  ~ 95MB, ubuntubare:15.04  ~ 98MB, ubuntubash:15.04 ~ 125MB;

#### Script Usage:
Build one:
```
    cd dockerosbase && ./localbuild alpineproc | tee alpineproc_build.log
```
Build all:
```
    cd dockerosbase && ./localbuild | tee all_build.log
```
Build ubuntucore:
```
    cd ubuntucore && ./prebuild [15.04]
    ./gendiff [15.04]  ##generate package difflist
```

#### Available Images:
Base Image Repo is located at:[mubiic/dockerosebase@github](https://github.com/mubiic/dockerosbase)
Proc Image Repo is located at:[mubiic/dockerosebase@github](https://github.com/mubiic/dockerprocbase)
Public Images are avaliable at: [mubiic@dockerhub](https://registry.hub.docker.com/repos/mubiic/)

### mubiic/alpine*, ubuntu* images usage:
#### Check image meta
docker run --rm -it mubiic/alpinebare
docker run --rm -it mubiic/alpineproc cat /etc/kube-imagemeta

#### Add new/Del old packages
Alpine
```
    RUN apk update && apk add --update pkg1 pkg2 ... pkgn && \
        apk del oldpkg && apk-cleanup
```
Ubuntu
```
    RUN apt-get-min update && apt-install-min pkg1 pkg2 ... pkgn && \
        apt-remove-min oldpkg && apt-cleanup-min

```
#### Mount Ad-hoc binaries
docker run --rm -it mubiic/alpinebash -v $(pwd)/abspath:/opt/shbin/abspath abspath .

### Proc image s6 init manager usage
s6 init config dir by applying order[inside scripts applying order is according to naming sort,
so 00-servicename0, 01-servicename1, 0N-servicenameN are the proper script names]:
/etc/fix-attrs.d      holds scripts to ensure files owners and permissions are correct
/etc/cont-init.d      holds one-time system scripts to execute container init before all
/etc/services.d       holds user services for long-lived daemon processes to be supervised:
**s6-setuidgid could be used to run daemon as another user in following scripts**
/etc/services.d/*/run           hold service daemons running management scripts
/etc/services.d/*/finish        hold service daemons exit clean up scripts
/etc/services.d/*/log/run       hold service daemons running logging scripts
/etc/services.d/*/log/finish    hold service daemons exit logging scripts
/etc/cont-finish.d    holds one-time system scripts to clean up container env before exit

s6init working dir: /var/run/s6

#### References:
[Docker File Best Practices](http://docs.docker.com/articles/dockerfile_best-practices/)
[Docker Tips and Traps](http://mrbluecoat.blogspot.com/2014/10/docker-traps-and-how-to-avoid-them.html)

