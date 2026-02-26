function tv_search_files --description "Search files using Television and insert into command line"
    set -l result (tv files | string trim)
    if test -n "$result"
        commandline -i -- "$result"
    end
    commandline -f repaint
end
