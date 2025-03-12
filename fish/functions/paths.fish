function paths --description "Display PATH entries in reverse order with line numbers"
    string split : $PATH | nl -v 1 -w 3 | sort -nr
end
