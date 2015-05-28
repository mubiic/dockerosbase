export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
[ -d "/opt/bin" ] && export PATH="/opt/bin:$PATH"
[ -d "/opt/sbin" ] && export PATH="/opt/sbin:$PATH"

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

export TERM="${TERM:=xterm}"
## Prefer US English and use UTF-8
#export LANG="en_US"
#export LC_ALL="en_US.UTF-8"
# Don't check mail when opening terminal.
unset MAILCHECK

# Append to the Bash history file and Erase duplicates
shopt -s histappend
# Limit the history size to prevent info leakage
export HISTSIZE=18
export HISTFILESIZE=$HISTSIZE
export HISTCONTROL=ignoredups:ignorespace
# Make some commands not show up in history
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help:cls:history"
export AUTOFEATURE=true autotest

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob
# Autocorrect typos in path names when using `cd`
shopt -s cdspell
# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
    shopt -s "$option" 2> /dev/null
done

# Always enable colored ls and grep output
export CLICOLOR="1"
export PS1="\[\033[33m\][\u@\H:\[\033[32m\]\w\[\033[33m\]]$\[\033[0m\]"
if echo "hi" | grep --color=auto i >/dev/null 2>&1; then
    export GREP_OPTIONS="--color=auto"
    export GREP_COLOR="1;33"
fi
export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Define some basic aliaes and functions
unalias -a
# Enable aliases to be sudo’ed
alias sudo='sudo '
alias su='su - '
alias mkdir='mkdir -p'
# Mv all current files and folders one dir up and omit the parent dir
alias what='type -a'
alias unsetall='unset all;set +o nounset'
alias cls='clear;set +o nounset'
alias clr='reset;clear;set +o nounset'
# List all files colorized in long format
alias ll="ls -lph --color --group-directories-first"
alias lt='ll -t'
alias ls="command ls --color --group-directories-first"
alias lu='du -ach --time --max-depth=1'
alias reload=". $HOME/.bash_profile"
alias memclr='free -mh;sync;echo 3 > /proc/sys/vm/drop_caches;free -mh'
alias wget='wget -c'
alias path='echo -e ${PATH//:/\\n}'
alias vex='__vex() { [ $# -eq 1 ] && [ "$1" == "-q" ] && [ -r "bin/activate" ] && deactivate && return 0;[ -r "${!#}/bin/activate" ] && cd "${!#}" && . bin/activate || virtualenv "$@";[ -d "${!#}" ] && cd "${!#}";[ -r "bin/activate" ] && . bin/activate; unset -f __vex; }; __vex'


# Beautify the bash prompt
[ -r "$HOME/.bash_prompt" ] && . "$HOME/.bash_prompt"

# If possible, add tab completion for many more commands
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

###############################################################################################
set +o nounset     # Don't mess up the auto completion
set +o errexit     # Don't mess up the interactive shell
