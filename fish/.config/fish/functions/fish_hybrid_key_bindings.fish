function fish_hybrid_key_bindings --description "Vi style bindings that inherit emacs style binding in all modes"
    for mode in default insert visual
        fish_default_key_bindings -M $mode
    end
    fish_vi_key_bindings --no-erase
    # Accept autosuggestion with space in normal mode
    bind -M default \  end-of-line accept-autosuggestion
    # Open nvim in normal mode to edit the command
    bind -M default v edit_command_buffer

    fzf_key_bindings

    bind -M insert \t fzf-complete

    bind -M insert \co thefuck-command-line
end
