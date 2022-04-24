function bb
    function get_parent_dirs
        set current_path
        if test -z "$argv"
            set current_path "$PWD"
        else
            set current_path "$argv"
        end
        set current_path (realpath $current_path)
        set dirs
        while test "$current_path" != /
            # next folder ignoring the first one
            set current_path (dirname "$current_path")
            if test -d "$current_path"
                set -a dirs $current_path
            end
        end
        printf "%s\n" $dirs
    end
    set final_dir (get_parent_dirs "$argv"  | nl -v 1 | fzf | cut -f2)
    cd "$final_dir"
end
