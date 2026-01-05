function mc --description "Create directory and enter it"
    if test (count $argv) -eq 0
        echo "Usage: mc <directory> ..." >&2
        return 1
    end

    # Create the directory (including parents).
    # If multiple directories are provided, enter the last one.
    if command mkdir -pv $argv
        cd $argv[-1]
    else
        return $status
    end
end
