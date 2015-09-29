#
# .zshrc is sourced in interactive shells.
# It should contain commands to set up aliases,
# functions, options, key bindings, etc.
#

# source profile like .bashrc
if [ -f /etc/profile ]; then
  source /etc/profile
fi

# Options
setopt bg_nice
setopt inc_append_history     # append continuously, not just on exit
setopt hist_expire_dups_first # remove duplicates first
setopt hist_reduce_blanks     # delete excess wht spc in cmds before storing
setopt hist_ignore_space      # don't store cmds that begin with a space
setopt hist_ignore_dups       # ignore duplicates in history
setopt hist_find_no_dups      # don't show history I've seen before
setopt hist_no_store          # don't store history cmds
setopt hist_no_functions      # don't store functions
setopt hist_allow_clobber     # let historic cmds clobber on redirect
setopt extended_history       # saves time and execution time
setopt extended_glob          # allow negative globbing
setopt share_history					# share history!

setopt correct                # auto correction
setopt interactivecomments

setopt auto_cd                # automatically cd to directies
setopt auto_pushd             # the directory stack ROCKS!
setopt pushd_silent           # don't give me the `dirs` list
setopt pushd_ignore_dups

typeset -r HISTFILE=~/.zsh_history
typeset -r HISTSIZE=50000
typeset -r SAVEHIST=50000
LISTMAX=0
LOGCHECK=10
MAILCHECK=
REPORTTIME=5
WATCH=all
WATCHFMT='%w %t: %n %a %l from %M'

LOGTERM="$TERM"
export TERM="$TERM"  # old zsh doesn't load termcap/terminfo until this happens

# Prompts
autoload -Uz promptinit
promptinit
# prompt adam1

function setup_prompt {
  typeset -gH reset="$(echotc me)"
  typeset -gH bold="$(echotc md)"
  typeset -gH underline="$(echotc us)"
  typeset -gH black="$(echotc AF 0)"
  typeset -gH red="$(echotc AF 1)"
  typeset -gH green="$(echotc AF 2)"
  typeset -gH yellow="$(echotc AF 3)"
  typeset -gH blue="$(echotc AF 4)"
  typeset -gH magenta="$(echotc AF 5)"
  typeset -gH cyan="$(echotc AF 6)"
  typeset -gH white="$(echotc AF 7)"
  typeset -gH reverse="$(echotc mr)"
  # set screen hardstatus, or xterm icon name and window title
  function hardstatus { print -n "\e]0;" && print -Rn "$@" && print -n "\a" }
  # set screen window title
  function windowname { [[ -n "$WINDOW" ]] && print -n "\ek" && print -Rn "$@" && print -n "\e\\" }

  function precmd {
    print -Rn "$reset$bold$red"
    jobs
    hardstatus "$(print -Pn "${WINDOW:-_} %2m:%~ %%")"
    windowname "$(print -Pn "%2~%#")"
  }
  function preexec {
    print -n "$reset"
    local cmd="$1"
    if [[ "$cmd[(w)1]" == "fg" ]]; then
      cmd="$cmd %%"
      jobs "$cmd[(w)2]" 2> /dev/null | read cmd cmd cmd cmd
    fi
    cmd="$(print -Rn " $cmd" | tr -cs '[:print:]' ' ')"
    hardstatus "$(print -Pn "${WINDOW:-_} [%m:%~]")""$cmd"
    windowname "$(print -Pn "%2~:")""$cmd"
  }

  local -h host
  host="%2m"
  typeset -gH PS1="%{$reset$bold%}[%{$green%}%n%{$white%}@%{$cyan%}%2m%{$white%}:%{$yellow%}%~%{$reset$bold%}]%# "
  #%{$reset$reverse%}"

#  typeset -gH PROMPT prompt
#  typeset -gH POSTEDIT="$reset"
}

setup_prompt


# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
#cache-path must exist
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Keybindings
autoload edit-command-line
zle -N edit-command-line

bindkey -e
bindkey '\ee' edit-command-line

# ADT
export PATH=${PATH}:${ANDROID_SDK_HOME}/tools:${ANDROID_SDK_HOME}/platform-tools

# User specific aliases and functions go here (override system defaults)
PATH=${PATH}:${HOME}/bin
alias ls='ls --color=auto --classify'
alias less='less -r'            # handle 'color always'
PAGER='less -r'

alias rm='rm -i'
alias mv='mv -i'

alias l='ls'
alias la='ls -a'
alias ll='ls -lh'
alias lla='ls -lha'
alias lll='ls -lhda'

alias df='df -lh'
alias po='popd'

alias vi='vim'
alias psp='ps -o user,pcpu,rss,command'
alias grep='grep -s --exclude-from=$HOME/.grep-filter --color=auto'
alias rdiff='diff --exclude=CVS -r'
alias gdb='gdb -silent'

alias curl='noglob curl'
alias s='screen -U'
alias dirs='dirs -p'
alias find='noglob find'
alias vared='IFS="
" vared'
[ -x =pkill ] || alias pkill='killall'

export LANG=en_US.UTF-8

# Fix up some colors...
LS_COLORS="ow=01;96:di=01;96"
export LS_COLORS
