# Fish abbreviations and aliases configuration

# --- Tool Sanity Checks ---
# Check for optional but recommended tools and warn if missing
for tool in zoxide gomi vivid eza
    if not command -q $tool
        set_color yellow
        echo "⚠️  Warning: $tool is not installed. Some abbreviations or configurations will be disabled."
        set_color normal
    end
end

# --- Basic Shell ---
abbr sfish 'source ~/.config/fish/config.fish'
abbr !! --position anywhere --function last_history_item

# --- Navigation ---
abbr b 'cd ..'
abbr dotdot --regex '^\.\.+$' --function multicd

# Use zoxide for cd if available
if command -q zoxide
    abbr cd z
end

# --- File System Operations ---
abbr md 'mkdir -pv'
abbr mk 'mkdir -pv'
abbr tree 'erd --layout inverted --human'

# Enhanced ls with eza
if command -q eza
    alias l 'eza --sort .name --color=always --long --links --group --git --icons --classify --extended --ignore-glob=node_modules --all --hyperlink'
    alias ls l
end

# Disk usage tools
abbr df duf
abbr du dust
abbr dus diskus
abbr free 'free -h'
abbr ncdu 'ncdu --color dark'

# Safe File Operations
if command -q gomi
    abbr rm gomi
end
abbr cp "cp -ri"
abbr ln "ln -i"
abbr mv "mv -i"
abbr x 'chmod +x'

# --- Search and Find ---
abbr f 'fd --hidden --strip-cwd-prefix'
abbr grep rg
abbr rg 'rg --ignore-file ~/.config/fd/ignore'
abbr s 'rg --ignore-file ~/.config/fd/ignore'
abbr ag 'ag --smart-case --ignore node_modules'

# --- Editors ---
abbr n $default_nvim
abbr nvim $default_nvim
abbr v $default_nvim
abbr vi $default_nvim
abbr vim $default_nvim
abbr h hx
abbr nano micro

# Diff with nvim
abbr nd '$default_nvim -d -c "set nofoldenable"'

# --- Development ---
abbr g git
abbr lg lazygit
abbr j just
abbr pc pre-commit
abbr ru rustup

# Language specific
abbr cr crystal
abbr pipu "pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U"
abbr nsp 'nix-shell -p'

# Viewers
abbr cat bat
abbr less bat
abbr more bat
abbr m tldr

# --- System and Network ---
abbr htop btop
abbr top btop
abbr tp btop
abbr k 'pkill -9 -f'
abbr pkill 'pkill -9 -f'
abbr pgrep 'pgrep -f'
abbr myip "dig -4 +short myip.opendns.com @resolver1.opendns.com"
abbr rsync 'rsync --archive --hard-links --compress --human-readable --info=progress2 --update'
abbr rs 'rsync --archive --hard-links --compress --human-readable --info=progress2 --update'
abbr u topgrade
abbr wget wget2

# --- Systemd Shortcuts ---
# System
abbr scd 'sudo systemctl disable'
abbr sce 'sudo systemctl enable'
abbr scr 'sudo systemctl restart'
abbr scs 'sudo systemctl start'
abbr sct 'sudo systemctl status'
abbr sck 'sudo systemctl stop'
abbr se sudoedit
abbr sv sudoedit

# User
abbr scud 'systemctl --user disable'
abbr scue 'systemctl --user enable'
abbr scur 'systemctl --user restart'
abbr scus 'systemctl --user start'
abbr scut 'systemctl --user status'
abbr scuk 'systemctl --user stop'

# --- Docker ---
abbr d docker
abbr dc 'docker compose'
abbr dcb 'docker compose build'
abbr dcd 'docker compose down'
abbr dcl 'docker compose logs -f'
abbr dcu 'docker compose up -d'
abbr dex 'docker exec -it'
abbr di 'docker images'
abbr dps 'docker ps'
abbr dpsa 'docker ps -a'

# --- Zellij ---
abbr zj zellij
abbr za 'zellij attach'
abbr zl 'zellij list-sessions'
abbr zk 'zellij kill-session'
abbr ze 'zellij edit'
abbr zr 'zellij run'

# --- Configuration Editing ---
# Helper function to create edit abbreviations
function edit_config --argument-names abbr_name config_path post_cmd
    if test -e $config_path
        set -l dir (dirname $config_path)
        set -l file (basename $config_path)
        # Use pushd/popd to switch context, but ensure popd runs
        set -l cmd "pushd $dir; and $EDITOR $file"
        if test -n "$post_cmd"
            set cmd "$cmd; and $post_cmd"
        end
        set cmd "$cmd; popd"
        abbr $abbr_name "$cmd"
    end
end

edit_config brootrc ~/.dotfiles/broot/conf.toml
edit_config clifmrc ~/.dotfiles/clifm/profiles/default/clifmrc
edit_config fishrc ~/.dotfiles/fish/config.fish
edit_config ghosttyrc ~/.dotfiles/ghostty/config
edit_config gitrc ~/.dotfiles/git/config
edit_config hxrc ~/.dotfiles/helix/config.toml
edit_config kittyrc ~/.dotfiles/kitty/kitty.conf
edit_config mimerc ~/.dotfiles/mimeapps/mimeapps.list
edit_config navirc ~/.dotfiles/navi/config.yaml
edit_config nirirc ~/.dotfiles/niri/config.kdl
edit_config nixosrc ~/.dotfiles/nixos/configuration.nix 'nixos-rebuild build --show-trace --no-reexec'
edit_config nvimrc ~/.dotfiles/lazyvim/init.lua
edit_config qutebrowserrc ~/.dotfiles/qutebrowser/config.py
edit_config rofirc ~/.dotfiles/rofi/config.rasi
edit_config sshrc ~/.dotfiles/ssh/config
edit_config starshiprc ~/.dotfiles/starship/starship.toml
edit_config swayrc ~/.dotfiles/sway/sway/config
edit_config tldrrc ~/.dotfiles/tealdeer/config.toml
edit_config topgraderc ~/.dotfiles/topgrade/topgrade.toml
edit_config tvrc ~/.dotfiles/television/config.toml
edit_config waybarrc ~/.dotfiles/waybar/config.jsonc
edit_config weztermrc ~/.dotfiles/wezterm/wezterm.lua
edit_config xplrrc ~/.dotfiles/xplr/init.lua
edit_config yazirc ~/.dotfiles/yazi/yazi.toml
edit_config zedrc ~/.dotfiles/zed/settings.json
edit_config zellijrc ~/.dotfiles/zellij/config.kdl

# Clean up helper
functions -e edit_config
