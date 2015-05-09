### Alpine/Ubuntu bare Docker images for Mubiic application containers/kubes  
#### Author: [Howard Mei](howardmei at mubiic dot com)  
#### License: Apache  
#### Credits: [textlab@github](https://github.com/textlab/glossa/tree/master/script), [just-containers@github](https://github.com/just-containers/base)  

#### Considerations and Intentions:  
Choose alpine over debian/ubuntu/centos for its tiny size.  
Choose alpine over busybox/tinycore/... for its apk system maturity.  
Choose ubuntu-debootstrap over ubuntu for its cleanness and smaller footprint.  
Choose ubuntu-debootstrap:15.04 over debian/ubuntu-debootstrap:14.04.2 for newer packages and less building from src[e.g. libsodium, libgit2 etc].  
Choose rhel7/centos7 if you're really paranoid about the LTS thing, but come on, it's used as a container not a host, which means it's easy to restart it as soon as it goes mad.  

alpinebare: main data volume base image  
alpinebash: main tooling/hub base image  
alpineproc: main application base image  
ubuntubash: auxiliary tooling/hub base image where alpinebash lacks proper packages/envs  
ubuntuproc: auxiliary application base image where alpineproc lacks proper pkgs/envs/guides  

**Java runtime and other musl libc incompatible applications are recommended to use ubuntuproc, 
though there is [a hack for glibc](https://github.com/andyshinn/alpine-pkg-glibc) reliant apps on alpine**  

#### Images Building Tree:  

```
	alpine:3.1 + apk mirror conf  
          --> alpinebare:3.1(latest) + timezone, locale, bash profile settings  
                        --> alpinebash:3.1(latest) + s6 init suite overlay  
                                      --> alpineproc:3.1(latest)  
``` 

```
	ubuntu-debootstrap:14.04.2/15.04 - dpkg selections + apt conf and various workarounds  
          	--> ubuntubare:14.04.2/15.04(latest) + timezone, locale, bash profile settings  
                        --> ubuntubash:14.04.2/15.04(latest) + s6 init suite overlay  
                                     --> ubuntuproc:14.04.2/15.04(latest)  
```

#### Images Sizes:  
alpine:3.1 ~ 5MB, alpinebare:3.1 ~ 11MB, alpinebash:3.1 ~ 17MB, alpineproc:3.1 ~ xMB;  
ubuntu-debootstrap:14.04.2 ~ 87MB, ubuntucore:14.04.2 ~ 56MB, ubuntubare:14.04.2 ~ 85MB, ubuntubash:15.04  ~ 110MB;  
ubuntu-debootstrap:15.04 ~ 110MB, ubuntucore:15.04  ~ 95MB, ubuntubare:15.04  ~ 100MB, ubuntubash:15.04  ~ 125MB;  

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

#### Image Usage:  
Release Image Repo is located at:[mubiic/dockerosebase@github](https://github.com/mubiic/dockerosbase)  
Public Images are avaliable at: [mubiic@dockerhub](https://registry.hub.docker.com/repos/mubiic/)  

Please check Usage.md to see usage details.

#### References:  
[Docker File Best Practices](http://docs.docker.com/articles/dockerfile_best-practices/)  
[Docker Tips and Traps](http://mrbluecoat.blogspot.com/2014/10/docker-traps-and-how-to-avoid-them.html)  

