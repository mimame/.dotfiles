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
    source_transient direnv "direnv hook fish" $__fish_config_dir/config.fish
end

# SSH Agent
setup_ssh_agent

# Tools (Cached for speed)
source_transient starship "starship init fish" $__fish_config_dir/config.fish
source_transient zoxide "zoxide init fish" $__fish_config_dir/config.fish
source_transient pay-respects "pay-respects fish --alias fk" $__fish_config_dir/config.fish
source_transient atuin "atuin init fish" $__fish_config_dir/config.fish
source_transient navi "navi widget fish" $__fish_config_dir/config.fish

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
        if grep -q '^ID=nixos' /etc/os-release 2>/dev/null
            source_transient any-nix-shell "any-nix-shell fish --info-right" $__fish_config_dir/config.fish
        end
end

# 5. BACKGROUND SERVICES (Login shells only)
if status is-login; and command -q pueued; and not pgrep -x pueued >/dev/null
    pueued --daemonize >/dev/null
end

# 6. ALIASES & ABBREVIATIONS
# Cached to avoid re-parsing abbr.fish on every new shell
# We use --no-config to isolate cache generation from plugins that might fail
# in non-interactive shells (e.g., fish-abbreviation-tips).
source_transient abbrs "fish --no-config -c 'set -p fish_function_path $__fish_config_dir/functions; source $__fish_config_dir/variables.fish; source $__fish_config_dir/abbr.fish; abbr --show; alias'" $__fish_config_dir/abbr.fish
