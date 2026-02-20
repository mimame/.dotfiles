# Nushell Environment Config File
#
# version = "0.110.0"

# --- Platform Identification ---
$env.IS_DARWIN = ($nu.os-info.name == "macos")
$env.IS_LINUX = ($nu.os-info.name == "linux")
$env.IS_NIXOS = ($env.IS_LINUX and ("/etc/os-release" | path exists) and (open /etc/os-release | str contains "ID=nixos"))

# --- Core Variables ---
$env.default_nvim = "nvim"
$env.EDITOR = "nvim"
$env.VISUAL = $env.EDITOR
$env.GIT_EDITOR = $env.EDITOR
$env.BROWSER = "firefox"
$env.JULIA_NUM_THREADS = 8
$env.TMPDIR = "/tmp"
$env.RIPGREP_CONFIG_PATH = ($env.HOME | path join ".config" "ripgrep" "ripgreprc")
$env.PAGER = "bat --wrap auto"
$env.MANPAGER = "bat --strip-ansi=auto -l man -p"
$env.XDG_CONFIG_HOME = ($env.HOME | path join ".config")
$env.PIP_USER = false
$env.VAGRANT_DEFAULT_PROVIDER = "libvirt"
$env.TZ_LIST = "CET,Central European Time;UTC,Coordinated Universal Time;US/Eastern,Eastern Standard Time;US/Pacific,Pacific Standard Time;Asia/Singapore, Singapore;Mexico/General"

# Input method
$env.GTK_IM_MODULE = "ibus"
$env.QT_IM_MODULE = "ibus"
$env.XMODIFIERS = "@im=ibus"

# --- Path Configuration ---
def get-path [] {
    mut paths = [
        ($env.HOME | path join ".yarn" "bin")
        ($env.HOME | path join ".bin")
        ($env.HOME | path join "go" "bin")
        ($env.HOME | path join ".cargo" "bin")
        ($env.HOME | path join ".rustup" "toolchains" "stable-x86_64-unknown-linux-gnu" "bin")
        ($env.HOME | path join ".local" "bin")
        ($env.HOME | path join ".local" "share" "coursier" "bin")
    ]

    # Homebrew (macOS/Linux)
    let brew_bin = ([ "/opt/homebrew/bin/brew" "/usr/local/bin/brew" ] | where {|p| $p | path exists} | first | default null)
    if $brew_bin != null {
        let brew_prefix = (run-external $brew_bin "--prefix" | str trim)
        $paths = ($paths | append [
            ($brew_prefix | path join "bin")
            ($brew_prefix | path join "sbin")
        ])

        # Language-specific Homebrew paths
        for lang in [ "ruby" "python" ] {
            let lang_path = ($brew_prefix | path join "opt" $lang "bin")
            if ($lang_path | path exists) {
                $paths = ($paths | append $lang_path)
            }
        }
    }

    # Ruby Gem paths (if ruby exists)
    if (which ruby | is-not-empty) {
        let user_dir = (run-external ruby "-e" "print Gem.user_dir" | str trim | path join "bin")
        let bindir = (run-external ruby "-e" "print Gem.bindir" | str trim)
        $paths = ($paths | append [ $user_dir $bindir ])
    }

    $paths | where {|p| $p | path exists}
}

$env.PATH = ($env.PATH | split row (char esep) | prepend (get-path) | uniq)

# --- Tool Themes (Dracula) ---
$env.BAT_THEME = "Dracula"
if (which vivid | is-not-empty) {
    $env.LS_COLORS = (vivid generate dracula | str trim)
    $env.EZA_COLORS = $env.LS_COLORS
}

# FZF (Dracula)
$env.FZF_DEFAULT_COMMAND = 'fd --type file --exclude node_modules'
$env.FZF_CTRL_T_COMMAND = $env.FZF_DEFAULT_COMMAND
$env.FZF_CTRL_T_OPTS = "--height 100% --preview 'bat --color always {}'"
$env.FZF_ALT_C_COMMAND = 'fd --type directory --exclude node_modules'
$env.FZF_ALT_C_OPTS = "--height 100% --preview br --preview-window wrap"
$env.FZF_DEFAULT_OPTS = "
--reverse
--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9
--color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9
--color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6
--color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4
--bind 'tab:down,shift-tab:up,change:top,ctrl-j:toggle+down,ctrl-k:toggle+up,ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:top,ctrl-o:execute($env.EDITOR {} < /dev/tty > /dev/tty 2>&1)+abort'
"

# GPG TTY
if ($nu.is-interactive) {
    $env.GPG_TTY = (tty | str trim)
}

# --- Shell Integrations ---

# Ensure cache directories exist
let cache_dir = ($env.HOME | path join ".cache" "nushell")
if not ($cache_dir | path exists) { mkdir $cache_dir }

# Starship
let starship_cache = ($cache_dir | path join "starship" "init.nu")
if not ($starship_cache | path exists) {
    mkdir ($starship_cache | path dirname)
    starship init nu | save -f $starship_cache
}

# Zoxide
let zoxide_cache = ($cache_dir | path join "zoxide" "init.nu")
if not ($zoxide_cache | path exists) {
    mkdir ($zoxide_cache | path dirname)
    zoxide init nushell | save -f $zoxide_cache
}

# Atuin
let atuin_cache = ($cache_dir | path join "atuin" "init.nu")
if not ($atuin_cache | path exists) {
    mkdir ($atuin_cache | path dirname)
    atuin init nu | save -f $atuin_cache
}

# Navi
let navi_cache = ($cache_dir | path join "navi" "init.nu")
if not ($navi_cache | path exists) {
    mkdir ($navi_cache | path dirname)
    if (which navi | is-not-empty) {
        navi widget nushell | save -f $navi_cache
    } else {
        touch $navi_cache
    }
}

# Pay-respects (fk)
let fk_cache = ($cache_dir | path join "pay-respects" "init.nu")
if not ($fk_cache | path exists) {
    mkdir ($fk_cache | path dirname)
    if (which pay-respects | is-not-empty) {
        pay-respects nushell --alias fk | save -f $fk_cache
    } else {
        touch $fk_cache
    }
}

# --- Prompt Indicators ---
$env.PROMPT_INDICATOR = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

# Environment conversions
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

# --- SSH Agent (via Keychain) ---
# ARCHITECTURE:
# We source the 'sh' script generated by keychain and parse it for Nushell.
# This ensures we share the same agent as Fish and other shells.
let keychain_file = ($env.HOME | path join ".keychain" $"((sys host).hostname)-sh")
if ($keychain_file | path exists) {
    let agent_vars = (open $keychain_file
        | lines
        | where { $in | str starts-with "SSH_" }
        | each { |line|
            let parts = ($line | split row ";") | first | split row "="
            let key = ($parts | first | str trim)
            let value = ($parts | last | str trim | str replace -a '"' "")
            { $key: $value }
        }
        | reduce { |it, acc| $acc | merge $it }
    )
    load-env $agent_vars
}
