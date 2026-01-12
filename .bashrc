# if not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

export EDITOR=nvim
export VISUAL=nvim
set -o emacs # literally better for shell :D

# don't put duplicate lines or lines starting with space in the history
HISTCONTROL=ignoreboth
HISTFILESIZE=999991
HISTSIZE=99999
HISTFILE=$HOME/.bash_history

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# allows you to see repository status in your prompt
. $HOME/.git-prompt.sh
GIT_PS1_HIDE_IF_PWD_IGNORED=true
GIT_PS1_COMPRESSSPARSESTATE=true
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWUPSTREAM='verbose'

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$(__git_ps1 " _ %s")\n\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w$(__git_ps1 " _ %s")\n\$ '
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [[ -s $HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh ]]; then
    . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
elif ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc
# export SDL_VIDEO_WAYLAND_SCALE_TO_DISPLAY=1
# export SDL_VIDEO_DRIVER=wayland

alias vim=nvim
alias myip='echo $(dig +short txt ch whoami.cloudflare @1.0.0.1)'
