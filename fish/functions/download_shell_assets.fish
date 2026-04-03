function download_shell_assets --argument stamp_file
    # Internal helper to download a single file
    function __check_and_download --argument url path
        if not test -f $path
            echo "⬇️  Downloading asset: $path"
            mkdir -p (dirname $path)
            if functions -q get
                get $url $path
            else
                curl -fsSL $url -o $path
            end
        end
    end

    # 1. VSCode Font for Broot
    __check_and_download 'https://github.com/Canop/broot/blob/master/resources/icons/vscode/vscode.ttf?raw=true' ~/.local/share/fonts/vscode.ttf

    # 2. BTOP Theme
    __check_and_download 'https://raw.githubusercontent.com/dracula/bashtop/refs/heads/master/dracula.theme' $__fish_config_dir/../btop/themes/dracula

    # 3. Kitty Theme (Only if kitty is the terminal)
    if test "$TERM" = xterm-kitty; and not test -f $__fish_config_dir/../kitty/current-theme.conf
        if command -q kitty
            kitty +kitten themes --reload-in=all Dracula
        end
    end

    # 4. Yazi Theme
    if not test -d ~/.local/state/yazi/packages/
        if command -q ya
            ya pkg upgrade
        end
    end

    # 5. Ghostty macOS Link
    # Ghostty on macOS expects its config in Library/Application Support.
    # Link it to $XDG_CONFIG_HOME/ghostty to maintain a unified XDG-style setup.
    if test (uname -s) = Darwin
        set -l ghostty_mac "$HOME/Library/Application Support/com.mitchellh.ghostty"
        set -l ghostty_xdg "$XDG_CONFIG_HOME/ghostty"
        if test -d "$ghostty_xdg"
            mkdir -p (dirname "$ghostty_mac")
            ln -sf "$ghostty_xdg" "$ghostty_mac"
            echo "🔗 Linked Ghostty config to Library/Application Support"
        end
    end

    # Create stamp to avoid re-checking every time
    if test -n "$stamp_file"
        mkdir -p (dirname $stamp_file)
        touch $stamp_file
    end

    # Cleanup internal helper
    functions -e __check_and_download
end
