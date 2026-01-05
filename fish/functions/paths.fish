function paths --description "Display PATH entries with existence check and numbering"
    set -l reverse true
    if contains -- -f $argv; or contains -- --forward $argv
        set reverse false
    end

    set -l entries $PATH
    set -l total (count $entries)
    set -l indices (seq 1 $total)

    if test "$reverse" = true
        set indices (seq $total -1 1)
    end

    for i in $indices
        set -l entry $entries[$i]
        if test -d "$entry"
            set_color green
            printf "%3d  ✓  %s\n" $i "$entry"
        else
            set_color red
            printf "%3d  ✗  %s\n" $i "$entry"
        end
    end
    set_color normal
end
