status is-interactive; or exit

# =============================================================================
# Helper Functions
# =============================================================================

# Helper to cache transient init scripts (improves startup time)
# Usage: _source_transient <name> <command>
function _source_transient --argument name cmd
    set -l cache_file ~/.config/fish/cache/$name.fish
    if not test -f $cache_file
        mkdir -p (dirname $cache_file)
        set -l output (eval $cmd)
        if test -n "$output"
            echo "$output" >$cache_file
        else
            # If command failed or returned nothing, don't create an empty file
            # but source the eval directly so the shell still works
            eval $cmd
            return
        end
    end
    source $cache_file
end

# Helper to install completions lazily
# Usage: _install_completion <command_name> <generation_command>
function _install_completion --argument name cmd
    set -l comp_file ~/.config/fish/completions/$name.fish
    if not test -f $comp_file
        echo "⚙️  Generating completion for $name..."
        eval $cmd >$comp_file
    end
end

# =============================================================================
# Core Configuration
# =============================================================================

# Source variables early so they are available for other configs
source ~/.config/fish/variables.fish

# Initialize direnv (Environment variable manager)
# https://direnv.net/
if command -q direnv
    _source_transient direnv "direnv hook fish"
end

# =============================================================================
# Bootstrap & Auto-Configuration
# =============================================================================
# Automatically install Fisher (plugin manager) and dependencies if missing.

if not test -f ~/.config/fish/functions/fisher.fish
    echo "⚡ Bootstrapping Fish shell environment..."

    # Helper to clean up old plugin artifacts before fresh install
    function _clean_old_plugins
        rm -rf ~/.config/fish/functions/__abbr* \
            ~/.config/fish/functions/_autopair* \
            ~/.config/fish/functions/_fzf_*.fish \
            ~/.config/fish/functions/replay.fish \
            ~/.config/fish/functions/__bass.py \
            ~/.config/fish/functions/bass.fish \
            ~/.config/fish/themes/*.theme \
            ~/.config/fish/completions \
            ~/.config/fish/conf.d \
            ~/.config/fish/functions/fisher.fish \
            ~/.config/fish/functions/fzf_configure_bindings.fish \
            ~/.config/fish/functions/fzf.fish
    end

    _clean_old_plugins

    # Install Fisher
    get 'https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish' | source && fisher install jorgebucaran/fisher

    # Install Plugins
    fisher install \
        franciscolourenco/done \
        gazorby/fish-abbreviation-tips \
        jorgebucaran/autopair.fish \
        jorgebucaran/replay.fish \
        edc/bass \
        dracula/fish \
        PatrickF1/fzf.fish

    # Set Theme
    yes | fish_config theme choose 'Dracula Official'
    yes | fish_config theme save 'Dracula Official'
end

# =============================================================================
# Resource & Theme Management (Optimized)
# =============================================================================
# We use a stamp file to only perform heavy checks once per day/session
# or when a resource is clearly missing.

set -l resource_stamp ~/.config/fish/cache/resources_checked.stamp
if not test -f $resource_stamp
    # VSCode Font for Broot
    if not test -f ~/.local/share/fonts/vscode.ttf
        echo "⬇️  Downloading resource: vscode.ttf"
        get 'https://github.com/Canop/broot/blob/master/resources/icons/vscode/vscode.ttf?raw=true' ~/.local/share/fonts/vscode.ttf
        fc-cache ~/.local/share/fonts/
    end

    # BTOP Theme
    if not test -f ~/.config/btop/themes/dracula
        _ensure_resource 'https://raw.githubusercontent.com/dracula/bashtop/refs/heads/master/dracula.theme' ~/.config/btop/themes/dracula
    end

    # Rofi Theme
    if not test -f ~/.config/rofi/dracula.rasi
        _ensure_resource 'https://raw.githubusercontent.com/dracula/rofi/refs/heads/main/theme/config1.rasi' ~/.config/rofi/dracula.rasi
    end

    # Kitty Theme (Only if kitty is the terminal)
    if test "$TERM" = xterm-kitty; and not test -f ~/.config/kitty/current-theme.conf
        kitty +kitten themes --reload-in=all Dracula
    end

    # Yazi Theme
    if not test -d ~/.local/state/yazi/packages/
        ya pkg upgrade
    end

    touch $resource_stamp
end

# =============================================================================
# Shell Integrations & Tools
# =============================================================================

# Start SSH Agent only if needed
if test -z "$SSH_AUTH_SOCK"
    set -l ssh_keys
    for key in id_ed25519 id_ed25519_passphrase
        if test -f $HOME/.ssh/$key
            set -a ssh_keys $HOME/.ssh/$key
        end
    end

    if test -n "$ssh_keys"
        keychain --eval --quiet $ssh_keys | source
    end
end

# Create a directory for SSH control sockets if it doesn't exist
test -d ~/.ssh/control_sockets; or mkdir -p ~/.ssh/control_sockets

# Starship Prompt (Cached)
_source_transient starship "starship init fish"

# Zoxide (Cached)
_source_transient zoxide "zoxide init fish"

# Pay-Respects (Cached)
_source_transient pay-respects "pay-respects fish --alias fk"

# GitHub CLI Completion (Lazy Loaded)
if command -q gh
    _install_completion gh "gh completion --shell fish"
end

# Jujutsu (jj) VCS Completion (Lazy Loaded)
if command -q jj
    _install_completion jj "jj util completion fish"
end

# Mise (Runtime manager) - Uncomment if used
# if command -q mise
#     _source_transient mise "mise activate fish"
# end

# =============================================================================
# Platform Specific Configuration
# =============================================================================

switch (uname)
    case Linux
        # NixOS Detection
        if test -f /etc/NixOS-release
            # any-nix-shell: nicer shells for nix-shell/nix develop.
            _source_transient any-nix-shell "any-nix-shell fish --info-right"

            # Fix broken systemd user services (common NixOS issue)
            fix_broken_services_by_nixos
        end
end

# =============================================================================
# Background Services
# =============================================================================

# Start pueued daemon if not running (Only in top-level shells)
if status is-login; and not pgrep -x pueued >/dev/null
    pueued --daemonize >/dev/null
end

# Zellij Auto-Start (Optional, currently disabled)
# if test $TERM != xterm-kitty -a $TERM != xterm-ghostty
#     eval (zellij setup --generate-auto-start fish | string collect)
# end

# =============================================================================
# Aliases & Abbreviations
# =============================================================================
# Loaded last to ensure all tools are in path
source ~/.config/fish/abbr.fish
