# Interactive sessions only
status is-interactive; or exit

# 1. CORE VARIABLES & ENVIRONMENT
source ~/.config/fish/variables.fish

# 2. BOOTSTRAP & RESOURCES (Lazy Loaded)
if not test -f ~/.config/fish/functions/fisher.fish
    bootstrap_fisher
end

set -l resource_stamp ~/.config/fish/cache/resources_checked.stamp
if not test -f $resource_stamp
    download_shell_assets $resource_stamp
end

# 3. SHELL INTEGRATIONS
if command -q direnv
    source_transient direnv "direnv hook fish" ~/.config/fish/config.fish
end

# SSH Agent (only if not already provided by desktop environment)
if not set -q SSH_AUTH_SOCK
    setup_ssh_agent
end

# Tools (Cached for speed)
source_transient starship "starship init fish" ~/.config/fish/config.fish
source_transient zoxide "zoxide init fish" ~/.config/fish/config.fish
source_transient pay-respects "pay-respects fish --alias fk" ~/.config/fish/config.fish
source_transient atuin "atuin init fish" ~/.config/fish/config.fish
source_transient navi "navi widget fish" ~/.config/fish/config.fish

# Completions (Generated lazily if missing)
if command -q gh
    install_completion gh "gh completion --shell fish"
end
if command -q jj
    install_completion jj "jj util completion fish"
end

# 4. PLATFORM SPECIFIC
switch (uname)
    case Linux
        if test -f /etc/NixOS-release
            source_transient any-nix-shell "any-nix-shell fish --info-right" ~/.config/fish/config.fish
        end
end

# 5. BACKGROUND SERVICES (Login shells only)
if status is-login; and command -q pueued; and not pgrep -x pueued >/dev/null
    pueued --daemonize >/dev/null
end

# 6. ALIASES & ABBREVIATIONS
# Cached to avoid re-parsing abbr.fish on every new shell
source_transient abbrs 'fish -c "source ~/.config/fish/abbr.fish; abbr --show"' ~/.config/fish/abbr.fish
