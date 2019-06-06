# vim: foldmethod=marker foldenable
# Interactive shell also with aliases and functions of a not interactive shell
# Never uncomment this
# source "${ZDOTDIR:-$HOME}/.zshenv"

# http://jb-blog.readthedocs.io/en/latest/posts/0032-debugging-zsh-startup-time.html
# Profile zsh start up (don't forget to uncomment the bottom line of the file!)
# zmodload zsh/zprof

# Check if antibody is installed {{{
# https://getantibody.github.io/install/
if ! [ -x "$(command -v antibody)" ]; then
  curl -sL git.io/antibody | sh -s
  exit 1
fi
# }}}

# Initialize antibody and plugins {{{
# Load antibody (dynamic load)
# https://getantibody.github.io/usage/

if [ -f ~/.zsh_plugins.sh ]; then
  # Static load
  source ~/.zsh_plugins.sh
else
  # Dynamic load
  # Register plugins in an array
  declare -a plugins
  plugins+=('denysdovhan/spaceship-prompt kind:zsh-theme')
  plugins+=('zsh-users/zsh-completions')
  plugins+=('zsh-users/zsh-autosuggestions')
  plugins+=('marzocchi/zsh-notify')
  plugins+=('hlissner/zsh-autopair')
  plugins+=('zsh-users/zsh-syntax-highlighting')
  plugins+=('zsh-users/zsh-history-substring-search')
  # Join array with new lines
  plugins=$(printf "%s\n" "${plugins[@]}")
  # Generate static load using list of plugins on the fly
  antibody bundle <<< $plugins > ~/.zsh_plugins.sh
fi
# }}}

setopt interactivecomments    # Let use comment in interactive mode
unsetopt beep                 # Disable beep by default

# History config {{{
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
setopt BANG_HIST              # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY       # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY     # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY          # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS       # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS   # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS      # Do not display a previously found event.
setopt HIST_IGNORE_SPACE      # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS      # Do not write a duplicate event to the history file.
setopt HIST_VERIFY            # Do not execute immediately upon history expansion
setopt HISTIGNORESPACE        # Do not add the command to the history if it starts with a space
# Lists the ten most used commands.
alias history-stat="history 0 | awk '{print \$2}' | sort | uniq -c | sort -n -r | head"
# }}}

# Completion config {{{
# Load compinit
# The following lines were added by compinstall {{{
zstyle :compinstall filename "$HOME/.zshrc"
autoload -Uz compinit
# http://stackoverflow.com/a/12575883
# On slow systems, checking the cached .zcompdump file to see if it must be
# regenerated adds a noticable delay to zsh startup.  This little hack restricts
# it to once a day.  It should be pasted into your own completion file.
#
# The globbing is a little complicated here:
# - '#q' is an explicit glob qualifier that makes globbing work within zsh's [[ ]] construct.
# - 'N' makes the glob pattern evaluate to nothing when it doesn't match (rather than throw a globbing error)
# - '.' matches "regular files"
# - 'mh+24' matches files (or directories or whatever) that are older than 24 hours.
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit;
else
  compinit -C;
fi;
# End of lines added by compinstall }}}

# http://zsh.sourceforge.net/Guide/zshguide06.html
# http://zsh.sourceforge.net/Doc/Release/Options.html#Completion-2
# https://github.com/sorin-ionescu/prezto/blob/master/modules/completion/init.zsh
# https://github.com/robbyrussell/oh-my-zsh/blob/master/lib/completion.zsh
# https://github.com/getantibody/antibody#in-the-wild
# If a completion is performed with the cursor within a word, and a full completion is inserted,

# https://github.com/sorin-ionescu/prezto/blob/master/modules/completion/init.zsh
# Options {{{
setopt COMPLETE_IN_WORD # Complete from both ends of a word.
setopt ALWAYS_TO_END    # Move cursor to the end of a completed word.
setopt PATH_DIRS        # Perform path search even on command names with slashes.
setopt AUTO_MENU        # Show completion menu on a successive tab press.
setopt AUTO_LIST        # Automatically list choices on ambiguous completion.
setopt AUTO_PARAM_SLASH # If completed parameter is a directory, add a trailing slash.
unsetopt MENU_COMPLETE  # Do not autoselect the first completion entry.
unsetopt FLOW_CONTROL   # Disable start/stop characters in shell editor.
unsetopt nomatch        # git show HEAD^ returns zsh: no matches found: HEAD^
unsetopt CASE_GLOB      # Make globbing (filename generation) not sensitive to case.
unsetopt LIST_BEEP      # Don't beep on an ambiguous completion.
# }}}

