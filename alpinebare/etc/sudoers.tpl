## sudoers file.
##
## This file MUST be edited with the 'visudo' command as root.
## Failure to use 'visudo' may result in syntax or file permission errors
## that prevent sudo from running.
##
## See the sudoers man page for the details on how to write a sudoers file.
##

##
## Host alias specification
##
## Groups of machines. These may include host names (optionally with wildcards),
## IP addresses, network numbers or netgroups.
# Host_Alias    WEBSERVERS = www1, www2, www3

##
## User alias specification
##
## Groups of users.  These may consist of user names, uids, Unix groups,
## or netgroups.
# User_Alias    ADMINS = millert, dowdy, mikef

##
## Cmnd alias specification
##
## Groups of commands.  Often used to group related commands together.
# Cmnd_Alias    PROCESSES = /usr/bin/nice, /bin/kill, /usr/bin/renice, \
#               /usr/bin/pkill, /usr/bin/top
# Cmnd_Alias    REBOOT = /sbin/halt, /sbin/reboot, /sbin/poweroff

##
## Defaults specification
##
Defaults env_reset

## You may wish to keep some of the following environment variables
## when running commands via sudo.
##
## Locale settings
Defaults env_keep += "LANG LANGUAGE LINGUAS LC_* _XKB_CHARSET"

##
## Run X applications through sudo; HOME is used to find the
## .Xauthority file.  Note that other programs use HOME to find
## configuration files and this may lead to privilege escalation!
Defaults env_keep += "HOME"

##
## X11 resource path settings
# Defaults env_keep += "XAPPLRESDIR XFILESEARCHPATH XUSERFILESEARCHPATH"
##
## Desktop path settings
# Defaults env_keep += "QTDIR KDEDIR"
##
## Allow sudo-run commands to inherit the callers' ConsoleKit session
# Defaults env_keep += "XDG_SESSION_COOKIE"
##
## Uncomment to enable special input methods.  Care should be taken as
## this may allow users to subvert the command being run via sudo.
# Defaults env_keep += "XMODIFIERS GTK_IM_MODULE QT_IM_MODULE QT_IM_SWITCHER"
##
## Uncomment to enable logging of a command's output, except for
## sudoreplay and reboot.  Use sudoreplay to play back logged sessions.
Defaults log_output
Defaults!/usr/bin/sudoreplay !log_output
Defaults!/usr/local/bin/sudoreplay !log_output
Defaults!REBOOT !log_output

##
## Runas alias specification
##

##
## User privilege specification
##
Defaults secure_path="/opt/sbin:/opt/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
Cmnd_Alias ROOTSU=/usr/bin/su "",/usr/bin/su -,/bin/su "",/bin/su -
Cmnd_Alias SHELLS=/bin/sh,/bin/csh,/bin/tcsh,/usr/local/bin/tcsh,/bin/bash,/usr/local/bin/bash,/bin/zsh,/usr/local/bin/zsh,/bin/ksh,/usr/local/bin/ksh

root   ALL=(ALL)  ALL

## Uncomment to allow members of group wheel to execute any command
%wheel ALL=(ALL)  ALL

## Same thing without a password
%wheel ALL=(ALL)  NOPASSWD:ALL

## Uncomment to allow members of group sudo to execute any command
%sudo  ALL=(ALL)  ALL

## Same thing without a password
%sudo  ALL=(ALL)  NOPASSWD:ALL

## Allows people in group docker to run all commands
%docker  ALL=(ALL)      ALL

## Same thing without a password
%docker  ALL=(ALL)      NOPASSWD:ALL

## Allows people in group admin to run all commands
%admin  ALL=(ALL)       ALL

## Same thing WITH a password
%admin  ALL=(ALL)       PASSWD:ALL

## Allows people in group sudoer to run all commands
%sudoer  ALL=(ALL)      ALL

## Same thing WITH a password
%sudoer  ALL=(ALL)      PASSWD:ALL

## Uncomment to allow any user to run sudo if they know the password
## of the user they are running the command as (root by default).
# Defaults targetpw  # Ask for the password of the target user
# ALL ALL=(ALL) ALL  # WARNING: only use this together with 'Defaults targetpw'

## Read drop-in files from /etc/sudoers.d
## (the '#' here does not indicate a comment)
#includedir /etc/sudoers.d
