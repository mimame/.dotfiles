# Fish shell variables configuration

# --- Core Fish Configuration ---

# Remove Fish default greeting
set -g fish_greeting

# Load Fish hybrid key bindings
set -g fish_key_bindings fish_hybrid_key_bindings

# Reduce escape key time delay to improve responsiveness
# Reference: https://github.com/fish-shell/fish-shell/issues/6590
set -g fish_escape_delay_ms 10

# Configure cursor shape to emulate Vim's behavior
# Reference: https://fishshell.com/docs/current/interactive.html#vi-mode-commands
set -g fish_vi_force_cursor 1
set -g fish_cursor_default block # Normal and visual mode cursor
set -g fish_cursor_insert line # Insert mode cursor
set -g fish_cursor_replace_one underscore # Replace mode cursor
set -g fish_cursor_visual block # Visual mode cursor

# --- Editor Configuration ---

set -gx default_nvim nvim
set -gx EDITOR $default_nvim
set -gx VISUAL $EDITOR
set -gx GIT_EDITOR $EDITOR

# --- Tool Configuration ---

# Set colors for LS and EZA using 'vivid' if available
if command -q vivid
    set -gx LS_COLORS (vivid generate dracula)
    set -gx EZA_COLORS (vivid generate dracula)
end

# Set colors for bat pager
set -gx BAT_THEME Dracula

# Set fd as the default source for fzf
set -gx FZF_DEFAULT_COMMAND 'fd --type file --exclude node_modules'
set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -gx FZF_CTRL_T_OPTS "--height 100% --preview 'bat --color always {}'"
set -gx FZF_ALT_C_COMMAND 'fd --type directory --exclude node_modules'
set -gx FZF_ALT_C_OPTS "--height 100% --preview br --preview-window wrap"

# Set default colors for fzf to match Dracula theme
# Reference: https://github.com/junegunn/fzf/issues/1593#issuecomment-498007983
set -gx FZF_DEFAULT_OPTS '
--reverse
--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9
--color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9
--color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6
--color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4
--bind "tab:down,shift-tab:up,change:top,ctrl-j:toggle+down,ctrl-k:toggle+up,ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:top,ctrl-o:execute($EDITOR {} < /dev/tty > /dev/tty 2>&1)+abort"
'

# Set default web browser to Firefox if available
if command -q firefox
    set -gx BROWSER firefox
end

# Configure system environment variables
set -gx JULIA_NUM_THREADS 8
set -gx TMPDIR /tmp

set -gx RIPGREP_CONFIG_PATH ~/.config/ripgrep/ripgreprc

# bat as the default replacement for cat, less & more commands
set -gx PAGER "bat --wrap auto"

# Use bat as default man pager to avoid rendering ascii issues
set -gx MANPAGER "bat --strip-ansi=auto -l man -p"

# Ensure XDG_CONFIG_HOME is set
if test -z "$XDG_CONFIG_HOME"
    set -gx XDG_CONFIG_HOME "$HOME/.config"
end

# Disable user Python pip by default to avoid conflicts with pre-commit
set -gx PIP_USER false

# --- PATH Configuration ---

fish_add_path \
    "$HOME/.yarn/bin" \
    "$HOME/.bin" \
    "$HOME/go/bin" \
    "$HOME/.cargo/bin" \
    "$HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin" \
    "$HOME/.local/bin" \
    "$HOME/.local/share/coursier/bin" # Coursier install directory

# Add user Ruby gems path if Ruby is installed
if command -q ruby
    fish_add_path "$(ruby -e 'print Gem.user_dir')/bin"
end

# Load Homebrew environment on macOS
if test -f /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv | source
end

# Set GPG_TTY for GPG agent
if test -z "$GPG_TTY"
    set -gx GPG_TTY (tty)
end

# Set input method environment variables
set -gx GTK_IM_MODULE ibus
set -gx QT_IM_MODULE ibus
set -gx XMODIFIERS @im=ibus

# Define time zones for easy access
set -gx TZ_LIST "CET,Central European Time;UTC,Coordinated Universal Time;US/Eastern,Eastern Standard Time;US/Pacific,Pacific Standard Time;Asia/Singapore, Singapore;Mexico/General"

# Define libvirt as the default vagrant provider
set -gx VAGRANT_DEFAULT_PROVIDER libvirt
