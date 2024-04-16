function fish_hybrid_key_bindings --description "Vi style bindings that inherit emacs style binding in all modes"
    for mode in default insert visual
        fish_default_key_bindings -M $mode
    end

    fish_vi_key_bindings --no-erase

    # Accept autosuggestion with space in normal mode
    bind -M default \ end-of-line accept-autosuggestion

    # Open nvim in normal mode to edit the command
    bind -M default v edit_command_buffer

    bind -M insert \co thefuck-command-line

    # Use default fzf functions and bindings
    # fisher install PatrickF1/fzf.fish
    # set fzf_preview_dir_cmd eza --sort .name --tree --classify --git --long --color=always --ignore-glob=node_modules
    set fzf_preview_dir_cmd eza --all --color=always --sort .name --classify --color=always --ignore-glob=node_modules
    fzf_configure_bindings --history=

    set -gx ATUIN_NOBIND true
    atuin init fish | source

    # bind to ctrl-r in normal and insert mode, add any other bindings you want here too
    bind \cr _atuin_search
    bind -M insert \cr _atuin_search
    bind \e\[A _atuin_search
    bind -M insert \e\[A _atuin_search

end
