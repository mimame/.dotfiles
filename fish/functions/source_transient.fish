# Helper to cache transient init scripts (improves startup time)
# Usage: source_transient <name> <command> [dependency_file]
function source_transient --argument name cmd dependency
    set -l cache_file ~/.config/fish/cache/$name.fish
    set -l should_rebuild false

    if not test -f $cache_file
        set should_rebuild true
    else if test -n "$dependency"; and test "$dependency" -nt "$cache_file"
        # Rebuild if the dependency file is newer than the cache
        set should_rebuild true
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
