### mubiic/alpine*, ubuntu* images usage:
#### Check image meta  
docker run --rm -it mubiic/alpinebare  
docker run --rm -it mubiic/alpineproc 'cat /etc/kube-imagemeta'  

#### Add new/Del old packages  
Alpine  
```
	RUN apk update && apk add --update pkg1 pkg2 ... pkgn && \
		apk del tzdata && apk-cleanup
```
Ubuntu  
```
	RUN apt-get-min update && apt-install-min pkg1 pkg2 ... pkgn && \
		apt-remove-min pkgx && apt-cleanup-min

```
#### Mount Ad-hoc binaries
docker run --rm -it mubiic/alpinebash -v $(pwd)/gosu_amd64:/opt/shbin/gosu ""

### Proc image s6 init manager usage  
s6init working dir:  
/var/run/s6  

s6init config dir by applying order[inside scripts applying order is according to naming sort,
 so 00-servicename0, 01-servicename1, 0N-servicenameN are the proper script names]:  
/etc/fix-attrs.d      holds scripts to ensure files owners and permissions are correct 	
/etc/cont-init.d      holds one-time system scripts to execute container init before all  
/etc/services.d       holds user services for long-lived daemon processes to be supervised:  
/etc/services.d/*/run   		hold service daemons running management scripts
/etc/services.d/*/finish 		hold service daemons exit clean up scripts
/etc/services.d/*/log/run 		hold service daemons running logging scripts
/etc/services.d/*/log/finish 	hold service daemons exit logging scripts
/etc/cont-finish.d    holds one-time system scripts to clean up container env before exit  

