# Launch Yazi and sync CWD on exit
def y [...args] {
    let tmp = (mktemp -t "yazi-cwd.XXXXXX")
    run-external yazi ...$args $"--cwd-file=($tmp)"
    if ($tmp | path exists) {
        let last_cwd = (open $tmp | str trim)
        if ($last_cwd | is-not-empty) and ($last_cwd != $env.PWD) {
            cd $last_cwd
        }
        rm $tmp
    }
}
