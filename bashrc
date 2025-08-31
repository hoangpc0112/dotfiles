#!/usr/bin/env bash

# Detect if shell is interactive
iatest=$(expr index "$-" i)

#######################################################
# PRE-INIT (only run in interactive shells)
#######################################################
if [[ $- == *i* ]]; then
  if command -v fastfetch &>/dev/null; then
    fastfetch
  fi
  # Bell off
  bind "set bell-style off"
  bind "set completion-ignore-case on"
  bind "set show-all-if-ambiguous On"
  stty -ixon
fi

# Source system-wide settings
[[ -f /etc/bashrc ]] && . /etc/bashrc

# Enable programmable completion
if [[ -f /usr/share/bash-completion/bash_completion ]]; then
  . /usr/share/bash-completion/bash_completion
elif [[ -f /etc/bash_completion ]]; then
  . /etc/bash_completion
fi

#######################################################
# EXPORTS & ENVIRONMENT SETTINGS
#######################################################

# History configuration
export HISTFILESIZE=10000
export HISTSIZE=500
export HISTTIMEFORMAT="%F %T"
export HISTCONTROL=erasedups:ignoredups:ignorespace
shopt -s checkwinsize
shopt -s histappend
PROMPT_COMMAND='history -a'

# XDG Base Directory
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# Colored man pages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# Colored ls and grep
export CLICOLOR=1
export LS_COLORS='no=00:fi=00:di=00;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:*.xml=00;31:ow=01;36:tw=01;33:st=01;34'

#######################################################
# ALIASES
#######################################################

# Basic
alias cls='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias mkdir='mkdir -p'
alias ls='ls -aFh --color=always'
alias h='history | grep'
alias p='ps aux | grep'
alias f='find . | grep'

# Reboot/power
alias rbt='sudo shutdown -r now'
alias fbt='sudo shutdown -r -n now'
alias pwo='sudo shutdown -h now'
alias logout='hyprctl dispatch exit'
alias lockscr="hyprlock &"

# Logs
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"

# Dev tools
alias web='cd /var/www/html'
alias hlp='less ~/.bashrc_help'
alias mx='chmod a+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'
alias brc='nvim ~/.bashrc'

if command -v nvim &>/dev/null; then
  export EDITOR=nvim
  export VISUAL=nvim
  alias nv='nvim'
  alias snv='sudo nvim'
else
  export EDITOR=vim
  export VISUAL=vim
fi

if command -v rg &>/dev/null; then
  alias grep='rg --color=always'
else
  alias grep='/usr/bin/grep --color=always'
fi

if command -v fd &>/dev/null; then alias f='fd --color=always'; fi
if command -v trash &>/dev/null; then alias rm='trash'; fi

#######################################################
# FUNCTIONS
#######################################################

# Extract archives
extract() {
  for archive in "$@"; do
    if [ -f "$archive" ]; then
      case "$archive" in
      # Tarball with various compressions
      *.tar.bz2 | *.tbz2) tar xvjf "$archive" ;;
      *.tar.gz | *.tgz) tar xvzf "$archive" ;;
      *.tar.xz | *.txz) tar xvJf "$archive" ;;
      *.tar.zst | *.tzst) tar --zstd -xvf "$archive" ;; # Requires tar 1.30+
      *.tar) tar xvf "$archive" ;;

      # Standalone compressed files
      *.bz2) bunzip2 "$archive" ;;
      *.gz) gunzip "$archive" ;;
      *.xz) unxz "$archive" ;;
      *.zst) unzstd "$archive" ;;
      *.Z) uncompress "$archive" ;;

      # Other formats
      *.zip) unzip "$archive" ;;
      *.rar) unrar x "$archive" ;;
      *.7z) 7z x "$archive" ;;
      *.deb) ar x "$archive" ;;

      *) echo "don't know how to extract '$archive'..." ;;
      esac
    else
      echo "'$archive' is not a valid file!"
    fi
  done
}

# Show IP address
ipme() {
  echo -n "Internal IP: "
  if command -v ip &>/dev/null; then
    ip addr show wlan0 | grep "inet " | awk '{print $2}' | cut -d/ -f1
  else
    ifconfig wlan0 | grep "inet " | awk '{print $2}'
  fi

  echo -n "External IP: "
  curl -s ifconfig.me
}

# Git helper
alias gs='git status'
alias gd='git diff -w'
if command -v lazygit &>/dev/null; then alias lg='lazygit'; fi

gpa() {
  git add .
  git commit -m "$1"
  git push origin "$2"
}

#######################################################
# SHELL ENHANCEMENTS
#######################################################

eval "$(starship init bash)"
eval "$(zoxide init bash)"
eval "$(fzf --bash)"

export FZF_CTRL_T_OPTS="--walker-skip .git,node_modules,target --preview 'bat -n --color=always {}' --bind 'ctrl-/:change-preview-window(down|hidden|)' --style full --input-label ' Input ' --header-label ' File Type ' --preview '$HOME/.config/fzf/fzf-preview.sh {}' --bind 'result:transform-list-label:if [[ -z \$FZF_QUERY ]]; then echo \" \$FZF_MATCH_COUNT items \"; else echo \" \$FZF_MATCH_COUNT matches for [\$FZF_QUERY] \"; fi' --bind 'focus:transform-preview-label:[[ -n {} ]] && printf \" Previewing [%s] \" {}' --bind 'focus:+transform-header:file --brief {} || echo \"No file selected\"' --color 'preview-border:#9999cc,preview-label:#ccccff' --color 'list-border:#669966,list-label:#99cc99' --color 'input-border:#996666,input-label:#ffcccc' --color 'header-border:#6699cc,header-label:#99ccff'"
export FZF_CTRL_R_OPTS="--layout reverse"
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'tree -C {}'"

# Auto-ls on directory change
cd() {
  builtin cd "$@" && ls
}

z() {
  __zoxide_z "$@" && ls
}
