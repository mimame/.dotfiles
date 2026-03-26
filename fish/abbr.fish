# Fish abbreviations and aliases configuration

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

# --- Basic Shell ---
abbr sfish 'source ~/.config/fish/config.fish'
abbr !! --position anywhere --function last_history_item

# --- Navigation ---
abbr b 'cd ..'
abbr .. 'cd ..'
abbr dotdot --regex '^\.\.\.+$' 'bb ..'

# Use zoxide for cd if available
if type -q zoxide
    abbr cd z
end

# --- File System Operations ---
abbr md 'mkdir -pv'
abbr mk 'mkdir -pv'
abbr tree 'erd --layout inverted --human'

# Enhanced ls with eza
if type -q eza
    alias l 'eza --sort .name --color=always --long --links --group --git --icons --classify --extended --ignore-glob=node_modules --all --hyperlink'
    alias ls l
else
    alias l 'ls -lah'
end

# Disk usage tools
abbr df duf
abbr du dust
abbr dus diskus
abbr free 'free -h'
abbr ncdu 'ncdu --color dark'

# Safe File Operations
if type -q gomi
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
abbr zd zeditor
abbr nano micro

# Diff with nvim
abbr nd '$default_nvim -d -c "set nofoldenable"'

# --- Development ---
abbr g git
abbr lg lazygit
abbr tf treefmt
abbr j just
abbr pc pre-commit
abbr ru rustup

# Language specific
abbr cr crystal
abbr pipu "pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U"
abbr nsp 'nix-shell -p'

# Viewers
# Use alias instead of abbr so 7z is available to other functions (e.g., e.fish, c.fish)
alias 7z 7zz
abbr cat bat
abbr less bat
abbr more bat
abbr m tldr
abbr news newsboat

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
abbr download get

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

edit_config brootrc $__fish_config_dir/../../broot/conf.toml
edit_config clifmrc $__fish_config_dir/../../clifm/profiles/default/clifmrc
edit_config fishrc $__fish_config_dir/config.fish
edit_config ghosttyrc $__fish_config_dir/../../ghostty/config
edit_config gitrc $__fish_config_dir/../../git/config
edit_config hxrc $__fish_config_dir/../../helix/config.toml
edit_config kittyrc $__fish_config_dir/../../kitty/kitty.conf
edit_config mimerc $__fish_config_dir/../../mimeapps/mimeapps.list
edit_config navirc $__fish_config_dir/../../navi/config.yaml
edit_config newsrc $__fish_config_dir/../../newsboat/config
edit_config nirirc $__fish_config_dir/../../niri/config.kdl
edit_config nixosrc $__fish_config_dir/../../nixos/configuration.nix 'sudo nixos-rebuild switch --show-trace --no-reexec'
edit_config nvimrc $__fish_config_dir/../../lazyvim/init.lua
edit_config qutebrowserrc $__fish_config_dir/../../qutebrowser/config.py
edit_config sshrc $__fish_config_dir/../../ssh/config
edit_config starshiprc $__fish_config_dir/../../starship/starship.toml
edit_config tldrrc $__fish_config_dir/../../tealdeer/config.toml
edit_config topgraderc $__fish_config_dir/../../topgrade/topgrade.toml
edit_config tvrc $__fish_config_dir/../../television/config.toml
edit_config yazirc $__fish_config_dir/../../yazi/yazi.toml
edit_config zdrc $__fish_config_dir/../../zed/settings.json
edit_config zellijrc $__fish_config_dir/../../zellij/config.kdl
