function bb
    # Function to get all parent directories of a given path
    function get_parent_dirs
        # Determine the starting path
        set current_path (realpath (test -z "$argv"; and echo "$PWD"; or echo "$argv"))

        # Initialize an empty list for directories
        set -l dirs

        # Traverse up the directory tree until the root is reached
        while test "$current_path" != /
            # Move to the parent directory
            set current_path (dirname "$current_path")

            # Add the directory to the list if it exists
            if test -d "$current_path"
                set -a dirs $current_path
            end
        end

        # Print the list of directories, each on a new line
        printf "%s\n" $dirs
    end

    # Use get_parent_dirs to list directories and navigate to the selected one
    set final_dir (get_parent_dirs "$argv" | nl -v 1 | fzf | cut -f2)

    # Change to the selected directory
    cd "$final_dir"
end
