# Fish abbreviations and aliases configuration

# --- Basic Shell ---
abbr sfish source ~/.config/fish/config.fish
abbr !! --position anywhere --function last_history_item

# --- Navigation ---
abbr b 'cd ..'
abbr cd z
abbr dotdot --regex '^\.\.+$' --function multicd
abbr md 'mkdir -pv'
abbr mk 'mkdir -pv'
abbr tree erd --layout inverted --human

# --- File System Operations ---
alias l 'eza --sort .name --color=always --long --links --group --git --icons --classify --extended --ignore-glob=node_modules --all --hyperlink'
alias ll br
alias ls l
abbr T 'tail -F'
abbr df duf
abbr du dust
abbr duf diskus
abbr dus diskus
abbr f 'fd --hidden --strip-cwd-prefix'
abbr fm vifm
abbr free 'free -h'
abbr less bat
abbr m tldr
abbr more bat
abbr ncdu 'ncdu --color dark'
abbr re massren
abbr x 'chmod +x'

# --- Safe File Operations ---
abbr rm gomi
abbr cp "cp -ri"
abbr ln "ln -i"
abbr mv "mv -i"

# --- Grep and Search ---
abbr ag 'ag --smart-case --ignore node_modules'
abbr egrep rg
abbr fgrep 'rg --fixed-strings'
abbr frg 'rg --fixed-strings'
abbr grep rg
abbr rg 'rg --ignore-file ~/.config/fd/ignore'
abbr s 'rg --ignore-file ~/.config/fd/ignore'

# --- Editors ---
set -g -x default_nvim nvim
set -g -x EDITOR $default_nvim
set -g VISUAL $EDITOR
set -g -x GIT_EDITOR $EDITOR
abbr h hx
abbr n $default_nvim
abbr nano micro
abbr nd '$default_nvim -d -c "set nofoldenable"'
abbr nvim $default_nvim
abbr v $default_nvim
abbr vi $default_nvim
abbr vim $default_nvim

# --- Development ---
abbr adoc asciidoctor
abbr adoc-pdf asciidoctor-pdf
abbr cat bat
abbr cr crystal
abbr ff ' ff'
abbr g git
abbr j just
abbr lg lazygit
abbr loc 'scc --sort lines'
abbr nsp 'nix-shell -p'
abbr open o
abbr p ptipython
abbr pc pre-commit
abbr pipu "pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U"
abbr ru rustup
abbr scc 'scc --sort lines'
abbr tokei 'tokei --sort lines'

# --- System and Network ---
abbr a ansible
abbr ap ansible-playbook
abbr bc 'bc -l'
abbr htop btop
abbr inlyne inlyne --theme dark
abbr k 'pkill -9 -f'
abbr pgrep 'pgrep -f'
abbr pkill 'pkill -9 -f'
abbr rs 'rsync --archive --hard-links --compress --human-readable --info=progress2 --update'
abbr rsync 'rsync --archive --hard-links --compress --human-readable --info=progress2 --update'
# --- Systemd ---
# System services
abbr scd 'sudo systemctl disable'
abbr sce 'sudo systemctl enable'
abbr scr 'sudo systemctl restart'
abbr scs 'sudo systemctl start'
abbr sct 'sudo systemctl status'
abbr sck 'sudo systemctl stop'
# User services
abbr scud 'systemctl --user disable'
abbr scue 'systemctl --user enable'
abbr scur 'systemctl --user restart'
abbr scus 'systemctl --user start'
abbr scut 'systemctl --user status'
abbr scuk 'systemctl --user stop'
abbr se sudoedit
abbr sv sudoedit
abbr tail tspin
abbr top btop
abbr tp btop
abbr u topgrade
abbr vbm VBoxManage
abbr wget wget2

# --- Network ---
abbr duck ddgr
abbr myip "dig -4 +short myip.opendns.com @resolver1.opendns.com"
abbr rsc 'rustscan --addresses 192.168.1.0/24 --ulimit 5000 --ports 22 --greppable'
abbr sshfs "sshfs -o allow_other,default_permissions,follow_symlinks,kernel_cache,reconnect,ServerAliveInterval=60,ServerAliveCountMax=3"

# --- Configuration File Editing ---
function edit_config --argument abbr_alias config_path
    set -l path (dirname $config_path)
    set -l filename (basename $config_path)
    abbr $abbr_alias "pushd $path && $EDITOR $filename && popd"
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
abbr nixosrc 'pushd ~/.dotfiles/nixos/ && $EDITOR configuration.nix && sudo nixos-rebuild switch --no-reexec && popd'
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

# --- Applications ---
abbr lc 'libreoffice --calc'
abbr news newsboat

# --- Zellij ---
abbr zj zellij
abbr za 'zellij attach'
abbr zl 'zellij list-sessions'
abbr zk 'zellij kill-session'
abbr ze 'zellij edit'
abbr zr 'zellij run'

# -- Docker ---
abbr d docker
abbr dc docker compose
abbr dcb 'docker compose build'
abbr dcd 'docker compose down'
abbr dcl 'docker compose logs -f'
abbr dcu 'docker compose up -d'
abbr dex 'docker exec -it'
abbr di 'docker images'
abbr dps 'docker ps'
abbr dpsa 'docker ps -a'
