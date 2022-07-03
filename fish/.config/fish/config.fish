if status --is-interactive

    if ! functions --query fisher
        curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
        fisher install jorgebucaran/replay.fish
        fisher install franciscolourenco/done
        fisher install jorgebucaran/autopair.fish
        fisher install gazorby/fish-abbreviation-tips
        fisher install jorgebucaran/replay.fish
    end

    # Speed up source commands using functions files and regenerating them one time per week
    if not test -f ~/.config/fish/functions/fk.fish
        or test (date '+%s' --date '7 days ago') -ge (date '+%s' -r ~/.config/fish/functions/fk.fish)
        thefuck --alias fk >~/.config/fish/functions/fk.fish
        gh completion --shell fish >~/.config/fish/functions/gh.fish
        zoxide init fish >~/.config/fish/functions/z.fish
        starship init fish --print-full-init >~/.config/fish/functions/fish_prompt.fish
        # starship init fish | source
        # zoxide init fish | source
        # gh completion --shell fish | source
        # thefuck --alias fk | source
    end

    # Remove fish default greeting
    set fish_greeting

    # Load fish_hybrid_key_bindings function
    set -g fish_key_bindings fish_hybrid_key_bindings

    # Reduce escape key time delay
    # https://github.com/fish-shell/fish-shell/issues/6590
    set -U fish_escape_delay_ms 10

    # https://fishshell.com/docs/current/interactive.html?highlight=vim#vi-mode-commands
    # If the cursor shape does not appear to be changing after setting the above variables,
    # it's likely your terminal emulator does not support the capabilities necessary to do this.
    # It may also be the case, however, that fish_vi_cursor has not detected your terminal's features correctly
    # (for example, if you are using tmux).
    # If this is the case, you can force fish_vi_cursor to set the cursor shape by setting $fish_vi_force_cursor in config.fish.
    set -U fish_vi_force_cursor
    # Emulates vim's cursor shape behavior
    # Set the normal and visual mode cursors to a block
    set -U fish_cursor_default block
    # Set the insert mode cursor to a line
    set -U fish_cursor_insert line
    # Set the replace mode cursor to an underscore
    set -U fish_cursor_replace_one underscore
    # The following variable can be used to configure cursor shape in
    # visual mode, but due to fish_cursor_default, is redundant here
    set -U fish_cursor_visual block

    # Use default fzf functions and bindings
    # fisher install PatrickF1/fzf.fish
    # set -U fzf_preview_dir_cmd exa --sort .name --tree --classify --git --long --color=always --ignore-glob=node_modules
    # fzf_configure_bindings --git_status=\cg --history=\cr --directory=\ct --processes=\cp
    # set -U fzf_fd_opts --exclude=node_modules

    set -U LS_COLORS (vivid generate molokai)
    set -U EXA_COLORS (vivid generate molokai)

    # Setting fd as the default source for fzf
    set -x -U FZF_DEFAULT_COMMAND 'fd --type f --exclude node_modules'
    # To apply the command to CTRL-T as well
    set -x -U FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
    set -x -U FZF_CTRL_T_OPTS "--height 100% --preview 'bat --color always {}'"
    # To apply the command to ALT_C
    set -x -U FZF_ALT_C_COMMAND 'fd --type d --exclude node_modules'
    set -x -U FZF_ALT_C_OPTS "--height 100% --preview 'exa --sort .name --tree --classify --git --long --color=always --ignore-glob=node_modules {}' --preview-window wrap"
    # Molokai colors by default
    # https://github.com/junegunn/fzf/issues/1593#issuecomment-498007983
    set -x -U FZF_DEFAULT_OPTS '
    --reverse
    --color fg:255,bg:16,hl:161,fg+:255,bg+:16,hl+:161,info:118
    --color border:244,prompt:161,pointer:118,marker:161,spinner:229,header:59
    --bind "tab:down,shift-tab:up,change:top,ctrl-j:toggle+down,ctrl-k:toggle+up,ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:top,ctrl-o:execute(nvim {} < /dev/tty > /dev/tty 2>&1)+abort"
    '

    # Start ssh agent by default
    if test -z "$SSH_AUTH_SOCK"
        eval (ssh-agent -c) >/dev/null
    end

    source ~/.config/fish/abbr.fish
    source ~/.config/fish/monokai.fish
end
