# https://github.com/fish-shell/fish-shell/issues/3469
function fzf-complete -d 'fzf completion and print selection back to commandline'
    # As of 2.6, fish's "complete" function does not understand
    # subcommands. Instead, we use the same hack as __fish_complete_subcommand and
    # extract the subcommand manually.
    set -l cmd (commandline -co) (commandline -ct)
    switch $cmd[1]
        case env sudo
            for i in (seq 2 (count $cmd))
                switch $cmd[$i]
                    case '-*'
                    case '*=*'
                    case '*'
                        set cmd $cmd[$i..-1]
                        break
                end
            end
    end
    set cmd (string join -- ' ' $cmd)

    # Remove duplicates
    # set -l complist (complete -C$cmd)
    set -l complist (complete -C$cmd | sort -u)
    set -l result
    string join -- \n $complist | sort | eval (__fzfcmd) -m --select-1 --exit-0 --header '(commandline)' | cut -f1 | while read -l r
        set result $result $r
    end

    set prefix (string sub -s 1 -l 1 -- (commandline -t))
    for i in (seq (count $result))
        set -l r $result[$i]
        # Don't escape
        # https://github.com/fish-shell/fish-shell/issues/3469
        switch $prefix
            case "'"
                # commandline -t -- (string escape -- $r)
                commandline -t -- $r
            case '"'
                if string match '*"*' -- $r >/dev/null
                    # commandline -t -- (string escape -- $r)
                    commandline -t -- $r
                else
                    commandline -t -- '"'$r'"'
                end
            case '~'
                # commandline -t -- (string sub -s 2 (string escape -n -- $r))
                commandline -t -- (string sub -s 2 $r)
            case '*'
                # commandline -t -- (string escape -n -- $r)
                commandline -t -- $r
        end
        [ $i -lt (count $result) ]; and commandline -i ' '
    end

    commandline -f repaint
end
