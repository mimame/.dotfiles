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
        if test -n "$dependency"; and test "$dependency" -nt "$cache_file"
            set should_rebuild true
        end

        # 3. Check if the binary itself is newer than the cache (handles tool updates)
        if test "$should_rebuild" = false
            # Extract the first word (binary name) from the command
            set -l binary (string split " " $cmd)[1]
            if command -q $binary
                set -l bin_path (command -v $binary)
                if test "$bin_path" -nt "$cache_file"
                    set should_rebuild true
                end
            end
        end
    end

    if test "$should_rebuild" = true
        mkdir -p (dirname $cache_file)
        # Use a temporary file to check for output presence without losing newlines
        set -l tmp_file $cache_file.tmp
        if eval $cmd >$tmp_file
            if test -s $tmp_file
                mv $tmp_file $cache_file
            else
                rm -f $tmp_file
                eval $cmd
                return
            end
        else
            rm -f $tmp_file
            eval $cmd
            return
        end
    end
    source $cache_file
end
