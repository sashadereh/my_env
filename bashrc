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

