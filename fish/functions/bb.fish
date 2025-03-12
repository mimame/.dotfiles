function bb --description "Interactively navigate up the directory tree"
    # Get the absolute path of the starting directory
    set start_path (realpath (test -n "$argv"; and echo "$argv"; or echo "$PWD"))

    # Create a list of parent directories
    set -l dirs
    set current_path $start_path

    # Add current directory first if not explicitly provided a path
    if test -z "$argv"
        set -a dirs $current_path
    end

    # Traverse up the directory tree until the root is reached
    while test "$current_path" != /
        # Move to the parent directory
        set current_path (dirname "$current_path")

        # Add the directory to the list if it exists
        if test -d "$current_path"
            set -a dirs $current_path
        end
    end

    # Use fzf to select a directory with preview
    # set final_dir (printf "%s\n" $dirs | fzf)
    set final_dir (printf "%s\n" $dirs |
        fzf --reverse --prompt="Navigate up: " \
            --preview="eza --sort .name --color=always --links --git --icons --classify --extended {}" \
            --header="Select a parent directory")

    # Change to the selected directory if one was chosen
    if test -n "$final_dir" -a -d "$final_dir"
        cd "$final_dir"
    end
end
