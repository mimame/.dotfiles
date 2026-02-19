# Nushell Config File
#
# version = "0.110.0"

# --- Dracula Theme ---
let dracula = {
    separator: "#6272a4"
    leading_trailing_space_bg: { attr: "n" }
    header: { fg: "#50fa7b" attr: "b" }
    empty: "#8be9fd"
    bool: {|| if $in { "#50fa7b" } else { "#ff5555" } }
    int: "#bd93f9"
    filesize: {|e|
        if $e == 0b {
            "#6272a4"
        } else if $e < 1mb {
            "#50fa7b"
        } else {{ fg: "#8be9fd" }}
    }
    duration: "#f1fa8c"
    date: {|| (date now) - $in |
        if $in < 1hr {
            { fg: "#ff5555" attr: "b" }
        } else if $in < 6hr {
            "#ff5555"
        } else if $in < 1day {
            "#ffb86c"
        } else if $in < 3day {
            "#50fa7b"
        } else if $in < 1wk {
            { fg: "#50fa7b" attr: "b" }
        } else if $in < 6wk {
            "#8be9fd"
        } else if $in < 52wk {
            "#bd93f9"
        } else { "#6272a4" }
    }
    range: "#bd93f9"
    float: "#bd93f9"
    string: "#f1fa8c"
    nothing: "#6272a4"
    binary: "#bd93f9"
    cellpath: "#f8f8f2"
    row_index: { fg: "#50fa7b" attr: "b" }
    record: "#f8f8f2"
    list: "#f8f8f2"
    block: "#f8f8f2"
    hints: "#6272a4"
    search_result: { fg: "#ff5555" bg: "#f8f8f2" }

    shape_and: { fg: "#ff79c6" attr: "b" }
    shape_binary: { fg: "#ff79c6" attr: "b" }
    shape_block: { fg: "#bd93f9" attr: "b" }
    shape_bool: "#50fa7b"
    shape_custom: "#50fa7b"
    shape_datetime: { fg: "#8be9fd" attr: "b" }
    shape_directory: "#8be9fd"
    shape_external: "#8be9fd"
    shape_externalarg: { fg: "#50fa7b" attr: "b" }
    shape_filepath: "#8be9fd"
    shape_flag: { fg: "#bd93f9" attr: "b" }
    shape_float: { fg: "#ff79c6" attr: "b" }
    shape_garbage: { fg: "#FFFFFF" bg: "#FF0000" attr: "b" }
    shape_globpattern: { fg: "#8be9fd" attr: "b" }
    shape_int: { fg: "#ff79c6" attr: "b" }
    shape_internalcall: { fg: "#8be9fd" attr: "b" }
    shape_list: { fg: "#8be9fd" attr: "b" }
    shape_literal: "#bd93f9"
    shape_match_pattern: "#50fa7b"
    shape_matching_brackets: { attr: "u" }
    shape_nothing: "#8be9fd"
    shape_operator: "#ffb86c"
    shape_or: { fg: "#ff79c6" attr: "b" }
    shape_pipe: { fg: "#ff79c6" attr: "b" }
    shape_range: { fg: "#ffb86c" attr: "b" }
    shape_record: { fg: "#8be9fd" attr: "b" }
    shape_redirection: { fg: "#ff79c6" attr: "b" }
    shape_signature: { fg: "#50fa7b" attr: "b" }
    shape_string: "#f1fa8c"
    shape_string_interpolation: { fg: "#8be9fd" attr: "b" }
    shape_table: { fg: "#bd93f9" attr: "b" }
    shape_variable: "#ff79c6"

    background: "#282a36"
    foreground: "#f8f8f2"
    cursor: "#f8f8f2"
}

# --- Completers ---
let fish_completer = {|spans|
    fish --command $'complete "--do-complete=($spans | str join " ")"'
    | $"value(char tab)description(char newline)" + $in
    | from tsv --flexible --no-infer
}

let zoxide_completer = {|spans|
    $spans | skip 1 | zoxide query -l ...$in | lines | where {|x| $x != $env.PWD}
}

let external_completer = {|spans|
    match $spans.0 {
        __zoxide_z | __zoxide_zi => $zoxide_completer
        _ => $fish_completer
    } | do $in $spans
}

