function bb --description "Interactively navigate up the directory tree"
    # Ensure television is available
    if not type -q tv
        echo "Error: television is not installed." >&2
        return 1
    end

    # Get the absolute path of the starting directory
    set -l start_path
    if test -n "$argv[1]"
        set start_path (path resolve "$argv[1]")
    else
        set start_path $PWD
    end

    # Build list of parent directories
    set -l dirs
    set -l current $start_path

    # Add start path first
    set -a dirs $current

    # Traverse up using 'path dirname'
    while test "$current" != /
        set current (path dirname "$current")
        set -a dirs $current
    end

    # Determine preview command
    set -l preview_cmd "ls -la --color=always"
    if type -q eza
        set preview_cmd "eza --all --color=always --sort .name --classify --git --icons"
    end

    # Use television to select a directory
    # Use variable capture for cleaner logic; television writes UI to stderr
    set -l final_dir (string join \n -- $dirs | tv --preview-command "$preview_cmd {}")

    # Change to the selected directory
    if test -n "$final_dir" -a -d "$final_dir"
        cd "$final_dir"
    end
end
