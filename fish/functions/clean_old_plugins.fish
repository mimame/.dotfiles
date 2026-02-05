function clean_old_plugins
    # Remove old plugin directories and state to ensure a truly fresh install
    # This prevents conflicts from previous failed or partial installations.
    rm -rf ~/.config/fish/functions/fisher.fish
    rm -rf ~/.config/fish/conf.d/fisher.fish
    rm -rf ~/.config/fish/fish_plugins

    # Clear the transient cache to prevent sourcing corrupted/error-filled caches
    rm -rf ~/.config/fish/cache

    # Also clean up any lingering Fisher-managed configurations that might be broken
    # but keep the user's own configurations.
    if test -d ~/.config/fish/conf.d
        find ~/.config/fish/conf.d -name "*.fish" -exec grep -l "managed by fisher" {} + | xargs rm -f
    end
end
