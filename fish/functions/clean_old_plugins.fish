function clean_old_plugins
    # Remove old plugin directories and state to ensure a truly fresh install
    # This prevents conflicts from previous failed or partial installations.
    rm -rf $__fish_config_dir/functions/fisher.fish
    rm -rf $__fish_config_dir/conf.d/fisher.fish
    rm -rf $__fish_config_dir/fish_plugins

    # Clear the transient cache to prevent sourcing corrupted/error-filled caches
    rm -rf $__fish_config_dir/cache

    # Explicitly remove fzf leftovers if they exist
    find $__fish_config_dir -name "*fzf*" -delete

    # Also clean up any lingering Fisher-managed configurations
    that might be broken
    # but keep the user's own configurations.
    if test -d $__fish_config_dir/conf.d
        find $__fish_config_dir/conf.d -name "*.fish" -exec grep -l "managed by fisher" {} + | xargs rm -f
    end
end
