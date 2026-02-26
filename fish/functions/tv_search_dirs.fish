function tv_search_dirs --description "Search directories using Television; cd if buffer empty, else insert"
    set -l result (tv dirs | string trim)
    if test -n "$result"
        if test -z (commandline -b | string trim)
            cd "$result"
        else
            commandline -i -- "$result"
        end
    end
    commandline -f repaint
end
