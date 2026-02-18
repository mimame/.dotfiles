function bb --description "Interactively navigate up the directory tree"
    # Ensure fzf is available
    if not type -q fzf
        echo "Error: fzf is not installed." >&2
        return 1
    end

    # Get the absolute path of the starting directory
    # Use 'path resolve' (Fish builtin) for better performance than 'realpath'
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
    # Use global configuration if available, fallback to eza/ls
    set -l preview_cmd "ls -la --color=always {}"
    if set -q fzf_preview_dir_cmd
        set preview_cmd "$fzf_preview_dir_cmd {}"
    else if type -q eza
        set preview_cmd "eza --all --color=always --sort .name --classify --git --icons {}"
    end

    # Use fzf to select a directory
    set -l final_dir (string join \n -- $dirs | fzf \
        --reverse \
        --prompt="Navigate up: " \
        --header="Select a parent directory" \
        --preview="$preview_cmd" \
        --preview-window="right:50%:wrap")

    # Change to the selected directory
    if test -n "$final_dir" -a -d "$final_dir"
        cd "$final_dir"
    end
end
