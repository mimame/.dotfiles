abbr sfish source ~/.config/fish/config.fish
abbr !! --position anywhere --function last_history_item
abbr cat bat
alias ls 'exa --sort .name --color=always --long --links --group --git --icons --classify --extended --ignore-glob=node_modules --all'
abbr ll ls
abbr l br
abbr cd z
abbr b 'cd ..'
abbr dotdot --regex '^\.\.+$' --function multicd
abbr ju juliaup
abbr ru rustup
abbr n nim
abbr cr crystal
abbr g git
abbr lg lazygit
abbr pc pre-commit
abbr t " t"
abbr open o
abbr ff ' ff'
abbr fk 'fk --yes'
abbr md 'mkdir -pv'
abbr mkdir 'mkdir -pv'
abbr pgrep 'pgrep -f'
abbr pkill 'pkill -9 -f'
abbr k 'pkill -9 -f'
abbr bc 'bc -l'
abbr mk 'mkdir -pv'
abbr u topgrade

abbr docker podman

abbr p 'ptipython'

abbr grep 'grep --color=auto'
abbr fgrep 'fgrep --color=auto'
abbr egrep 'egrep --color=auto'

abbr x 'chmod +x'

abbr sshfs "sshfs -o allow_other,default_permissions,follow_symlinks,kernel_cache,reconnect,ServerAliveInterval=60,ServerAliveCountMax=3"

# systemctl
abbr sstatus 'sudo systemctl status'
abbr srestart 'sudo systemctl restart'
abbr sstart 'sudo systemctl start'
abbr senable 'sudo systemctl enable'
abbr sdisable 'sudo systemctl disable'
abbr sstop 'sudo systemctl stop'

abbr a ansible
abbr ap ansible-playbook

abbr vbm VBoxManage

# Never use vi
abbr vi lvim
abbr vim lvim
abbr v lvim
abbr nvim lvim
# Always preserve the environment with sudoedit
abbr sv sudoedit
abbr se sudoedit

abbr h hx

abbr nd 'nvim -d -c "set nofoldenable"'
# abbr h 'history' # Use ctrl-r instead
# Lists the ten most used commands.
abbr hs "history 0 | awk '{print \$2}' | sort | uniq -c | sort -n -r | bat --number"
abbr du 'du -h'
abbr dus diskus
abbr df 'df -h'
abbr free 'free -h'
# abbr j "jobs -l"
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
abbr m man

# rg with grep -r behavior
abbr ag 'ag --smart-case --ignore node_modules'
abbr s 'rg --smart-case --no-heading --with-filename --hidden --ignore-file ~/.config/fd/ignore'

# fd with find behavior
abbr f 'fd --hidden --strip-cwd-prefix'

# Safe ops. Ask the user before doing anything destructive.
# Move rm files to the trash using trash-cli
abbr rm gomi
abbr mv "mv -i"
abbr cp "cp -ri"
abbr ln "ln -i"

# abbr for rc files
abbr brootrc 'pushd ~/.dotfiles && $EDITOR $(readlink -f ~/.config/broot/conf.toml) && popd'
abbr clifmrc 'pushd ~/.dotfiles && $EDITOR $(readlink -f ~/.config/clifm/profiles/default/clifmrc) && popd'
abbr dunstrc 'pushd ~/.dotfiles && $EDITOR $(readlink -f ~/.config/dunst/dunstrc) && popd'
abbr fishrc 'pushd ~/.dotfiles && $EDITOR $(readlink -f ~/.config/fish/config.fish) && popd'
abbr gitrc 'pushd ~/.dotfiles && $EDITOR $(readlink -f ~/.config/git/config) && popd'
abbr hxrc 'pushd ~/.dotfiles && $EDITOR $(readlink -f ~/.config/helix/config.toml) && popd'
abbr kittyrc 'pushd ~/.dotfiles && $EDITOR $(readlink -f ~/.config/kitty/kitty.conf) && popd'
abbr mimerc 'pushd ~/.dotfiles && $EDITOR $(readlink -f ~/.config/mimeapps.list) && popd'
abbr newsboatrc 'pushd ~/.dotfiles && $EDITOR $(readlink -f ~/.config/newsboat/config) && popd'
abbr nixosrc 'sudoedit /etc/nixos/configuration.nix && sudo nixfmt /etc/nixos/configuration.nix && sudo nixos-rebuild switch && cp /etc/nixos/configuration.nix ~/.dotfiles/nixos/etc/nixos/'
abbr rofirc 'pushd ~/.dotfiles && $EDITOR $(readlink -f ~/.config/rofi/config.rasi) && popd'
abbr sshrc 'pushd ~/.dotfiles && $EDITOR $(readlink -f ~/.ssh/config) && popd'
abbr swayrc 'pushd ~/.dotfiles && $EDITOR $(readlink -f ~/.config/sway/config) && popd'
abbr tridactylrc 'pushd ~/.dotfiles && $EDITOR $(readlink -f ~/.config/tridactyl/tridactylrc) && popd'
abbr weztermrc 'pushd ~/.dotfiles && $EDITOR $(readlink -f ~/.config/wezterm/wezterm.lua) && popd'
abbr xplrrc 'pushd ~/.dotfiles && $EDITOR $(readlink -f ~/.config/xplr/init.lua) && popd'
abbr zellijrc 'pushd ~/.dotfiles && $EDITOR $(readlink -f ~/.config/zellij/config.kdl) && popd'

# abbr for pip
abbr pipu "pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U"

# https://www.cyberciti.biz/faq/how-to-find-my-public-ip-address-from-command-line-on-a-linux/
abbr myip "dig +short myip.opendns.com @resolver1.opendns.com"

abbr tp btop
abbr htop btop
abbr top btop

abbr lc 'libreoffice --calc'

abbr loc 'scc --sort lines'
abbr scc 'scc --sort lines'
abbr tokei 'tokei --sort lines'

# rsync abbr
abbr rsync 'rsync --archive --hard-links --compress --human-readable --info=progress2 --update'
abbr rs 'rsync --archive --hard-links --compress --human-readable --info=progress2 --update'
# }}}

abbr rsc 'rustscan --addresses 192.168.1.0/24 --ulimit 5000 --ports 22 --greppable'

abbr adoc asciidoctor
abbr adoc-pdf asciidoctor-pdf
