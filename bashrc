# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

#  ______________________________________________________________________________
# /                                    Variables                                 \
# \______________________________________________________________________________/

export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

#  ______________________________________________________________________________
# /                                    Commands                                  \
# \______________________________________________________________________________/

# Launch GPG agent
gpgconf --launch gpg-agent
gpg-connect-agent updatestartuptty /bye

# All "read" commands
echo "Welcome, $USER!"
echo "Added keys"
ssh-add -l

#  ______________________________________________________________________________
# /                                    Aliases                                   \
# \______________________________________________________________________________/

# Git aliases
alias gs="git status"
alias ga="git add"
alias gb="git branch"
alias gc="git commit"
alias gd="git diff"
alias go="git checkout"
alias got="git "
alias gti="git "
alias gsu="git submodule"
alias gh="git hist"
alias gf="git fetch"
alias gcl="git clean"
alias gr="git rebase"
alias gst="git stash"

# Other
alias c="clear"
alias ls="ls -alh --color=auto"
alias df="df --total -h"
alias mkdir="mkdir -p"
alias grep="grep --color=auto"
alias pss="ps aux | grep -v grep | grep -i -e VSZ -e"
alias chx="chmod +x"

#  ______________________________________________________________________________
# /                                    Functions                                 \
# \______________________________________________________________________________/

function strlen {
  echo ${#1}
}

function extract {
  if [ -z "$1" ]; then
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
    return 1
  else
    for n in $@
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
            *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar) 
                         tar xvf "$n"       ;;
            *.lzma)      unlzma ./"$n"      ;;
            *.bz2)       bunzip2 ./"$n"     ;;
            *.rar)       unrar x -ad ./"$n" ;;
            *.gz)        gunzip ./"$n"      ;;
            *.zip)       unzip ./"$n"       ;;
            *.z)         uncompress ./"$n"  ;;
            *.7z|*.arj|*.cab|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.rpm|*.udf|*.wim|*.xar)
                         7z x ./"$n"        ;;
            *.xz)        unxz ./"$n"        ;;
            *.exe)       cabextract ./"$n"  ;;
            *)
                         echo "extract: "$n" - unknown archive type"
                         return 1
                         ;;
          esac
      else
          echo ""$n" - file does not exist"
          return 1
      fi
    done
  fi
}

function to_gif() {
  ffmpeg -i "$1" "${1%.*}.gif" && gifsicle -O3 "${1%.*}.gif" -o "${1%.*}.gif"
  if [ "$(uname)" == "Darwin" ] ; then
    osascript -e "display notification \"${1%.*}.gif successfully converted\" with title \"GIF Created Successfully\""
  else
    echo "GIF Created Successfully"
  fi
}


#  ______________________________________________________________________________
# /                                    Defaults                                  \
# \______________________________________________________________________________/

# don"t put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# append to the history file, don"t overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable programmable completion features (you don"t need to enable
# this, if it"s already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac
