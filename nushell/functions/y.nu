# Launch Yazi and sync CWD on exit
def --env y [...args] {
    if (which yazi | is-empty) {
        error make {msg: "Error: 'yazi' is not installed."}
    }

    # Ensure all plugins/flavors from package.toml are installed
    if (which ya | is-not-empty) {
        let pkg_toml = ($nu.default-config-dir | path join ".." "yazi" "package.toml")
        if ($pkg_toml | path exists) {
            let req = (open --raw $pkg_toml | lines | where $it =~ '^\s*use\s*=' | length)

            # Count actual installed package directories
            let plugins_dir = ($nu.default-config-dir | path join ".." "yazi" "plugins")
            let flavors_dir = ($nu.default-config-dir | path join ".." "yazi" "flavors")

            let installed_plugins = if ($plugins_dir | path exists) {
                (ls $plugins_dir | where type == dir | where name =~ '\.yazi$' | length)
            } else { 0 }

            let installed_flavors = if ($flavors_dir | path exists) {
                (ls $flavors_dir | where type == dir | where name =~ '\.yazi$' | length)
            } else { 0 }

            let inst = ($installed_plugins + $installed_flavors)

            if $req != $inst {
                print $"⚙️  Synchronizing Yazi packages ($inst)/($req)..."
                ya pkg install
            }
        }
    }

    let tmp = (mktemp -t "yazi-cwd.XXXXXX")
    run-external yazi ...$args $"--cwd-file=($tmp)"
    if ($tmp | path exists) {
        let last_cwd = (open $tmp | str trim)
        if ($last_cwd | is-not-empty) and ($last_cwd != $env.PWD) {
            cd $last_cwd
        }
        rm -f $tmp
    }
}
