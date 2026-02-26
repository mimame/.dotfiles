function tv_find_file --description "Search files using Television and insert into command line"
    set -l temp_file (mktemp)
    tv files >$temp_file

    if test -s $temp_file
        set -l result (cat $temp_file)
        if test -e "$result"
            commandline -i -- "$result"
        end
    end

    rm -f $temp_file
    commandline -f repaint
end
