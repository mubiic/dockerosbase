## Defaults specification
## Disable "ssh hostname sudo <cmd>", because it will show the password in clear.
## You have to run "ssh -t hostname sudo <cmd>".
##Defaults requiretty

## Refuse to run if unable to disable echo on the tty. This setting should also be
## changed in order to be able to use sudo without a tty. See requiretty above.
##Defaults !visiblepw

## Preserving HOME has security implications since many programs use it when
## searching for configuration files. Note that HOME is already set when the
## the env_reset option is enabled, so this option is only effective for
## configurations where either env_reset is disabled or HOME is present in
## the env_keep list.
##Defaults always_set_home

Defaults env_reset
Defaults env_keep = "COLORS DISPLAY HOSTNAME HISTSIZE INPUTRC KDEDIR LS_COLORS"
Defaults env_keep += "MAIL PS1 PS2 QTDIR USERNAME LANG LC_ADDRESS LC_CTYPE"
Defaults env_keep += "LC_COLLATE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES"
Defaults env_keep += "LC_MONETARY LC_NAME LC_NUMERIC LC_PAPER LC_TELEPHONE"
Defaults env_keep += "LC_TIME LC_ALL LANGUAGE LINGUAS _XKB_CHARSET XAUTHORITY"

## Adding HOME to env_keep may enable a user to run unrestricted commands via sudo.
Defaults env_keep += "HOME"

Defaults secure_path="/opt/sbin:/opt/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

Cmnd_Alias ROOTSU=/usr/bin/su "",/usr/bin/su -,/bin/su "",/bin/su -
Cmnd_Alias SHELLS=/bin/sh,/bin/csh,/bin/tcsh,/usr/local/bin/tcsh,/bin/bash,/usr/local/bin/bash,/bin/zsh,/usr/local/bin/zsh,/bin/ksh,/usr/local/bin/ksh

## Allow users to run any commands anywhere
root    ALL=(ALL)       ALL

## Allows people in group wheel to run all commands
%wheel  ALL=(ALL)       ALL

## Same thing without a password
%wheel  ALL=(ALL)       NOPASSWD:ALL

## Allows people in group admin to run all commands
%admin  ALL=(ALL)       ALL

## Same thing WITH a password
%admin  ALL=(ALL)       PASSWD:ALL

## Allows people in group sudo to run all commands
%sudo  ALL=(ALL)      ALL

## Same thing without a password
%sudo  ALL=(ALL)      NOPASSWD:ALL

## Allows people in group sudoer to run all commands
%sudoer  ALL=(ALL)      ALL

## Same thing WITH a password
%sudoer  ALL=(ALL)      PASSWD:ALL

## Allows people in group docker to run all commands
%docker  ALL=(ALL)      ALL

## Same thing without a password
%docker  ALL=(ALL)      NOPASSWD:ALL

## Read drop-in files from /etc/sudoers.d (the # here does not mean a comment)
#includedir /etc/sudoers.d
