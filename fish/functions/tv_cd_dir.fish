function tv_cd_dir --description "Search directories using Television and cd into them"
    set -l temp_file (mktemp)
    # Run Television directly on the terminal
    # It will write the selection to the temp file
    tv dirs >$temp_file

    if test -s $temp_file
        set -l result (cat $temp_file)
        if test -d "$result"
            cd "$result"
        end
    end

    rm -f $temp_file
    commandline -f repaint
end
