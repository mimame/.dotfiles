function clean_old_plugins --description "Clean up old Fisher plugin artifacts"
    # Remove specific plugin function files
    rm -rf \
        $__fish_config_dir/functions/__abbr* \
        $__fish_config_dir/functions/_autopair* \
        $__fish_config_dir/functions/_fzf_*.fish \
        $__fish_config_dir/functions/replay.fish \
        $__fish_config_dir/functions/__bass.py \
        $__fish_config_dir/functions/bass.fish \
        $__fish_config_dir/functions/fisher.fish \
        $__fish_config_dir/functions/fzf_configure_bindings.fish \
        $__fish_config_dir/functions/fzf.fish \
        $__fish_config_dir/themes/*.theme \
        $__fish_config_dir/conf.d/fisher.fish \
        $__fish_config_dir/fish_plugins

    # Clear transient cache to prevent sourcing stale or error-filled caches
    rm -rf $__fish_config_dir/cache

    # Remove fzf leftovers
    fd --type f --glob '*fzf*' "$__fish_config_dir" | xargs rm -f

    # Remove Fisher-managed conf.d files, preserving user configs
    if test -d $__fish_config_dir/conf.d
        fd --type f --extension fish "$__fish_config_dir/conf.d" | rg -l "managed by fisher" | xargs rm -f
    end
end
