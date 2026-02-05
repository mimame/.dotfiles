# Helper to cache transient init scripts (improves startup time)
# Usage: source_transient <name> <command> [dependency_file]
function source_transient --argument name cmd dependency
    set -l cache_file ~/.config/fish/cache/$name.fish
    set -l should_rebuild false

    # 1. Check if cache exists
    if not test -f $cache_file
        set should_rebuild true
    else
        # 2. Check if the dependency file (e.g., config.fish) is newer than the cache
        # This ensures cache is invalidated if the user manually changes the source configuration.
        if test -n "$dependency"; and test -f "$dependency"; and test "$dependency" -nt "$cache_file"
            set should_rebuild true
        end

        # 3. Check if the binary itself is newer than the cache (handles tool updates)
        if test "$should_rebuild" = false
            # Robust extraction of the binary name from the command.
            # Handles multi-line strings, leading/trailing whitespace, and quoted commands.
            # Example: '  starship init fish' -> 'starship'
            set -l binary (string trim $cmd | string split -f1 " " | string trim -c "'\"")
            if command -q $binary; and not builtin -q $binary
                set -l bin_path (command -v $binary)
                # Compare binary modification time. If the tool was upgraded (e.g., via brew or nix),
                # we must rebuild the cache as the init script might have changed.
                if test -f "$bin_path"; and test "$bin_path" -nt "$cache_file"
                    set should_rebuild true
                end
            end
        end
    end

    if test "$should_rebuild" = true
        mkdir -p (dirname $cache_file)
        # Use a temporary file to check for output presence without losing newlines.
        # This prevents partial/broken cache files if the command is interrupted.
        set -l tmp_file $cache_file.tmp
        if eval $cmd >$tmp_file
            if test -s $tmp_file
                mv $tmp_file $cache_file
            else
                # If command succeeded but produced no output, don't create an empty cache.
                # Source the output directly to ensure the environment is initialized.
                rm -f $tmp_file
                eval $cmd | source
                return
            end
        else
            # On command failure, don't cache. Fallback to direct execution.
            rm -f $tmp_file
            eval $cmd | source
            return
        end
    end

    # 4. Final sourcing of the cache or direct fallback
    if test -f $cache_file
        source $cache_file
    else
        # Fallback for unexpected states or first-run initialization failures
        eval $cmd | source
    end
end
