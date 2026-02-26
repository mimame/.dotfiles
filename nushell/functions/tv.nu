# Search directories using Television; cd if buffer empty, else insert
export def --env tv_search_dirs [] {
    let selection = (tv dirs | str trim)
    if ($selection | is-not-empty) {
        let buffer = (commandline | str trim)
        if ($buffer | is-empty) {
            cd $selection
        } else {
            commandline edit --insert $selection
        }
    }
}

# Search files using Television and insert into command line
export def tv_search_files [] {
    let selection = (tv files | str trim)
    if ($selection | is-not-empty) {
        commandline edit --insert $selection
    }
}
