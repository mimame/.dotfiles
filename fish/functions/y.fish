function y --description "Launch Yazi and sync CWD on exit"
    if not command -q yazi
        echo "Error: 'yazi' is not installed." >&2
        return 1
    end

    # Ensure all plugins/flavors from package.toml are installed
    if command -q ya
        set -l pkg_toml $__fish_config_dir/../yazi/package.toml
        if test -f $pkg_toml
            set -l req (grep -cE '^\s*use\s*=' $pkg_toml)

            # Count actual installed package directories
            set -l inst 0
            if test -d $__fish_config_dir/../yazi/plugins; or test -d $__fish_config_dir/../yazi/flavors
                set inst (find $__fish_config_dir/../yazi/plugins $__fish_config_dir/../yazi/flavors -maxdepth 1 -type d 2>/dev/null | grep -cE '.yazi$')
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
