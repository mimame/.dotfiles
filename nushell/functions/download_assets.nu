# Download and initialize shell assets (Fonts, Themes, Links)
def --env download_shell_assets [] {
    print "⚡ Checking and downloading shell assets..."

    # Helper to download a single file
    let download_file = {|url, path|
        if not ($path | path exists) {
            print $"⬇️  Downloading asset: ($path)"
            mkdir ($path | path dirname)
            if (which get | is-not-empty) {
                run-external get $url $path
            } else {
                run-external curl -fsSL $url -o $path
            }
        }
    }

    # 1. VSCode Font for Broot
    do $download_file 'https://github.com/Canop/broot/blob/master/resources/icons/vscode/vscode.ttf?raw=true' ($env.XDG_DATA_HOME | path join "fonts" "vscode.ttf")

    # 2. BTOP Theme
    do $download_file 'https://raw.githubusercontent.com/dracula/bashtop/refs/heads/master/dracula.theme' ($env.XDG_CONFIG_HOME | path join "btop" "themes" "dracula")

    # 3. Kitty Theme (Only if kitty is the terminal)
    if ($env.TERM? == "xterm-kitty") and not ($env.XDG_CONFIG_HOME | path join "kitty" "current-theme.conf" | path exists) {
        if (which kitty | is-not-empty) {
            run-external kitty +kitten themes --reload-in=all Dracula
        }
    }

    # 4. Yazi Theme
    if not ($env.XDG_STATE_HOME | path join "yazi" "packages" | path exists) {
        if (which ya | is-not-empty) {
            ya pkg upgrade
        }
    }

    # 5. Ghostty macOS Link
    # Ghostty on macOS expects its config in Library/Application Support.
    # Link it to $XDG_CONFIG_HOME/ghostty to maintain a unified XDG-style setup.
    if ($nu.os-info.name == "macos") {
        let ghostty_mac = ($env.HOME | path join "Library" "Application Support" "com.mitchellh.ghostty")
        let ghostty_xdg = ($env.XDG_CONFIG_HOME | path join "ghostty")
        if ($ghostty_xdg | path exists) {
            mkdir ($ghostty_mac | path dirname)
            run-external ln -sf $ghostty_xdg $ghostty_mac
            print "🔗 Linked Ghostty config to Library/Application Support"
        }
    }

    # Create stamp to avoid re-checking every time
    let stamp_file = ($env.XDG_CACHE_HOME | path join "nushell" "resources_checked.stamp")
    mkdir ($stamp_file | path dirname)
    touch $stamp_file
}
