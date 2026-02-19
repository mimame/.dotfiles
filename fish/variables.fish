# Fish shell variables configuration

# --- PATH Configuration ---
# Must be defined first to ensure Homebrew (on macOS) and local binaries
# are available for the rest of the configuration checks.
# We build and cache the path additions once.
source_transient paths '
    set -l paths \
        "$HOME/.yarn/bin" \
        "$HOME/.bin" \
        "$HOME/go/bin" \
        "$HOME/.cargo/bin" \
        "$HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin" \
        "$HOME/.local/bin" \
        "$HOME/.local/share/coursier/bin"

    if type -q ruby
        set -a paths (ruby -e "print Gem.user_dir")/bin
        set -a paths (ruby -e "print Gem.bindir")
    end

    # Detect Homebrew location
    set -l brew_bin (path filter -f /opt/homebrew/bin/brew /usr/local/bin/brew | head -n1)

    if test -n "$brew_bin"
        set -l brew_prefix ($brew_bin --prefix)
        # Add primary Homebrew paths
        set -a paths $brew_prefix/bin $brew_prefix/sbin

        # Add language-specific Homebrew paths if they exist
        for lang in ruby python
            if test -d $brew_prefix/opt/$lang/bin
                set -a paths $brew_prefix/opt/$lang/bin
            end
        end
    end

    for p in $paths
        if test -d $p
            echo "fish_add_path -m $p"
        end
    end
' $__fish_config_dir/variables.fish

# --- Platform Identification ---

set -gx IS_DARWIN false
set -gx IS_LINUX false
set -gx IS_NIXOS false

if test (uname -s) = Darwin
    set -gx IS_DARWIN true
else if test -e /etc/os-release
    set -gx IS_LINUX true
    if grep -q '^ID=nixos' /etc/os-release
        set -gx IS_NIXOS true
        # On NixOS, use the standard systemd-managed SSH agent socket.
        # Exporting this globally ensures all sub-processes (Git, etc.) find the agent.
        set -gx SSH_AUTH_SOCK /run/user/(id -u)/ssh-agent
    end
end

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

# --- Theme Configuration (Dracula Official) ---

# Syntax Highlighting Colors
set -g fish_color_autosuggestion 6272a4
set -g fish_color_cancel ff5555 --reverse
set -g fish_color_command 8be9fd
set -g fish_color_comment 6272a4
set -g fish_color_cwd 50fa7b
set -g fish_color_cwd_root red
set -g fish_color_end ffb86c
set -g fish_color_error ff5555
set -g fish_color_escape ff79c6
set -g fish_color_history_current --bold
set -g fish_color_host bd93f9
set -g fish_color_host_remote bd93f9
set -g fish_color_keyword ff79c6
set -g fish_color_normal f8f8f2
set -g fish_color_operator 50fa7b
set -g fish_color_option ffb86c
set -g fish_color_param bd93f9
set -g fish_color_quote f1fa8c
set -g fish_color_redirection f8f8f2
set -g fish_color_search_match --background=44475a
set -g fish_color_selection --background=44475a
set -g fish_color_status ff5555
set -g fish_color_user 8be9fd
set -g fish_color_valid_path --underline

# Pager Colors
set -g fish_pager_color_background
set -g fish_pager_color_completion f8f8f2
set -g fish_pager_color_description 6272a4
set -g fish_pager_color_prefix 8be9fd
set -g fish_pager_color_progress 6272a4
set -g fish_pager_color_secondary_background
set -g fish_pager_color_secondary_completion f8f8f2
set -g fish_pager_color_secondary_description 6272a4
set -g fish_pager_color_secondary_prefix 8be9fd
set -g fish_pager_color_selected_background --background=44475a
set -g fish_pager_color_selected_completion f8f8f2
set -g fish_pager_color_selected_description 6272a4
set -g fish_pager_color_selected_prefix 8be9fd

# --- Tool Configuration ---

# Set colors for LS and EZA using 'vivid' if available
if type -q vivid
    source_transient vivid 'echo "set -gx LS_COLORS (vivid generate dracula)"' $__fish_config_dir/variables.fish
    set -gx EZA_COLORS $LS_COLORS
end

# Set colors for bat pager
set -gx BAT_THEME Dracula

# Set fd as the default source for fzf
set -gx FZF_DEFAULT_COMMAND 'fd --type file --exclude node_modules'
set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -gx FZF_CTRL_T_OPTS "--height 100% --preview 'bat --color always {}'"
set -gx FZF_ALT_C_COMMAND 'fd --type directory --exclude node_modules'
set -gx FZF_ALT_C_OPTS "--height 100% --preview br --preview-window wrap"

# Custom directory preview command for fzf (used by fzf.fish)
# Shows colorized, classified directory listings with hidden files but excludes node_modules
set -gx fzf_preview_dir_cmd eza --all --color=always --sort .name --classify --color=always --ignore-glob=node_modules

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

# Set GPG_TTY for GPG agent
if test -z "$GPG_TTY"
    if status is-interactive
        set -gx GPG_TTY (tty)
    end
end

# Set input method environment variables
set -gx GTK_IM_MODULE ibus
set -gx QT_IM_MODULE ibus
set -gx XMODIFIERS @im=ibus

# Define time zones for easy access
set -gx TZ_LIST "CET,Central European Time;UTC,Coordinated Universal Time;US/Eastern,Eastern Standard Time;US/Pacific,Pacific Standard Time;Asia/Singapore, Singapore;Mexico/General"

# Define libvirt as the default vagrant provider
set -gx VAGRANT_DEFAULT_PROVIDER libvirt
