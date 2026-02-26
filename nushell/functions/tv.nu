# Search directories using Television and cd into them
export def --env tv-cd [] {
    let selection = (tv dirs | str trim)
    if ($selection | is-not-empty) and ($selection | path exists) {
        cd $selection
    }
}

# Search files using Television and return the selection
export def tv-find [] {
    tv files | str trim
}
