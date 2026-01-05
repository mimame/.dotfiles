function last_history_item --description "Return the last command from history"
    if set -q history[1]
        printf "%s\n" $history[1]
    end
end
