function mc --description "Make directory and change into it"
    if test (count $argv) -eq 0
        echo "Usage: mc DIRECTORY"
        return 1
    end

    if test (count $argv) -gt 1
        echo "Error: Too many arguments, expected one directory" >&2
        return 1
    end

    if mkdir -pv "$argv[1]"
        cd "$argv[1]"
    else
        return $status
    end
end
