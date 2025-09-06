#######################################################
# ZSH Basic Options
#######################################################

setopt autocd              # change directory just by typing its name
setopt correct             # auto correct mistakes
setopt interactivecomments # allow comments in interactive mode
setopt magicequalsubst     # enable filename expansion for arguments of the form ‘anything=expression’
setopt nonomatch           # hide error message if there is no match for the pattern
setopt notify              # report the status of background jobs immediately
setopt numericglobsort     # sort filenames numerically when it makes sense
setopt promptsubst         # enable command substitution in prompt

#######################################################
# Aliases
#######################################################

alias cls='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias mkdir='mkdir -p'
alias h='history | grep'
alias p='ps aux | grep'

alias rbt='sudo shutdown -r now'
alias pwo='sudo shutdown -h now'
alias logout='hyprctl dispatch exit'
alias lockscr='hyprlock & disown'

alias mx='chmod a+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

alias gs='git status'
alias gd='git diff -w'

# Editor
if command -v nvim &>/dev/null; then
  export EDITOR='nvim'
  export VISUAL='nvim'
  alias nv='nvim'
  alias snv='sudo nvim'
elif command -v vim &>/dev/null; then
  export EDITOR='vim'
  export VISUAL='vim'
  alias vi='vim'
  alias svi='sudo vim'
fi

# Grep alternative
if command -v rg &>/dev/null; then
  alias grep='rg --color=always'
else
  alias grep='/usr/bin/grep --color=always'
fi

# Find alternative
if command -v fd &>/dev/null; then
  alias f='fd --color=always'
else
  alias f='find . | grep'
fi

# rm alternative
if command -v trash &>/dev/null; then
  alias rm='trash'
fi

# ls alternative
if command -v lsd &>/dev/null; then
  alias ls='lsd -aF --color=always --group-dirs first'
  alias ll='lsd --all --color=always --header --long --group-dirs first'
  alias tree='lsd --tree --color=always'
else
  alias ls='ls --color=always'
fi

# cat alternative
if command -v bat &>/dev/null; then
  alias cat='bat'
fi

# git alternative
if command -v lazygit &>/dev/null; then
  alias lg='lazygit'
fi

# fastfetch on startup
if command -v fastfetch &>/dev/null; then
    fastfetch
fi

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

#######################################################
# History Configuration
#######################################################

HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

#######################################################
# Load Prompts and tools
#######################################################

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
source <(fzf --zsh)

export FZF_DEFAULT_OPTS="
  --style full
  --bind 'result:transform-list-label:if [[ -z \$FZF_QUERY ]]; then echo \" \$FZF_MATCH_COUNT items \"; else echo \" \$FZF_MATCH_COUNT matches for [\$FZF_QUERY] \"; fi'
  --color 'preview-border:#9999cc,preview-label:#ccccff'
  --color 'list-border:#669966,list-label:#99cc99'
  --color 'input-border:#996666'
"

export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview '$HOME/fzf-preview.sh {}'
  --bind 'focus:transform-preview-label:[[ -n {} ]] && printf \" Previewing [%s] \" {}'
"

export FZF_CTRL_R_OPTS="
  --reverse
"

# cd alternative and auto ls on directory change
if command -v __zoxide_z &>/dev/null; then
  cd() {
     __zoxide_z "$@" && ls
  }
  z() {
     __zoxide_z "$@" && ls
  }
else
  cd() {
    builtin cd "$@" && ls
  }
fi

#######################################################
# Keybinds
#######################################################

bindkey '\e[1;5D' backward-word
bindkey '\e[1;5C' forward-word

#######################################################
# ZSH plugin
#######################################################

autoload -U compinit; compinit

source $HOME/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.config/zsh/fzf-tab/fzf-tab.plugin.zsh
source $HOME/.config/zsh/zsh-syntax-highlight-tokyonight.zsh

export LS_COLORS='no=00:fi=00:di=00;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:*.xml=00;31:ow=01;36:tw=01;33:st=01;34'

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false

# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no

# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'

# custom fzf flags
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept

# To make fzf-tab follow FZF_DEFAULT_OPTS.
zstyle ':fzf-tab:*' use-fzf-default-opts yes

# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'

# disable case-sentitive for tab auto-completions
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