# Use caching to make completion for commands such as dpkg and apt usable. {{{
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "${ZDOTDIR:-$HOME}/.zcompcache"
# }}}

# Case-insensitive (all), partial-word, and then substring completion.
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# group matches (files, directories, ...) and descriptions {{{
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group yes
zstyle ':completion:*:options' description yes
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format '%F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format '%F{purple}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'
zstyle ':completion:*' format '%F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
# }}}

# Fuzzy match mistyped completions {{{
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
# Increase the number of errors based on the length of the typed word
# But make sure to cap (at 7) the max-errors to avoid hanging.
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3>7?7:($#PREFIX+$#SUFFIX)/3))numeric)'
# }}}

# Don't complete unavailable commands
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

# Array completion element sorting
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# Directories {{{
# Set LS_COLORS
# export LS_COLORS='di=1;34:ln=35:so=32:pi=33:ex=31:bd=1;36:cd=1;33:su=30;41:sg=30;46:tw=30;42:ow=30;43'
export LS_COLORS="$(vivid generate narnia)"
export EXA_COLORS="$(vivid -m 8-bit generate narnia)"
# Color autocompleted directories
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# First complete local directories, then +NUMBER parent hierarchy and finally directories from $cdpath
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
# Complete parent hierarchy
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'expand'
zstyle ':completion:*' squeeze-slashes true
# }}}

# History (replaced by fzf and zsh-history-substring-search) {{{
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes
# }}}

# Environmental Variables
zstyle ':completion::*:(-command-|export):*' fake-parameters ${${${_comps[(I)-value-*]#*,}%%,*}:#-*-}

# Populate hostname completion {{{
# */etc/hosts* which might be uninteresting.
zstyle -e ':completion:*:hosts' hosts 'reply=(
  ${=${=${=${${(f)"$(cat {/etc/ssh/ssh_known_hosts,~/.ssh/known_hosts}(|2)(N) 2> /dev/null)"}%%[#| ]*}//\]:[0-9]*/ }//,/ }//\[/ }
  ${=${(f)"$(cat /etc/hosts(|)(N) <<(ypcat hosts 2> /dev/null))"}%%(\#${_etc_host_ignores:+|${(j:|:)~_etc_host_ignores}})*}
  ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2> /dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
)'
# }}}

# Don't complete uninteresting users... {{{
zstyle ':completion:*:*:*:users' ignored-patterns \
  adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
  dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
  hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
  mailman mailnull mldonkey mysql nagios \
  named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
  operator pcap postfix postgres privoxy pulse pvm quagga radvd \
  rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs '_*'
# }}}

# ... unless we really want to.
zstyle '*' single-ignored show

# ignore useless commands and functions
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec)|prompt_*)'

# completion sorting
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# Ignore multiple entries {{
zstyle ':completion:*:(rm|kill|diff):*' ignore-line other
zstyle ':completion:*:rm:*' file-patterns '*:all-files'
# }}

# Kill pgrep behaviour (improved by fzf) {{{
zstyle ':completion:*:*:*:*:processes' command 'ps -u $LOGNAME -o pid,user,command -w'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*' force-list always
# Let browse by the kill menu
# zstyle ':completion:*:*:kill:*' insert-ids single
# }}}

# Man {{{
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true
# }}}

# Media Players {{{
zstyle ':completion:*:*:mpg321:*' file-patterns '*.(mp3|MP3):mp3\ files *(-/):directories'
zstyle ':completion:*:*:ogg123:*' file-patterns '*.(ogg|OGG|flac):ogg\ files *(-/):directories'
zstyle ':completion:*:*:mocp:*' file-patterns '*.(wav|WAV|mp3|MP3|ogg|OGG|flac):ogg\ files *(-/):directories'
# }}}

# SSH/SCP/RSYNC {{{
zstyle ':completion:*:(ssh|scp|rsync):*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:(scp|rsync):*' group-order users files all-files hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' group-order users hosts-domain hosts-host users hosts-ipaddr
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-domain' ignored-patterns '<->.<->.<->.<->' '^[-[:alnum:]]##(.[-[:alnum:]]##)##' '*@*'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'
# }}}
# }}}

# Notify long running commands
zstyle ':notify:*' error-title "Command failed (in #{time_elapsed} seconds)"
zstyle ':notify:*' success-title "Command finished (in #{time_elapsed} seconds)"

# Folder options {{{
# https://github.com/sorin-ionescu/prezto/blob/master/modules/directory/init.zsh
setopt AUTO_CD           # Auto changes to a directory without typing cd.
setopt AUTO_PUSHD        # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS # Do not store duplicates in the stack.
setopt PUSHD_SILENT      # Do not print the directory stack after pushd or popd.
setopt PUSHD_TO_HOME     # Push to home directory when no argument is given.
setopt CDABLE_VARS       # Change directory to a path stored in a variable.
setopt MULTIOS           # Write to multiple descriptors.
setopt EXTENDED_GLOB     # Use extended globbing syntax.
setopt globdots          # GLOBDOTS lets files beginning with a . be matched without explicitly specifying the dot

# Show bottom up hierarchy of folders of the stack except the current folder
alias d='dirs -v | tail +2'
# Type a number and enter to go to that position in the folder stack
for index ({1..9}) alias "$index"="cd +${index}"; unset index

# Show folder hierarchy from bottom to root and let jump to any of that folders
# https://github.com/junegunn/fzf/wiki/Examples#changing-directory
b (){
  local declare dirs=()
  get_parent_dirs() {
    if [[ -d "${1}" ]]; then dirs+=("$1"); else return; fi
    if [[ "${1}" == '/' ]]; then
      for _dir in "${dirs[@]}"; do echo $_dir; done
    else
      get_parent_dirs $(dirname "$1")
    fi
  }
  #local DIR=$(get_parent_dirs $(realpath "${1:-$PWD}") | fzf-tmux --tac)
  # I prefer the original order
  # and remove the current folder
  local DIR=$(get_parent_dirs $(realpath "${1:-$PWD}") | tail -n+2 | fzf)
  cd "$DIR"
}
# }}}

# Jobs options {{{

#https://github.com/sorin-ionescu/prezto/blob/master/modules/environment/init.zsh
setopt LONG_LIST_JOBS # List jobs in the long format by default.
setopt AUTO_RESUME    # Attempt to resume existing job before creating a new process.
setopt NOTIFY         # Report status of background jobs immediately.
unsetopt BG_NICE      # Don't run all background jobs at a lower priority.
unsetopt HUP          # Don't kill jobs on shell exit.
#unsetopt CHECK_JOBS  # Don't report on jobs when shell exit
# }}}

# less with color {{{
export LESS_TERMCAP_mb=$'\E[01;31m'    # Begins blinking.
export LESS_TERMCAP_md=$'\E[01;31m'    # Begins bold.
export LESS_TERMCAP_me=$'\E[0m'        # Ends mode.
export LESS_TERMCAP_se=$'\E[0m'        # Ends standout-mode.
export LESS_TERMCAP_so=$'\E[00;47;30m' # Begins standout-mode.
export LESS_TERMCAP_ue=$'\E[0m'        # Ends underline.
export LESS_TERMCAP_us=$'\E[01;32m'    # Begins underline.
# }}}

# Spaceship prompt {{{
export SPACESHIP_NODE_DEFAULT_VERSION="$(node -v)"
export SPACESHIP_JOBS_SYMBOL=''
export SPACESHIP_JOBS_AMOUNT_SUFFIX=' \e[34mjobs\e[0m '
export SPACESHIP_JOBS_AMOUNT_THRESHOLD=0
export SPACESHIP_USER_SHOW='always'
export SPACESHIP_USER_SUFFIX=''
export SPACESHIP_HOST_SHOW='always'
export SPACESHIP_HOST_PREFIX='@'
export SPACESHIP_DIR_TRUNC=0
export SPACESHIP_DIR_TRUNC_REPO=false
export SPACESHIP_TIME_SHOW=true
# User nerd font icons
export SPACESHIP_DOCKER_SYMBOL='  '
export SPACESHIP_RUBY_SYMBOL='  '
export SPACESHIP_GOLANG_SYMBOL=' '

SPACESHIP_PROMPT_ORDER=(
  user          # Username section
  host          # Hostname section
  dir           # Current directory section
  git           # Git section (git_branch + git_status)
  hg            # Mercurial section (hg_branch  + hg_status)
  package       # Package version
  node          # Node.js section
  ruby          # Ruby section
  elixir        # Elixir section
  xcode         # Xcode section
  swift         # Swift section
  golang        # Go section
  php           # PHP section
  rust          # Rust section
  haskell       # Haskell Stack section
  julia         # Julia section
  docker        # Docker section
  aws           # Amazon Web Services section
  venv          # virtualenv section
  conda         # conda virtualenv section
  pyenv         # Pyenv section
  dotnet        # .NET section
  ember         # Ember.js section
  kubecontext   # Kubectl context section
  exec_time     # Execution time
  time          # Time stampts section
  line_sep      # Line break
  battery       # Battery level and status
  vi_mode       # Vi-mode indicator
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)
# }}}

# Vi mode keys {{{
# https://dougblack.io/words/zsh-vi-mode.html
# Enable vi mode
bindkey -v
spaceship_vi_mode_enable
# Delay from 0.4s to 0.1s to enter in vi mode
export KEYTIMEOUT=1
# Normal mode space for execute suggest
# https://wiki.archlinux.org/index.php/Zsh#Key_bindings
bindkey -M vicmd ' ' autosuggest-execute
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
# Allow ctrl-x, ctrl-w for char and word deletion
# bindkey '^h' is forbidden because of vim-tmux-navigator so use '^x' instead
bindkey '^x' backward-delete-char
bindkey '^w' backward-kill-word
# Allow emacs ctrl-a and ctrl-e to move to beginning/end of the line
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
# Allow ctrl-p, ctrl-n to browse the command history
bindkey '^p' up-history
bindkey '^n' down-history
# Char visual mode open the editor
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line
# }}}


# FZF config {{{
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
# Ctrl-R provided by fzf
# Setting fd as the default source for fzf
export FZF_DEFAULT_COMMAND='fd --type f --hidden --no-ignore --follow --exclude .git --exclude node_modules'
# To apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# To apply the command to ALT_C
export FZF_ALT_C_COMMAND='fd --type d --hidden --no-ignore --follow --exclude .git --exclude node_modules'
# Molokai colors by default
export FZF_DEFAULT_OPTS='
--reverse
--color fg:255,bg:0,hl:161,fg+:255,bg+:208,hl+:161,info:118
--color border:244,prompt:161,pointer:118,marker:161,spinner:229,header:59
--bind "ctrl-o:execute(nvim {})+abort"
'
alias p='fzf --preview "bat --color always {}"'
# }}}

# Alias {{{

# Expand aliases automatically {{{
# space expands all aliases, including global
globalias() {
  zle _expand_alias
  zle expand-word
  zle self-insert
}
zle -N globalias
bindkey -M viins " " globalias

# / expands all dot aliases without adding a space after
function expand-dots {
   if [[ $LBUFFER =~ ".*\.\.\.$" ]]; then
	 zle _expand_alias
	 zle expand-word
   fi
   zle self-insert
}
zle -N expand-dots
bindkey -M viins "/" expand-dots

# control-space to make a normal space
bindkey -M viins "^ " magic-space
# normal space during searches
bindkey -M isearch " " magic-space
# }}}

alias paths='echo $PATH | sed "s/:/\n/g"'

alias szsh='source ~/.zshrc'

# Always preserve the environment with sudo
alias sudo='sudo -E'

# Remove $ symbol pasted in front of the command
alias '$'=''

# Improve mobility between folders {{{
alias .='cd ..'
alias ..='cd ../..'
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -- -='cd -'
# }}}

alias md='mkdir --parent --verbose'
alias mkdir='mkdir --parents --verbose'

function mc() {
  mkdir --parent --verbose $1 && cd $1
}

# Improve broot command
# Always use br function to call it
alias broot='broot --hidden --sizes --gitignore no'
source "$HOME/.config/broot/launcher/bash/br"

# global pipe aliases
alias -g B='| bat'
alias -g C='| xclip -selection clipboard'
alias -g G='| grep --ignore-case'
alias -g GE='| grep --extended-regexp'
alias -g GF='| grep --fixed-strings'
alias -g GP='| grep --perl-regexp'
alias -g L='| less'
alias -g V='| nvim -R -'
alias -g W='| wc'

# Always use float by default
alias bc='bc -l'
# github wrapper to extend git
alias git=hub
alias g=git

alias ls='ls --color=always --almost-all --human-readable --format=long'
alias l='ls'
alias ll='exa --all --sort .name --color=always --long --links --group --git'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# rsync
alias rs='rsync --archive --compress --info=progress2 --human-readable --update --delete'

# cb STRING to copy to the clipboard
# cb FILE to copy to the clipboard
# echo string | cb to copy to the clipboard
# cb to paste from the clipboard
# cb | command to paste from the clipboad
function cb () {
  if [[ -p /dev/stdin ]] ; then
    # stdin is a pipe
    # stdin -> clipboard
    xclip -selection clipboard
  elif [[ ! -z "$1" ]]; then
    # stdin is not a pipe
    # file -> clipboard
    if [[ -f "$1" ]]; then
      # stdin is not a pipe
      xclip -selection clipboard "$1"
    else
      echo "$1" | xclip -selection clipboard
    fi
  else
    # stdin -> clipboard
    # stdin is not a pipe
    # clipboard -> stdout
    xclip -selection clipboard -out
  fi
}

# Burn image files to USB
function iso()  {
  sudo umount $2 2> /dev/null
  sudo dd bs=4M if=$1 of=$2 status=progress conv=fdatasync
}

# o function and open function (mimeopen provided by perl-file-mimetype) {{{
# It works better than xdg-open in i3-wm and also it provides a better and nicer terminal interface than their xdg-utils equivalents
function open() {
  # Run mimeopen with nohup in background and remove it from the jobs table
  for file in "$@"
  do
    nohup mimeopen "$file" >| /tmp/nohup-"$(basename $file)".out 2>| /tmp/nohup-"$(basename $file)".err < /dev/null &
    disown %%
  done
}
# If o doesn't have any argument, open the current dir
function o() {
  if [ $# -eq 0 ]; then
    vifm .;
  else
    open "$@";
  fi;
}
# }}}

function python () {
  # Use command to avoid the recursion
  test -z "$1" && ipython || command python "$@"
}

function R () {
  # Use command to avoid the recursion
  test -z "$1" && radian || command R "$@"
}

# Never use vi
alias vi='vim'
alias v='vim'
alias n='nvim'
alias h='history'
alias du='du -h'
alias df='df -h'
alias stmux="tmuxinator"
alias j="jobs -l"
alias ncdu='ncdu --color dark'
alias news='newsboat'
alias fm='vifm'
alias re='massren'
alias tree='tree -a -s -h'
alias T='tail -F'

# rg with grep -r behaviour
alias ag='ag --unrestricted --smart-case --ignore .git'
alias s='rg --smart-case --follow --hidden --no-ignore --no-heading --with-filename --no-ignore-parent --glob '"'"'!node_modules'"'"' --glob '"'"'!.git/*'"'"

# fd with find behaviour
alias f='fd --hidden --no-ignore --follow --exclude .git'

# bat alias
alias bat='bat --theme "Monokai Extended Bright Narnia"'

# Safe ops. Ask the user before doing anything destructive.
# Move rm files to the trash using trash-cli
alias rm='trash --verbose'
alias mv="mv -i"
alias cp="cp -i"
alias ln="ln -i"
unsetopt CLOBBER # Do not overwrite existing files with > and >>. # Use >! and >>! to bypass.

alias youtube-dl-mp3='youtube-dl --extract-audio --audio-format mp3'

# Correct previous command
eval $(thefuck --alias)
alias fk='fuck -y'

# Alias for rc files
alias alacrittyrc='nvim $(readlink -f ~/.config/alacritty/alacritty.yml)'
alias gitrc='nvim $(readlink -f ~/.config/git/config)'
alias i3rc='nvim $(readlink -f ~/.config/i3/config)'
alias mimerc='nvim $(readlink -f ~/.config/mimeapps.list)'
alias newsboatrc='nvim $(readlink -f ~/.config/newsboat/config)'
alias nvimrc='nvim $(readlink -f ~/.config/nvim/init.vim)'
alias sshrc='nvim $(readlink -f ~/.ssh/config)'
alias tigrc='nvim $(readlink -f ~/.config/tig/config)'
alias tmuxrc='nvim $(readlink -f ~/.tmux.conf)'
alias vifmrc='nvim $(readlink -f ~/.config/vifm/vifmrc)'
alias vimrc='nvim $(readlink -f ~/.vimrc)'
alias zshrc='nvim $(readlink -f ~/.zshrc)'

# Alias for yay command
alias yay="yay --sudoloop --noconfirm -Syu"

# https://www.cyberciti.biz/faq/how-to-find-my-public-ip-address-from-command-line-on-a-linux/
alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
# }}}

# Automatic aliases for color output commands with Generic Colouriser
[[ -s "$HOME/.config/grc/grc.zsh" ]] && source "$HOME/.config/grc/grc.zsh"

# ctrl-Z for recovering vim in background {{{
fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}

zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z
# }}}

# Font config {{{
# https://github.com/bhilburn/powerlevel9k/issues/430#issuecomment-287084613
# zsh syntax
typeset -A font_hash
# Regular font
font_hash['InconsolataGo Nerd Font Complete.ttf']="https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/InconsolataGo/Regular/complete/InconsolataGo%20Nerd%20Font%20Complete.ttf?raw=true"
# Bold font
font_hash['InconsolataGo Bold Nerd Font Complete.ttf']="https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/InconsolataGo/Bold/complete/InconsolataGo%20Bold%20Nerd%20Font%20Complete.ttf?raw=true"

for font in "${(@k)font_hash}"; do

[[ ! -f ~/.local/share/fonts/"${font}" ]] \
  && mkdir -p ~/.local/share/fonts \
  && pushd ~/.local/share/fonts \
  && curl -fLo "${font}" "$font_hash[$font]" \
  && popd

done
# }}}


# get command {{{{
# https://github.com/zimfw/zimfw/blob/master/modules/utility/init.zsh
if [ -x "$(command -v "aria2c")" ]; then
  alias get='aria2c --max-connection-per-server=5 --continue'
elif [ -x "$(command -v "axel")" ]; then
  alias get='axel --num-connections=5 --alternate'
elif [ -x "$(command -v "wget")" ]; then
  alias get='wget --continue --progress=bar --timestamping'
elif [ -x "$(command -v "curl")" ]; then
  alias get='curl --continue-at - --location --progress-bar --remote-name --remote-time'
fi
# }}}


#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# Special keys working {{{
# http://zshwiki.org/home/zle/bindkeys#reading_terminfo
# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="$terminfo[khome]"
key[End]="$terminfo[kend]"
key[Insert]="$terminfo[kich1]"
key[Backspace]="$terminfo[kbs]"
key[Delete]="$terminfo[kdch1]"
key[Up]="$terminfo[kcuu1]"
key[Down]="$terminfo[kcud1]"
key[Left]="$terminfo[kcub1]"
key[Right]="$terminfo[kcuf1]"
key[PageUp]="$terminfo[kpp]"
key[PageDown]="$terminfo[knp]"

# setup key accordingly
[[ -n "$key[Home]"      ]] && bindkey -- "$key[Home]"      beginning-of-line
[[ -n "$key[End]"       ]] && bindkey -- "$key[End]"       end-of-line
[[ -n "$key[Insert]"    ]] && bindkey -- "$key[Insert]"    overwrite-mode
# vi bad behaviour (https://unix.stackexchange.com/a/290403)
bindkey -v '^?' backward-delete-char
[[ -n "$key[Backspace]" ]] && bindkey -- "$key[Backspace]" backward-delete-char
[[ -n "$key[Delete]"    ]] && bindkey -- "$key[Delete]"    delete-char
[[ -n "$key[Up]"        ]] && bindkey -- "$key[Up]"        up-line-or-history
[[ -n "$key[Down]"      ]] && bindkey -- "$key[Down]"      down-line-or-history
[[ -n "$key[Left]"      ]] && bindkey -- "$key[Left]"      backward-char
[[ -n "$key[Right]"     ]] && bindkey -- "$key[Right]"     forward-char

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        echoti smkx
    }
    function zle-line-finish () {
        echoti rmkx
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi
# }}}

# Sync ZSH register with the system clipboard {{{
# https://unix.stackexchange.com/a/390523
function x11-clip-wrap-widgets() {
    # NB: Assume we are the first wrapper and that we only wrap native widgets
    # See zsh-autosuggestions.zsh for a more generic and more robust wrapper
    local copy_or_paste=$1
    shift

    for widget in $@; do
        # Ugh, zsh doesn't have closures
        if [[ $copy_or_paste == "copy" ]]; then
            eval "
            function _x11-clip-wrapped-$widget() {
                zle .$widget
                xclip -in -selection clipboard <<<\$CUTBUFFER
            }
            "
        else
            eval "
            function _x11-clip-wrapped-$widget() {
                CUTBUFFER=\$(xclip -out -selection clipboard)
                zle .$widget
            }
            "
        fi

        zle -N $widget _x11-clip-wrapped-$widget
    done
}


local copy_widgets=(
    vi-yank vi-yank-eol vi-delete vi-backward-kill-word vi-change-whole-line
)
local paste_widgets=(
    vi-put-{before,after}
)

# NB: can atm. only wrap native widgets
x11-clip-wrap-widgets copy  $copy_widgets
x11-clip-wrap-widgets paste $paste_widgets
# }}}

# Run new tmux session always {{{
# Remove weird message: sessions should be nested with care, unset $TMUX to force
if [ "$TMUX" == "" ]; then
    tmux new-session
fi
# }}}

# zprof
