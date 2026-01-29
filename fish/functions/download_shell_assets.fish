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
    __check_and_download 'https://raw.githubusercontent.com/dracula/bashtop/refs/heads/master/dracula.theme' ~/.config/btop/themes/dracula

    # 3. Kitty Theme (Only if kitty is the terminal)
    if test "$TERM" = xterm-kitty; and not test -f ~/.config/kitty/current-theme.conf
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

    # Create stamp to avoid re-checking every time
    if test -n "$stamp_file"
        mkdir -p (dirname $stamp_file)
        touch $stamp_file
    end

    # Cleanup internal helper
    functions -e __check_and_download
end
