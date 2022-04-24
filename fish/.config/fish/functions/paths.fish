function paths
    echo "$PATH" | sed "s/:/\n/g" | nl | tac
end
