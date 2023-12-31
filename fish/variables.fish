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
# set -U fzf_preview_dir_cmd eza --sort .name --tree --classify --git --long --color=always --ignore-glob=node_modules
# fzf_configure_bindings --git_status=\cg --history=\cr --directory=\ct --processes=\cp
# set -U fzf_fd_opts --exclude=node_modules

set -x -U THEFUCK_EXCLUDE_RULES fix_file # Fix https://github.com/nvbn/thefuck/issues/1153

set -U LS_COLORS (vivid generate ~/.config/vivid/tokyonight_moon.yml)
set -U EZA_COLORS (vivid generate ~/.config/vivid/tokyonight_moon.yml)

# Setting fd as the default source for fzf
set -x -U FZF_DEFAULT_COMMAND 'fd --type file --exclude node_modules'
# To apply the command to CTRL-T as well
set -x -U FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -x -U FZF_CTRL_T_OPTS "--height 100% --preview 'bat --color always {}'"
# To apply the command to ALT_C
set -x -U FZF_ALT_C_COMMAND 'fd --type directory --exclude node_modules'
set -x -U FZF_ALT_C_OPTS "--height 100% --preview br --preview-window wrap"
# Tokyonight colors by default
# https://github.com/junegunn/fzf/issues/1593#issuecomment-498007983
set -Ux FZF_DEFAULT_OPTS '
--reverse
--color=fg:#c5cdd9,bg:#1e2030,hl:#6cb6eb
--color=fg+:#c5cdd9,bg+:#1e2030,hl+:#5dbbc1
--color=info:#88909f,prompt:#ec7279,pointer:#d38aea
--color=marker:#a0c980,spinner:#ec7279,header:#5dbbc1
--bind "tab:down,shift-tab:up,change:top,ctrl-j:toggle+down,ctrl-k:toggle+up,ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:top,ctrl-o:execute($EDITOR {} < /dev/tty > /dev/tty 2>&1)+abort"
'

set -x -U BAT_THEME "Enki-Tokyo-Night"
set -x -U MOAR '--statusbar=bold --no-linenumbers'
set -g PAGER moar --wrap
set -x -U MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -x -U JULIA_NUM_THREADS 12
set -g EDITOR lvim
set -g VISUAL $EDITOR
set -x -U BROWSER floorp
set -x -U TMPDIR /tmp
set -x -U TERMINAL wezterm

if test -z "$XDG_CONFIG_HOME"
    set -x -U XDG_CONFIG_HOME "$HOME/.config"
end

# Never use user Python pip by default
# pre-commit is broken with this
set -x -U PIP_USER false

# Vim as default editor
fish_add_path "$HOME/.yarn/bin"
fish_add_path "$HOME/.bin"
fish_add_path "$HOME/go/bin"
fish_add_path "$HOME/.cargo/bin"
fish_add_path "$HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin"
# Always use user Ruby gems by default
if test -x "$(command -v ruby)"
    fish_add_path "$(ruby -e 'print Gem.user_dir')/bin"
end
fish_add_path "$HOME/.local/bin"

set -x -U GTK_IM_MODULE ibus
set -x -U QT_IM_MODULE ibus
set -x -U XMODIFIERS @im=ibus

set -x -U TZ_LIST "CET,Central European Time;UTC,Coordinated Universal Time;US/Eastern,Eastern Standard Time;US/Pacific,Pacific Standard Time;Asia/Singapore, Singapore;Mexico/General"
