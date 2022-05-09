abbr -a -U sfish source ~/.config/fish/config.fish
abbr -a -U ls l
abbr -a -U cd z
abbr -a -U b 'cd ..'
abbr -a -U jup juliaup
abbr -a -U rup rustup
abbr -a -U n nvim
abbr -a -U g git
abbr -a -U t " t"
abbr -a -U open o
abbr -a -U ff ' ff'
abbr -a -U fk 'fk --yes'
abbr -a -U md 'mkdir -pv'
abbr -a -U mkdir 'mkdir -pv'
abbr -a -U pgrep 'pgrep -f'
abbr -a -U pkill 'pkill -9 -f'
abbr -a -U k 'pkill -9 -f'
abbr -a -U bc 'bc -l'

# Always preserve the environment with sudo
abbr -a -U sudo 'sudo -E'

abbr -a -U grep 'grep --color=auto'
abbr -a -U fgrep 'fgrep --color=auto'
abbr -a -U egrep 'egrep --color=auto'

abbr -a -U x 'chmod +x'

abbr -a -U rs 'rsync --archive --compress --info=progress2 --human-readable --update --delete'

abbr -a -U sshfs "sshfs -o allow_other,default_permissions,follow_symlinks,kernel_cache,reconnect,ServerAliveInterval=60,ServerAliveCountMax=3"

# systemctl
abbr -a -U sstatus 'sudo systemctl status'
abbr -a -U srestart 'sudo systemctl restart'
abbr -a -U sstart 'sudo systemctl start'
abbr -a -U senable 'sudo systemctl enable'
abbr -a -U sdisable 'sudo systemctl disable'
abbr -a -U sstop 'sudo systemctl stop'

abbr -a -U a ansible
abbr -a -U ap ansible-playbook

abbr -a -U vbm VBoxManage

# Never use vi
abbr -a -U vi nvim
abbr -a -U vim nvim
abbr -a -U n nvim

abbr -a -U nd 'nvim -d -c "set nofoldenable"'
# abbr -a -U h 'history' # Use ctrl-r instead
# Lists the ten most used commands.
abbr -a -U hs "history 0 | awk '{print \$2}' | sort | uniq -c | sort -n -r | bat --number"
abbr -a -U du 'du -h'
abbr -a -U dus diskus
abbr -a -U df 'df -h'
abbr -a -U free 'free -h'
abbr -a -U j "jobs -l"
abbr -a -U ncdu 'ncdu --color dark'
abbr -a -U news newsboat
abbr -a -U fm vifm
abbr -a -U re massren
abbr -a -U T 'tail -F'
abbr -a -U nano micro
abbr -a -U less bat
abbr -a -U more bat
abbr -a -U m man

# rg with grep -r behavior
abbr -a -U ag 'ag --smart-case --ignore node_modules'
abbr -a -U s 'rg --smart-case --no-heading --with-filename --hidden --ignore-file ~/.config/fd/ignore'

# fd with find behavior
abbr -a -U f 'fd --hidden --strip-cwd-prefix'

# Safe ops. Ask the user before doing anything destructive.
# Move rm files to the trash using trash-cli
abbr -a -U rm trash
abbr -a -U mv "mv -i"
abbr -a -U cp "cp -ri"
abbr -a -U ln "ln -i"

# abbr -a -U for rc files
abbr -a -U alacrittyrc 'pushd ~/.dotfiles && nvim $(readlink -f ~/.config/alacritty/alacritty.yml) && popd'
abbr -a -U gitrc 'pushd ~/.dotfiles && nvim $(readlink -f ~/.config/git/config) && popd'
abbr -a -U i3rc 'pushd ~/.dotfiles && nvim $(readlink -f ~/.config/i3/config) && popd'
abbr -a -U mimerc 'pushd ~/.dotfiles && nvim $(readlink -f ~/.config/mimeapps.list) && popd'
abbr -a -U newsboatrc 'pushd ~/.dotfiles && nvim $(readlink -f ~/.config/newsboat/config) && popd'
abbr -a -U nvimrc 'pushd ~/.dotfiles && nvim $(readlink -f ~/.config/nvim/init.lua) && popd'
abbr -a -U rofirc 'pushd ~/.dotfiles && nvim $(readlink -f ~/.config/rofi/config.rasi) && popd'
abbr -a -U sshrc 'pushd ~/.dotfiles && nvim $(readlink -f ~/.ssh/config) && popd'
abbr -a -U tigrc 'pushd ~/.dotfiles && nvim $(readlink -f ~/.config/tig/config) && popd'
abbr -a -U tmuxrc 'pushd ~/.dotfiles && nvim $(readlink -f ~/.tmux.conf) && popd'
abbr -a -U vifmrc 'pushd ~/.dotfiles && nvim $(readlink -f ~/.config/vifm/vifmrc) && popd'
abbr -a -U vimrc 'pushd ~/.dotfiles && nvim $(readlink -f ~/.vimrc) && popd'
abbr -a -U zshrc 'pushd ~/.dotfiles && nvim $(readlink -f ~/.config/zsh/.zshrc) && popd'
abbr -a -U tridactylrc 'pushd ~/.dotfiles && nvim $(readlink -f ~/.config/tridactyl/tridactylrc) && popd'
abbr -a -U dunstrc 'pushd ~/.dotfiles && nvim $(readlink -f ~/.config/dunst/dunstrc) && popd'
abbr -a -U fishrc 'pushd ~/.dotfiles && nvim $(readlink -f ~/.config/fish/config.fish) && popd'

# abbr -a -U for pacman
abbr -a -U pu "sudo pacman -Syyu --noconfirm"
abbr -a -U pd "sudo pacman -Syyuw --noconfirm"
abbr -a -U pmu "sudo pacman-mirrors --api --protocols all --set-branch stable --fasttrack && sudo pacman -Syy"
abbr -a -U pfk "sudo pacman-key --refresh-keys && sudo pacman-key --populate archlinux manjaro"
abbr -a -U pc "sudo pacman -Scc"
abbr -a -U pi "sudo pacman -S"
# abbr -a -U for paru
abbr -a -U pua "paru --noconfirm -Syyu"

# abbr -a -U for pip
abbr -a -U pipu "pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U"

# https://www.cyberciti.biz/faq/how-to-find-my-public-ip-address-from-command-line-on-a-linux/
abbr -a -U myip "dig +short myip.opendns.com @resolver1.opendns.com"

abbr -a -U tp btop
abbr -a -U htop btop
abbr -a -U top btop

abbr -a -U lc 'libreoffice --calc'

abbr -a -U loc 'scc --sort lines'
abbr -a -U scc 'scc --sort lines'
abbr -a -U tokei 'tokei --sort lines'

# rsync abbr -a -U
abbr -a -U rsync 'rsync --archive --hard-links --compress --human-readable --info=progress2'
# }}}

abbr -a -U rm gomi


abbr -a -U rsj 'rustscan --addresses 192.168.1.0/24 --ulimit 5000 --ports 22 --greppable'