# --- Global Config ---
$env.config = {
    show_banner: false

    ls: {
        use_ls_colors: true
        clickable_links: true
    }

    rm: {
        always_trash: true
    }

    table: {
        mode: rounded # basic, compact, compact_double, light, thin, with_love, rounded, reinforced, heavy, none, other
        index_mode: always
        show_empty: true
        padding: { left: 1, right: 1 }
        trim: {
            methodology: wrapping
            wrapping_try_keep_words: true
        }
    }

    history: {
        max_size: 100_000
        sync_on_enter: true
        file_format: "sqlite"
        isolation: false
    }

    completions: {
        case_sensitive: false
        quick: true
        partial: true
        algorithm: "fuzzy"
        external: {
            enable: true
            max_results: 100
            completer: $external_completer
        }
    }

    cursor_shape: {
        emacs: line
        vi_insert: line
        vi_normal: block
    }

    color_config: $dracula
    footer_mode: 25
    float_precision: 2
    edit_mode: vi
    shell_integration: {
        osc2: true
        osc7: true
        osc8: true
        osc9_9: false
        osc133: true
        osc633: true
        reset_application_mode: true
    }

    hooks: {
        pre_prompt: [{ ||
            if (which direnv | is-not-empty) {
                direnv export json | from json | default {} | load-env
            }
        }]
    }

    keybindings: [
        {
            name: completion_menu
            modifier: none
            keycode: tab
            mode: [emacs vi_normal vi_insert]
            event: {
                until: [
                    { send: menu name: completion_menu }
                    { send: menunext }
                ]
            }
        }
        {
            name: history_menu
            modifier: control
            keycode: char_r
            mode: [emacs, vi_insert, vi_normal]
            event: { send: menu name: history_menu }
        }
        {
            name: move_up
            modifier: none
            keycode: up
            mode: [emacs, vi_normal, vi_insert]
            event: {
                until: [
                    {send: menuup}
                    {send: up}
                ]
            }
        }
        {
            name: move_down
            modifier: none
            keycode: down
            mode: [emacs, vi_normal, vi_insert]
            event: {
                until: [
                    {send: menudown}
                    {send: down}
                ]
            }
        }
        {
            name: move_left
            modifier: none
            keycode: left
            mode: [emacs, vi_normal, vi_insert]
            event: {
                until: [
                    {send: menuleft}
                    {send: left}
                ]
            }
        }
        {
            name: move_right_or_take_history_hint
            modifier: none
            keycode: right
            mode: [emacs, vi_normal, vi_insert]
            event: {
                until: [
                    {send: historyhintcomplete}
                    {send: menuright}
                    {send: right}
                ]
            }
        }
        {
            name: move_to_line_start
            modifier: control
            keycode: char_a
            mode: [emacs, vi_normal, vi_insert]
            event: {edit: movetolinestart}
        }
        {
            name: move_to_line_end_or_take_history_hint
            modifier: control
            keycode: char_e
            mode: [emacs, vi_normal, vi_insert]
            event: {
                until: [
                    {send: historyhintcomplete}
                    {edit: movetolineend}
                ]
            }
        }
        {
            name: fzf_search_directory
            modifier: control_alt
            keycode: char_d
            mode: [ emacs, vi_normal, vi_insert ]
            event: [
                     { edit: Clear }
                     { edit: InsertString,
                       value: "cd (fd --type directory --color=always | fzf --ansi | str trim)"

                     }
                     { send: Enter }
                   ]
        }
        {
            name: fzf_search_file
            modifier: control_alt
            keycode: char_f
            mode: [ emacs, vi_normal, vi_insert ]
            event: [
                     { edit: InsertString,
                       value: "(fd --type file --color=always | fzf --ansi | str trim)"
                     }
                   ]
        }
    ]
}

# --- Load Functions ---
source ~/.config/nushell/functions/cb.nu
source ~/.config/nushell/functions/t.nu
source ~/.config/nushell/functions/o.nu
source ~/.config/nushell/functions/paths.nu
source ~/.config/nushell/functions/mc.nu
source ~/.config/nushell/functions/y.nu
source ~/.config/nushell/functions/bb.nu

# --- Load Plugins/Scripts ---
use ~/.cache/nushell/starship/init.nu
source ~/.cache/nushell/zoxide/init.nu
source ~/.cache/nushell/atuin/init.nu
source ~/.cache/nushell/navi/init.nu
source ~/.cache/nushell/pay-respects/init.nu

# --- Native Structured Commands ---

# Improved 'l' to return a sorted table of current files
def l [path: path = "."] {
    ls -a $path | sort-by type name
}

# Improved 'll' for a detailed tree-like view if desired, or standard sorted view
def ll [path: path = "."] {
    ls -a $path | sort-by type name | table -e
}

# --- Aliases ---

# Navigation
alias b = cd ..
alias .. = cd ..
alias ... = cd ../..
alias .... = cd ../../..

# File System
alias md = mkdir -v
alias mk = mkdir -v
alias tree = erd --layout inverted --human

alias ls = l

alias df = duf
alias du = dust
alias dus = diskus
alias free = free -h
alias ncdu = ncdu --color dark

alias rm = gomi
alias cp = cp -ri
alias ln = ln -i
alias mv = mv -i
alias x = chmod +x

# Search
alias f = fd --hidden --strip-cwd-prefix
alias grep = rg
alias rg = rg --ignore-file ~/.config/fd/ignore
alias s = rg --ignore-file ~/.config/fd/ignore
alias ag = ag --smart-case --ignore node_modules

# Editors
alias n = nvim
alias v = nvim
alias vi = nvim
alias vim = nvim
alias h = hx
alias zd = zeditor
alias nano = micro
alias nd = nvim -d -c "set nofoldenable"

# Development
alias g = git
alias lg = lazygit
alias tf = treefmt
alias j = just
alias pc = pre-commit
alias ru = rustup
alias cr = crystal
alias nsp = nix-shell -p

# Viewers
alias 7z = 7zz
alias cat = bat
alias less = bat
alias more = bat
alias m = tldr
alias news = newsboat

# System
alias htop = btop
alias top = btop
alias tp = btop
alias k = pkill -9 -f
alias pkill = pkill -9 -f
alias pgrep = pgrep -f
alias u = topgrade
alias wget = wget2
alias download = get

# Systemd
alias scd = sudo systemctl disable
alias sce = sudo systemctl enable
alias scr = sudo systemctl restart
alias scs = sudo systemctl start
alias sct = sudo systemctl status
alias sck = sudo systemctl stop
alias se = sudoedit
alias sv = sudoedit

# User Systemd
alias scud = systemctl --user disable
alias scue = systemctl --user enable
alias scur = systemctl --user restart
alias scus = systemctl --user start
alias scut = systemctl --user status
alias scuk = systemctl --user stop

# Docker
alias d = docker
alias dc = docker compose
alias dcb = docker compose build
alias dcd = docker compose down
alias dcl = docker compose logs -f
alias dcu = docker compose up -d
alias dex = docker exec -it
alias di = docker images
alias dps = docker ps
alias dpsa = docker ps -a

# Zellij
alias zj = zellij
alias za = zellij attach
alias zl = zellij list-sessions
alias zk = zellij kill-session
alias ze = zellij edit
alias zr = zellij run

# --- Configuration Editing ---
def edit-config [path: path] {
    if not ($path | path exists) { return }
    let dir = ($path | path dirname)
    let file = ($path | path basename)
    cd $dir
    run-external nvim $file
}

alias brootrc = edit-config ~/.dotfiles/broot/conf.toml
alias clifmrc = edit-config ~/.dotfiles/clifm/profiles/default/clifmrc
alias fishrc = edit-config ~/.dotfiles/fish/config.fish
alias ghosttyrc = edit-config ~/.dotfiles/ghostty/config
alias gitrc = edit-config ~/.dotfiles/git/config
alias hxrc = edit-config ~/.dotfiles/helix/config.toml
alias kittyrc = edit-config ~/.dotfiles/kitty/kitty.conf
alias mimerc = edit-config ~/.dotfiles/mimeapps/mimeapps.list
alias navirc = edit-config ~/.dotfiles/navi/config.yaml
alias newsrc = edit-config ~/.dotfiles/newsboat/config
alias nirirc = edit-config ~/.dotfiles/niri/config.kdl
alias nixosrc = edit-config ~/.dotfiles/nixos/configuration.nix
alias nvimrc = edit-config ~/.dotfiles/lazyvim/init.lua
alias qutebrowserrc = edit-config ~/.dotfiles/qutebrowser/config.py
alias sshrc = edit-config ~/.dotfiles/ssh/config
alias starshiprc = edit-config ~/.dotfiles/starship/starship.toml
alias tldrrc = edit-config ~/.dotfiles/tealdeer/config.toml
alias topgraderc = edit-config ~/.dotfiles/topgrade/topgrade.toml
alias tvrc = edit-config ~/.dotfiles/television/config.toml
alias xplrrc = edit-config ~/.dotfiles/xplr/init.lua
alias yazirc = edit-config ~/.dotfiles/yazi/yazi.toml
alias zdrc = edit-config ~/.dotfiles/zed/settings.json
alias zellijrc = edit-config ~/.dotfiles/zellij/config.kdl
