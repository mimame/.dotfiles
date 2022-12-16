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

set -x -U THEFUCK_EXCLUDE_RULES fix_file # Fix https://github.com/nvbn/thefuck/issues/1153

set -U LS_COLORS (vivid generate molokai)
set -U EXA_COLORS (vivid generate molokai)

# Setting fd as the default source for fzf
set -x -U FZF_DEFAULT_COMMAND 'fd --type f --exclude node_modules'
# To apply the command to CTRL-T as well
set -x -U FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -x -U FZF_CTRL_T_OPTS "--height 100% --preview 'bat --color always {}'"
# To apply the command to ALT_C
set -x -U FZF_ALT_C_COMMAND 'fd --type d --exclude node_modules'
set -x -U FZF_ALT_C_OPTS "--height 100% --preview br --preview-window wrap"
# Molokai colors by default
# https://github.com/junegunn/fzf/issues/1593#issuecomment-498007983
set -Ux FZF_DEFAULT_OPTS "\
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

set -x -U BAT_THEME "Catppuccin-mocha"
set -x -U PAGER bat
set -x -U MANPAGER 'lvim +Man!'
set -x -U MANWIDTH 999
set -x -U BROWSER firefox
set -x -U JULIA_NUM_THREADS 12
set -x -U EDITOR lvim
set -x -U VISUAL lvim
set -x -U TMPDIR /tmp

if test -z "$XDG_CONFIG_HOME"
    set -x -U XDG_CONFIG_HOME "$HOME/.config"
end

# Always use user Python pip by default
set -x -U PIP_USER y

# Vim as default editor
fish_add_path "$HOME/.yarn/bin"
fish_add_path "$HOME/.bin"
fish_add_path "$HOME/go/bin"
fish_add_path "$HOME/.cargo/bin"
fish_add_path "$HOME/.nimble/bin"
# Always use user Ruby gems by default
if test -x "$(command -v ruby)"
    fish_add_path "$(ruby -e 'print Gem.user_dir')/bin"
end
fish_add_path "$HOME/.local/bin"
