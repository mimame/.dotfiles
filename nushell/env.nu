# Nushell Environment Config File
#
# version = "0.87.0"

def create_left_prompt [] {
    mut home = ""
    try {
        if $nu.os-info.name == "windows" {
            $home = $env.USERPROFILE
        } else {
            $home = $env.HOME
        }
    }

    let dir = ([
        ($env.PWD | str substring 0..($home | str length) | str replace $home "~"),
        ($env.PWD | str substring ($home | str length)..)
    ] | str join)

    let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
    let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
    let path_segment = $"($path_color)($dir)"

    $path_segment | str replace --all (char path_sep) $"($separator_color)/($path_color)"
}

def create_right_prompt [] {
    # create a right prompt in magenta with green separators and am/pm underlined
    let time_segment = ([
        (ansi reset)
        (ansi magenta)
        (date now | format date '%Y/%m/%d %r')
    ] | str join | str replace --regex --all "([/:])" $"(ansi green)${1}(ansi magenta)" |
        str replace --regex --all "([AP]M)" $"(ansi magenta_underline)${1}")

    let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
        (ansi rb)
        ($env.LAST_EXIT_CODE)
    ] | str join)
    } else { "" }

    ([$last_exit_code, (char space), $time_segment] | str join)
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = {|| create_left_prompt }
# $env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
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

# Directories to search for scripts when calling source or use
$env.NU_LIB_DIRS = [
    # ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
]

# Directories to search for plugin binaries when calling register
$env.NU_PLUGIN_DIRS = [
    # ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# $env.PATH = ($env.PATH | split row (char esep) | prepend '/some/path')
$env.PATH = ($env.PATH | split row (char esep) | prepend "$HOME/.yarn/bin")
$env.PATH = ($env.PATH | split row (char esep) | prepend "$HOME/.bin")
$env.PATH = ($env.PATH | split row (char esep) | prepend "$HOME/go/bin")
$env.PATH = ($env.PATH | split row (char esep) | prepend "$HOME/.cargo/bin")
$env.PATH = ($env.PATH | split row (char esep) | prepend "$HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin")
$env.PATH = ($env.PATH | split row (char esep) | prepend "$HOME/.local/coursier/bin")
$env.PATH = ($env.PATH | split row (char esep) | prepend "$HOME/.local/bin")

$env.GTK_IM_MODULE = ibus
$env.QT_IM_MODULE = ibus
$env.XMODIFIERS = @im=ibus

$env.THEFUCK_EXCLUDE_RULES = fix_file # Fix https://github.com/nvbn/thefuck/issues/1153

$env.LS_COLORS = (vivid generate ~/.config/vivid/tokyonight_moon.yml)
$env.EZA_COLORS = (vivid generate ~/.config/vivid/tokyonight_moon.yml)

# Setting fd as the default source for fzf
$env.FZF_DEFAULT_COMMAND = 'fd --type file --exclude node_modules'
# To apply the command to CTRL-T as well
$env.FZF_CTRL_T_COMMAND = "$FZF_DEFAULT_COMMAND"
$env.FZF_CTRL_T_OPTS = "--height 100% --preview 'bat --color always {}'"
# To apply the command to ALT_C
$env.FZF_ALT_C_COMMAND = 'fd --type directory --exclude node_modules'
$env.FZF_ALT_C_OPTS = "--height 100% --preview br --preview-window wrap"
# Tokyonight colors by default
# https://github.com/junegunn/fzf/issues/1593#issuecomment-498007983
$env.FZF_DEFAULT_OPTS = '
--reverse
--color=fg:#c5cdd9,bg:#1e2030,hl:#6cb6eb
--color=fg+:#c5cdd9,bg+:#1e2030,hl+:#5dbbc1
--color=info:#88909f,prompt:#ec7279,pointer:#d38aea
--color=marker:#a0c980,spinner:#ec7279,header:#5dbbc1
--bind "tab:down,shift-tab:up,change:top,ctrl-j:toggle+down,ctrl-k:toggle+up,ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:top,ctrl-o:execute($EDITOR {} < /dev/tty > /dev/tty 2>&1)+abort"
'

$env.BAT_THEME = "Enki-Tokyo-Night"
$env.MOAR = '--statusbar=bold --no-linenumbers'
$env.MANPAGER = "sh -c 'col -bx | bat -l man -p'"
$env.BROWSER = floorp
$env.JULIA_NUM_THREADS = 8
$env.TMPDIR = /tmp
$env.TERMINAL = wezterm

$env.PAGER = 'moar --wrap'
$env.EDITOR = lvim
$env.VISUAL = $env.EDITOR

$env.TZ_LIST = "CET,Central European Time;UTC,Coordinated Universal Time;US/Eastern,Eastern Standard Time;US/Pacific,Pacific Standard Time;Asia/Singapore, Singapore;Mexico/General"


# Never use user Python pip by default
# pre-commit is broken with this
$env.PIP_USER = false

# SSH agent
do --env {
    let ssh_agent_file = (
        $nu.temp-path | path join $"ssh-agent-($env.USER? | default $env.USERNAME).nuon"
    )

    if ($ssh_agent_file | path exists) {
        let ssh_agent_env = open ($ssh_agent_file)
        if ($"/proc/($ssh_agent_env.SSH_AGENT_PID)" | path exists) {
            load-env $ssh_agent_env
            return
        } else {
            rm $ssh_agent_file
        }
    }

    let ssh_agent_env = ^ssh-agent -c
        | lines
        | first 2
        | parse "setenv {name} {value};"
        | transpose --header-row
        | into record
    load-env $ssh_agent_env
    $ssh_agent_env | save --force $ssh_agent_file
}

# Generate starship prompt
mkdir ~/.cache/nushell/starship
starship init nu | save -f ~/.cache/nushell/starship/init.nu

# Generate zoxide source
mkdir ~/.cache/nushell/zoxide
zoxide init nushell | save -f ~/.cache/nushell/zoxide/init.nu

# Generate carapace source
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu
