function y --description "Launch Yazi and sync CWD on exit"
    if not command -q yazi
        echo "Error: 'yazi' is not installed." >&2
        return 1
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
