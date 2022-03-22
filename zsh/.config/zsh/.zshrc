# vim: foldmethod=marker
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
  plugins+=('Aloxaf/fzf-tab')
  plugins+=('zsh-users/zsh-completions')
  plugins+=('zsh-users/zsh-autosuggestions')
  plugins+=('marzocchi/zsh-notify')
  plugins+=('kutsan/zsh-system-clipboard')
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
unsetopt HIST_VERIFY          # Whenever the user enters a line with history expansion, execute the line directly
# }}}

# Completion config {{{
# Load compinit
# The following lines were added by compinstall {{{
zstyle :compinstall filename "$HOME/.config/zsh/.zshrc"
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
zstyle ':completion:*' format '[%d]'
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
export LS_COLORS="$(vivid generate molokai)"
export EXA_COLORS="$(vivid generate molokai)"
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
zstyle ':notify:*' enable-on-ssh no
zstyle ':notify:*' error-log /dev/null

# Folder options {{{
# https://github.com/sorin-ionescu/prezto/blob/master/modules/directory/init.zsh
setopt AUTO_CD           # Auto changes to a directory without typing cd.
unsetopt AUTO_PUSHD        # Don't auto push the old directory onto the stack on cd.
unsetopt PUSHD_IGNORE_DUPS # Store duplicates in the stack. Fix popd: directory stack empty when pushing same directory
setopt PUSHD_SILENT      # Do not print the directory stack after pushd or popd.
setopt PUSHD_TO_HOME     # Push to home directory when no argument is given.
setopt CDABLE_VARS       # Change directory to a path stored in a variable.
setopt MULTIOS           # Write to multiple descriptors.
setopt EXTENDED_GLOB     # Use extended globbing syntax.
setopt globdots          # GLOBDOTS lets files beginning with a . be matched without explicitly specifying the dot


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


# Vi mode keys {{{
# https://dougblack.io/words/zsh-vi-mode.html
# Enable vi mode
bindkey -v
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
bindkey -M vicmd 'v' edit-command-line
# }}}

# Cursor shape {{{
# https://github.com/softmoth/zsh-vim-mode/blob/master/zsh-vim-mode.plugin.zsh#L600
# Use steady beam shape cursor by default on startup
echo -ne '\e[6 q'
# Use beam shape cursor for each new prompt
preexec() {
   echo -ne '\e[6 q'
}
# Use steady block cursor in normal mode
# https://unix.stackexchange.com/questions/547/make-my-zsh-prompt-show-mode-in-vi-mode
zle-keymap-select () {
  case $KEYMAP in
    vicmd) print -n "\e[0 q";; # steady block cursor
    viins|main) print -n "\e[6 q";; # steady beam cursor
  esac
}
zle -N zle-keymap-select
# }}}

# FZF config {{{
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
# Ctrl-R provided by fzf
# Setting fd as the default source for fzf
export FZF_DEFAULT_COMMAND='fd --type f --exclude node_modules'
# To apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--height 100% --preview 'bat --color always {}'"
# To apply the command to ALT_C
export FZF_ALT_C_COMMAND='fd --type d --exclude node_modules'
export FZF_ALT_C_OPTS="--height 100% --preview 'exa --sort .name --tree --classify --git --long --color=always --ignore-glob=node_modules {}' --preview-window wrap"
# Molokai colors by default
# https://github.com/junegunn/fzf/issues/1593#issuecomment-498007983
export FZF_DEFAULT_OPTS='
--reverse
--color fg:255,bg:16,hl:161,fg+:255,bg+:16,hl+:161,info:118
--color border:244,prompt:161,pointer:118,marker:161,spinner:229,header:59
--bind "tab:down,shift-tab:up,change:top,ctrl-j:toggle+down,ctrl-k:toggle+up,ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:top,ctrl-o:execute(nvim {} < /dev/tty > /dev/tty 2>&1)+abort"
'
# CTRL-R - Paste the selected command from history into the command line {{{
fzf-history-widget() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail 2> /dev/null
  selected=( $(fc -rl 1 | nl --starting-line-number 1 --number-separator " |" |
    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n1..,.. --tiebreak=index --bind=ctrl-r:toggle-sort $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m" $(__fzfcmd)) )
  local ret=$?
  if [ -n "$selected" ]; then
    # Remove the index | prefix from the history number and command
    # Remove first N character with cut -cN- instead using sed
    num=$(echo $selected | cut -d'|' -f2 | cut -c1-)
    if [ -n "$num" ]; then
      zle vi-fetch-history -n $num
    fi
  fi
  zle reset-prompt
  return $ret
}
zle     -N   fzf-history-widget
bindkey '^R' fzf-history-widget


# disable sort when completing options of any command
zstyle ':completion:complete:*:options' sort false
# use input as query string when completing zlua
zstyle ':fzf-tab:complete:_zlua:*' query-string input
zstyle ":completion:*:git-checkout:*" sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --ignore-glob=node_modules --color=always $realpath'
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'
# Accept the result and start another completion immediately
zstyle ':fzf-tab:*' continuous-trigger 'space'
# Press this key will use current user input as the final completion result
zstyle ':fzf-tab:*' accept-line enter

# }}}
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


# source alias
source ~/.config/zsh/zsh_alias
# source functions
source ~/.config/zsh/zsh_functions

# Improve broot command
# Always use br function to call it
source "$HOME/.config/broot/launcher/bash/br"
alias broot=\br

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
font_hash['Hack Nerd Font Complete.ttf']="https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Hack/Regular/complete/Hack%20Regular%20Nerd%20Font%20Complete.ttf?raw=true"
# Bold font
font_hash['Hack Bold Nerd Font Complete.ttf']="https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Hack/Bold/complete/Hack%20Bold%20Nerd%20Font%20Complete.ttf?raw=true"
# Italic font
font_hash['Hack Italic Nerd Font Complete.ttf']="https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Hack/Italic/complete/Hack%20Italic%20Nerd%20Font%20Complete.ttf?raw=true"
# Emoji font
font_hash['Noto Color Emoji.ttf']="https://github.com/googlefonts/noto-emoji/blob/master/fonts/NotoColorEmoji.ttf?raw=true"

for font in "${(@k)font_hash}"; do

[[ ! -f ~/.local/share/fonts/"${font}" ]] \
  && mkdir -p ~/.local/share/fonts \
  && pushd ~/.local/share/fonts \
  && curl -fLo "${font}" "$font_hash[$font]" \
  && popd

done
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
# https://unix.stackexchange.com/a/602494
typeset -g ZSH_SYSTEM_CLIPBOARD_TMUX_SUPPORT='true'
typeset -g ZSH_SYSTEM_CLIPBOARD_SELECTION='PRIMARY'
# }}}

# Start ssh agent by default
if [ -z "$SSH_AUTH_SOCK" ] ; then
  eval `ssh-agent -s` > /dev/null
fi

# Run new tmux session always {{{
# Remove weird message: sessions should be nested with care, unset $TMUX to force
if [ "$TMUX" == "" ]; then
    tmux new-session
fi
# }}}

eval "$(starship init zsh)"
# zprof
