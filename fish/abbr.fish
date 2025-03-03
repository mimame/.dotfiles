# Fish abbreviations and aliases configuration

# Define abbreviations for common commands
abbr sfish source ~/.config/fish/config.fish
abbr !! --position anywhere --function last_history_item
abbr cat bat

# Aliases for eza with various options
alias l 'eza --sort .name --color=always --long --links --group --git --icons --classify --extended --ignore-glob=node_modules --all --hyperlink'
alias ll 'l --tree'
alias ls l

# Define more abbreviations for common commands
abbr lll br
abbr tree erd --layout inverted --human
abbr cd z
abbr b 'cd ..'
abbr dotdot --regex '^\.\.+$' --function multicd
abbr ru rustup
abbr cr crystal
abbr g git
abbr lg lazygit
abbr pc pre-commit
abbr t " t"
abbr open o
abbr ff ' ff'
abbr md 'mkdir -pv'
abbr mkdir 'mkdir -pv'
abbr pgrep 'pgrep -f'
abbr pkill 'pkill -9 -f'
abbr k 'pkill -9 -f'
abbr bc 'bc -l'
abbr mk 'mkdir -pv'
abbr u topgrade
abbr inlyne inlyne --theme dark
abbr wget wget2
abbr d ddgr
abbr tail tspin
abbr p ptipython

# Grep with color
abbr grep rg
abbr fgrep 'rg --fixed-strings'
abbr egrep rg
abbr frg 'rg --fixed-strings'

# Make scripts executable
abbr x 'chmod +x'

# SSHFS with specific options
abbr sshfs "sshfs -o allow_other,default_permissions,follow_symlinks,kernel_cache,reconnect,ServerAliveInterval=60,ServerAliveCountMax=3"

# Systemctl commands with sudo
abbr sstatus 'sudo systemctl status'
abbr srestart 'sudo systemctl restart'
abbr sstart 'sudo systemctl start'
abbr senable 'sudo systemctl enable'
abbr sdisable 'sudo systemctl disable'
abbr sstop 'sudo systemctl stop'

# Abbreviations for frequently used commands
abbr a ansible
abbr ap ansible-playbook
abbr vbm VBoxManage

# Use nvim as the default editor
set -g -x default_nvim nvim
set -g -x EDITOR $default_nvim
set -g VISUAL $EDITOR
set -g -x GIT_EDITOR $EDITOR
abbr n $default_nvim
abbr nvim $default_nvim
abbr v $default_nvim
abbr vi $default_nvim
abbr vim $default_nvim

# Always preserve the environment with sudoedit
abbr sv sudoedit
abbr se sudoedit

# Helix editor abbreviation
abbr h hx

# Open nvim in diff mode
abbr nd '$default_nvim -d -c "set nofoldenable"'

# Abbreviations for listing history and disk usage commands
abbr hs "history 0 | awk '{print \$2}' | sort | uniq -c | sort -n -r | bat --number"
abbr du dust
abbr dus diskus
abbr df duf
abbr free 'free -h'

# Directory navigation and system monitoring
abbr j just
abbr ncdu 'ncdu --color dark'
abbr news newsboat
abbr fm vifm
abbr r ranger
abbr re massren
abbr T 'tail -F'
abbr nano micro
abbr less bat
abbr more bat
abbr m tldr

# Ripgrep and fd with specific options
abbr ag 'ag --smart-case --ignore node_modules'
# abbr s 'rg --smart-case --no-heading --with-filename --hidden --ignore-file ~/.config/fd/ignore'
abbr s 'rg --ignore-file ~/.config/fd/ignore'
abbr rg 'rg --ignore-file ~/.config/fd/ignore'
abbr f 'fd --hidden --strip-cwd-prefix'

# Safe operations for rm, mv, cp, and ln
if command -q gomi
    abbr rm gomi
else
    abbr rm trash-put
end
abbr mv "mv -i"
abbr cp "cp -ri"
abbr ln "ln -i"


# Abbreviation for updating pip packages
abbr pipu "pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U"

# Command to find public IP address
abbr myip "dig -4 +short myip.opendns.com @resolver1.opendns.com"

# Abbreviations for system monitoring
abbr tp btop
abbr htop btop
abbr top btop

# LibreOffice Calc
abbr lc 'libreoffice --calc'

# Abbreviations for code statistics
abbr loc 'scc --sort lines'
abbr scc 'scc --sort lines'
abbr tokei 'tokei --sort lines'

# Rsync with specific options
abbr rsync 'rsync --archive --hard-links --compress --human-readable --info=progress2 --update'
abbr rs 'rsync --archive --hard-links --compress --human-readable --info=progress2 --update'

# Rustscan
abbr rsc 'rustscan --addresses 192.168.1.0/24 --ulimit 5000 --ports 22 --greppable'

# Asciidoctor
abbr adoc asciidoctor
abbr adoc-pdf asciidoctor-pdf
# --- Configuration File Editing ---
function edit_config --argument config_name config_path config_file
    abbr $config_name "pushd $config_path && $EDITOR $config_file && popd"
end

# NixOS
abbr nsp 'nix-shell -p'
edit_config brootrc ~/.dotfiles/broot/ conf.toml
edit_config clifmrc ~/.dotfiles/clifm/profiles/default/ clifmrc
edit_config fishrc ~/.dotfiles/fish/ config.fish
edit_config ghosttyrc ~/.dotfiles/ghostty/ config
edit_config gitrc ~/.dotfiles/git/ config
edit_config hxrc ~/.dotfiles/helix/ config.toml
edit_config kittyrc ~/.dotfiles/kitty/ kitty.conf
edit_config mimerc ~/.dotfiles/mimeapps/ mimeapps.list
edit_config navirc ~/.dotfiles/navi/ config.yaml
# abbr nixosrc 'pushd ~/.dotfiles/nixos/ && $EDITOR configuration.nix && treefmt && sudo nixos-rebuild switch --fast && popd'
edit_config nvimrc ~/.dotfiles/nvchad/ init.lua
edit_config qutebrowserrc ~/.dotfiles/qutebrowser/ config.py
edit_config rofirc ~/.dotfiles/rofi/ config.rasi
edit_config sshrc ~/.dotfiles/ssh/ config
edit_config starshiprc ~/.dotfiles/starship/ starship.toml
edit_config swayrc ~/.dotfiles/sway/sway/ config
edit_config tldrrc ~/.dotfiles/tealdeer/ config.toml
edit_config topgraderc ~/.dotfiles/topgrade/ topgrade.toml
edit_config weztermrc ~/.dotfiles/wezterm/ wezterm.lua
edit_config xplrrc ~/.dotfiles/xplr/ init.lua
edit_config yazirc ~/.dotfiles/yazi/ yazi.toml
edit_config zellijrc ~/.dotfiles/zellij/ config.kdl

