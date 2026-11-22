# Fish abbreviations and aliases configuration

# Helper function to create edit abbreviations
function edit_config --argument-names abbr_name config_path post_cmd
    # If the path is not absolute, resolve it relative to XDG_CONFIG_HOME (~/.config)
    set -l full_path $config_path
    if not string match -q "/*" -- $config_path
        set full_path "$XDG_CONFIG_HOME/$config_path"
    end

    if test -e $full_path
        set -l dir (dirname $full_path)
        set -l file (basename $full_path)
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
abbr sfish "source $__fish_config_dir/config.fish"
abbr !! --position anywhere --function last_history_item

# --- Navigation ---
abbr b 'cd ..'
abbr .. 'cd ..'
abbr dotdot --regex '^\.\.\.+$' 'bb ..'

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
    alias l 'eza --sort .name --color=always --long --links --group --git --icons --classify --extended --ignore-glob=node_modules --all --hyperlink=auto'
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
if command -q gomi
    abbr rm 'gomi -i'
end
abbr cp "cp -ri"
abbr ln "ln -i"
abbr mv "mv -i"
abbr x 'chmod +x'

# --- Search and Find ---
abbr f 'fd --hidden --strip-cwd-prefix'
abbr grep rg
abbr rg "rg --ignore-file $XDG_CONFIG_HOME/fd/ignore"
abbr s "rg --ignore-file $XDG_CONFIG_HOME/fd/ignore"
abbr ag 'ag --smart-case --ignore node_modules'

# --- Editors ---
abbr h hx
abbr zd zeditor
abbr nano micro

# --- Development ---
abbr g git
abbr j just
abbr lg lazygit
abbr pc pre-commit
abbr ru rustup
abbr tf tofu
abbr tfa 'tofu apply'
abbr tfi 'tofu init'
abbr tfp 'tofu plan'

# prek (fast pre-commit)
abbr pr 'prek run'
abbr pra 'prek run --all-files'
abbr prd 'prek run --show-diff-on-failure'
abbr pru 'prek autoupdate'

# Homebrew
abbr bi 'brew install'
abbr br 'brew remove'
abbr bs 'brew search'
abbr binfo 'brew info'
abbr bl 'brew list'
abbr bu 'brew update && brew upgrade'

# Language specific
abbr cr crystal
abbr pipu "pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U"
abbr nsp 'nix-shell -p'

# Viewers
# Use alias instead of abbr so 7z is available to other functions (e.g., e.fish, c.fish)
alias 7z 7zz
abbr cat bat
abbr jq jaq
# moor is a drop-in less replacement — syntax highlighting, ANSI colors, no config.
# When piped (e.g. `git diff | less`), moor receives ANSI from the command and
# renders it correctly. No bat flags needed.
abbr less moor
abbr more moor
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
abbr rsync 'rsync --archive --hard-links --human-readable --info=progress2 --update --exclude-from=$XDG_CONFIG_HOME/rsync/default.rules'
abbr rs 'rsync --archive --hard-links --human-readable --info=progress2 --update --exclude-from=$XDG_CONFIG_HOME/rsync/default.rules'
abbr u topgrade
abbr wget wget2
abbr download get

# --- Logs ---
# Unified prefix: klog* = kernel (dmesg), jlog* = journal (journalctl)
# Consistent suffixes: no suffix = recent, f = follow, e = errors, b = boot, u = unit
# For cross-source search: lrg <pattern>  (searches dmesg + journal simultaneously)

# dmesg: kernel ring buffer (available on all platforms)
abbr klog 'sudo dmesg -H' # human-readable timestamps + colors
abbr klogf 'sudo dmesg -w' # follow (live stream, like tail -f)
abbr kloge 'sudo dmesg -H --level=err,crit,alert,emerg' # errors only

# journalctl: systemd journal (NixOS/Linux only — skipped silently on macOS)
if command -q journalctl
    abbr jlog 'journalctl -xe' # recent logs with explanations (common debug entry point)
    abbr jlogf 'journalctl -f' # follow live
    abbr jlogb 'journalctl -b' # current boot
    abbr jloge 'journalctl -b -p err..emerg' # errors this boot only
    abbr jlogu 'journalctl -u' # unit logs — append unit name: jlogu sshd
end

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

# --- NixOS ---
# Everything under one visible prefix `nixos-`, so it is obvious these are
# store-writers. No cryptic sigla. Deliberately none is named
# `nixos-rebuild`: it would hijack the real command. No timers by policy:
# nothing touches the store on its own (recovery note in
# nixos/core/nix-config.nix). Append flags (`nixos-switch --no-reexec`),
# not subcommands.
abbr nixos-switch 'sudo nixos-rebuild switch --show-trace'
abbr nixos-test 'sudo nixos-rebuild test --show-trace'
abbr nixos-boot 'sudo nixos-rebuild boot --show-trace'
abbr nixos-dry 'sudo nixos-rebuild dry-build --show-trace'
abbr nixos-rollback 'sudo nixos-rebuild switch --rollback'
abbr nixos-generations 'nixos-rebuild list-generations'
# Full update cycle, one command: `--upgrade` runs `nix-channel --update`
# internally and then switches against the new channel. Opaque on purpose
# (B, you picked it): one step, no explicit stop point. Do not use this to
# retry a broken rebuild: `--upgrade` re-fetches the channel on every
# attempt and the toplevel references shift. Type it bare; extra args land
# on the switch.
abbr nixos-upgrade 'sudo nixos-rebuild switch --upgrade --show-trace'
# GC is its own word because it is its own step: slow, and deliberately not
# inside nixos-upgrade. Run it occasionally or when the disk gets tight.
abbr nixos-gc 'sudo nix-collect-garbage --delete-older-than 14d'
# Store health. nixos-check only reports; nixos-repair backfills modified
# content from cache.nixos.org, which is what actually fixed the store.
# The `nix store verify --all --repair` CLI form reports but does not
# repair; skip it.
abbr nixos-check 'sudo nix-store --verify --check-contents'
abbr nixos-repair 'sudo nix-store --verify --check-contents --repair'

# --- Configuration Editing ---

edit_config brootrc broot/conf.toml
edit_config clifmrc clifm/profiles/default/clifmrc
edit_config fishrc fish/config.fish
edit_config ghosttyrc ghostty/config
edit_config gitrc git/config
edit_config hxrc helix/config.toml
edit_config kittyrc kitty/kitty.conf
edit_config mimerc mimeapps/mimeapps.list
edit_config navirc navi/config.yaml
edit_config newsrc newsboat/config
edit_config nirirc niri/config.kdl
edit_config nixosrc /etc/nixos/configuration.nix 'sudo nixos-rebuild switch --show-trace --no-reexec'
edit_config sshrc ssh/config
edit_config starshiprc starship/starship.toml
edit_config tldrrc tealdeer/config.toml
edit_config topgraderc topgrade/topgrade.toml
edit_config tvrc television/config.toml
edit_config yazirc yazi/yazi.toml
edit_config fastrc fastfetch/config.jsonc
edit_config zdrc zed/settings.json
edit_config zellijrc zellij/config.kdl
edit_config tmuxrc tmux/tmux.conf
