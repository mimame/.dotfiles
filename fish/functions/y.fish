function y --description "Launch Yazi and sync CWD on exit"
    if not command -q yazi
        echo "Error: 'yazi' is not installed." >&2
        return 1
    end

    # Ensure all plugins/flavors from package.toml are installed
    if command -q ya
        set -l pkg_toml $__fish_config_dir/../yazi/package.toml
        if test -f $pkg_toml
            set -l req (rg --count -I '^\s*use\s*=' $pkg_toml 2>/dev/null; or echo 0)

            # Count actual installed package directories
            set -l inst 0
            set -l yazi_cfg (path normalize "$__fish_config_dir/../yazi")
            if test -d "$yazi_cfg"
                set -l pkg_dirs (fd --max-depth 1 --type d --glob '*.yazi' "$yazi_cfg/plugins" "$yazi_cfg/flavors" 2>/dev/null)
                set inst (count $pkg_dirs)
            end

            if test "$req" -ne "$inst"
                echo "⚙️  Synchronizing Yazi packages ($inst/$req)..."
                ya pkg install
            end
        end
    end

    set -l tmp (mktemp -t "yazi-cwd.XXXXXX")

    # Launch yazi with the cwd-file option
    yazi $argv --cwd-file="$tmp"

    # If the tmp file exists and is non-empty, read it
    if test -f "$tmp"
        set -l last_cwd (string collect <"$tmp")
        if test -n "$last_cwd"; and test "$last_cwd" != "$PWD"
            builtin cd -- "$last_cwd"
        end
        command rm -f -- "$tmp"
    end
end
