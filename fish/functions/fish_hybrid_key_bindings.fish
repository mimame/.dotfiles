# Hybrid key bindings combining Vi and Emacs styles
function fish_hybrid_key_bindings --description "Vi style bindings that inherit emacs style binding in all modes"
    # First, establish Emacs-style bindings as the foundation for all modes
    # This provides familiar shortcuts like Ctrl+A, Ctrl+E in all modes
    for mode in default insert visual
        fish_default_key_bindings -M $mode
    end

    # Layer Vi bindings on top without erasing the Emacs bindings
    # This preserves Emacs shortcuts while adding Vi navigation and mode switching
    fish_vi_key_bindings --no-erase

    # Use space in normal mode to accept autosuggestion and move to end of line
    # This provides a quick way to complete suggestions without entering insert mode
    bind -M default ' ' accept-autosuggestion end-of-line

    # Bind 'v' in normal mode to launch editor for current command
    # Similar to Vi's visual mode but opens the full editor for complex edits
    bind -M default v edit_command_buffer

    # Configure Atuin shell history search for both modes:
    # Ctrl+R - Opens interactive history search with filtering
    # Up Arrow - Quick access to previous commands by context
    bind \cr _atuin_search
    bind -M insert \cr _atuin_search
    bind \e\[A _atuin_bind_up
    bind -M insert \e\[A _atuin_bind_up

    # Television Bindings
    # Ctrl+Alt+f: Find files
    bind \e\cf tv_find_file
    bind -M insert \e\cf tv_find_file
    bind -M default \e\cf tv_find_file

    # Alt-c: Find directories
    bind \ec tv_cd_dir
    bind -M insert \ec tv_cd_dir
    bind -M default \ec tv_cd_dir

    # Enable navi command cheatsheet integration
    # Bind Ctrl+F in insert mode for context-aware command suggestions
    bind -M insert \cf _navi_smart_replace

    # Open the current command line in Helix (or $EDITOR)
    bind \ee edit_command_buffer
    bind -M insert \ee edit_command_buffer
end
