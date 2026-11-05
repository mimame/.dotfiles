# 1. CORE VARIABLES & ENVIRONMENT
# Sourced first to ensure environment variables are available to both
# interactive and non-interactive shells.
source $__fish_config_dir/variables.fish

# Ensure UTF-8 locale (macOS sshd doesn't set LANG, breaking tmux nerd fonts)
set -q LANG; or set -gx LANG en_US.UTF-8

# SSH Agent
# Initialized early to ensure keys are available for both interactive
# (e.g., manual git commands) and non-interactive (e.g., pre-commit hooks,
# automated tasks) shells.
setup_ssh_agent

# Interactive sessions only
status is-interactive; or exit

# 2. BOOTSTRAP & RESOURCES (Lazy Loaded)
if not test -f $__fish_config_dir/functions/fisher.fish
    bootstrap_fisher
end

set -l resource_stamp $__fish_config_dir/cache/resources_checked.stamp
if not test -f $resource_stamp
    download_shell_assets $resource_stamp
end

# Television channel prototypes: refresh weekly in the background so startup
# is never blocked by the download. Channels land in ~/.config/television/cable
# (not Dotter-managed — only config.toml is symlinked).
if command -q tv
    set -l tv_channels_stamp $__fish_config_dir/cache/tv_channels.stamp
    # Capture into a variable first: an empty (find ...) substitution expands
    # to zero arguments, which would make `test -n (find ...)` always true.
    set -l tv_channels_stale (find $tv_channels_stamp -mtime +6 2>/dev/null)
    if not test -f $tv_channels_stamp
        or test -n "$tv_channels_stale"
        tv update-channels >/dev/null 2>&1 &
        disown
        touch $tv_channels_stamp
    end
end

# 3. SHELL INTEGRATIONS
if command -q direnv
    source_transient direnv "direnv hook fish" $__fish_config_dir/config.fish
end

# Tools (Cached for speed)
source_transient starship "starship init fish" $__fish_config_dir/config.fish
source_transient zoxide "zoxide init fish" $__fish_config_dir/config.fish
source_transient pay-respects "pay-respects fish --alias fk" $__fish_config_dir/config.fish
source_transient atuin "atuin init fish" $__fish_config_dir/config.fish
source_transient navi "navi widget fish" $__fish_config_dir/config.fish
# Strip tv's Ctrl+R binding line (tv_shell_history) before caching — Atuin
# owns Ctrl+R. The function itself is kept; only the `bind` is filtered out.
source_transient television "tv init fish | string match -rv -- 'bind.*ctrl-r'" $__fish_config_dir/config.fish

# Second layer: even if a future tv changes the binding syntax and the filter
# above misses it, Atuin re-claims Ctrl+R after all init scripts are sourced.
if type -q _atuin_search
    bind \cr _atuin_search
    bind -M insert \cr _atuin_search
end

# Completions (Generated lazily if missing)
if command -q gh
    install_completion gh "gh completion --shell fish"
end
if command -q jj
    install_completion jj "jj util completion fish"
end

# 4. PLATFORM SPECIFIC
source $__fish_config_dir/platform.fish

# 5. TMUX AUTO-START (not inside other multiplexers; Rex already provides
# its own sessions/panes and marks every terminal with REX_SESSION)
if command -q tmux; and not set -q TMUX; and not set -q ZELLIJ; and not set -q REX_SESSION
    tmux new-session
end

# 6. BACKGROUND SERVICES (Login shells only)
if status is-login; and command -q pueued; and not pgrep -x pueued >/dev/null
    pueued --daemonize >/dev/null
end

# 7. ALIASES & ABBREVIATIONS
# Cached to avoid re-parsing abbr.fish on every new shell.
# Uses --no-config to isolate cache generation from interactive plugins, so we
# must manually inject the binary paths (Homebrew / NixOS) into PATH before
# sourcing abbr.fish to ensure tools like eza, bat, etc., are detected correctly.
source_transient abbrs "fish --no-config -c 'set -p fish_function_path $__fish_config_dir/functions; test -x /opt/homebrew/bin/brew; and eval (/opt/homebrew/bin/brew shellenv); test -d /run/current-system/sw/bin; and set -gx PATH /run/current-system/sw/bin $HOME/.nix-profile/bin $PATH; source $__fish_config_dir/variables.fish; source $__fish_config_dir/abbr.fish; abbr --show; alias'" $__fish_config_dir/abbr.fish
