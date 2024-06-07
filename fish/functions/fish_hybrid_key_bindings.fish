# Vi style bindings that inherit emacs style binding in all modes
function fish_hybrid_key_bindings --description "Vi style bindings that inherit emacs style binding in all modes"
    # Set default key bindings for all modes
    for mode in default insert visual
        fish_default_key_bindings -M $mode
    end

    # Set Vi key bindings without erasing
    fish_vi_key_bindings --no-erase

    # Accept autosuggestion with space in normal mode
    bind -M default \ end-of-line accept-autosuggestion

    # Open nvim in normal mode to edit the command
    bind -M default v edit_command_buffer

    # Execute TheFuck command line in insert mode
    bind -M insert \co thefuck-command-line

    # Configure fzf bindings and preview directory command
    set fzf_preview_dir_cmd eza --all --color=always --sort .name --classify --color=always --ignore-glob=node_modules
    fzf_configure_bindings --history=

    # Disable key bindings for Atuin navigation
    set -gx ATUIN_NOBIND true
    atuin init fish | source

    # Bind ctrl-r and up key in normal and insert mode for Atuin search
    bind \cr _atuin_search
    bind -M insert \cr _atuin_search
    bind \e\[A _atuin_bind_up
    bind -M insert \e\[A _atuin_bind_up

    # Add navi widget binds for smart replace
    navi widget fish | source
    bind -M insert \cf _navi_smart_replace
end
