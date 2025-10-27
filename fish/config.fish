status is-interactive; or exit

# Function to clean up old plugin files
function _clean_old_plugins
    rm -rf "~/.config/fish/functions/__abbr*" \
        "~/.config/fish/functions/_autopair*" \
        "~/.config/fish/functions/_fzf_*.fish" \
        ~/.config/fish/functions/replay.fish \
        ~/.config/fish/functions/__bass.py \
        ~/.config/fish/functions/bass.fish \
        "~/.config/fish/themes/*.theme" \
        ~/.config/fish/completions \
        ~/.config/fish/conf.d \
        ~/.config/fish/functions/fisher.fish \
        ~/.config/fish/functions/fzf_configure_bindings.fish \
        ~/.config/fish/functions/fzf.fish
end

# Check if Fisher function file is missing, then clean and reinstall plugins
if not test -f ~/.config/fish/functions/fisher.fish
    _clean_old_plugins
    # Install Fisher and plugins
    wget2 -q -O- https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
    fisher install jorgebucaran/fisher
    fisher install franciscolourenco/done \
        gazorby/fish-abbreviation-tips \
        jorgebucaran/autopair.fish \
        jorgebucaran/replay.fish \
        edc/bass \
        dracula/fish \
        PatrickF1/fzf.fish

    yes | fish_config theme choose 'Dracula Official'
    yes | fish_config theme save 'Dracula Official'
end

# Initialize direnv if available
if command -q direnv
    direnv hook fish | source
end

# SSH agent managed by NixOS programs.ssh.startAgent
keychain --eval --quiet $HOME/.ssh/id_ed25519 | source

function _download --argument url path
    mkdir -p (dirname $path)
    wget2 -q -O $path $url
end

# Download wezterm terminfo if not present
if test $TERM = wezterm -a not infocmp wezterm >/dev/null 2>&1
    set terminfo_tempfile (mktemp)
    _download 'https://raw.githubusercontent.com/wez/wezterm/main/termwiz/data/wezterm.terminfo' $terminfo_tempfile
    tic -x -o ~/.terminfo $terminfo_tempfile
    sudo tic -x -o /usr/share/terminfo $terminfo_tempfile
    rm $terminfo_tempfile
end

# Install VSCode font for broot if not present
set vscode_font_path ~/.local/share/fonts/vscode.ttf
if not test -f $vscode_font_path
    _download 'https://github.com/Canop/broot/blob/master/resources/icons/vscode/vscode.ttf?raw=true' $vscode_font_path
    fc-cache (dirname $vscode_font_path)
end

# Download and set btop theme if not present
set btop_theme_path ~/.config/btop/themes/dracula
if not test -f $btop_theme_path
    _download 'https://raw.githubusercontent.com/dracula/bashtop/refs/heads/master/dracula.theme' $btop_theme_path
end

set rofi_theme_path ~/.config/rofi/dracula.rasi
if not test -f $rofi_theme_path
    _download 'https://raw.githubusercontent.com/dracula/rofi/refs/heads/main/theme/config1.rasi' $rofi_theme_path
end

# Download and set kitty theme if not present
set kitty_theme_path ~/.config/kitty/current-theme.conf
if not test -f $kitty_theme_path
    kitty +kitten themes Dracula
end

if not fd --quiet --type f tmtheme.xml ~/.local/state/yazi/packages/
    ya pkg upgrade
end

# Source custom Fish scripts
source ~/.config/fish/variables.fish
source ~/.config/fish/abbr.fish

# Start pueued daemon if not running
if not pgrep -x pueued >/dev/null
    pueued --daemonize >/dev/null
end

# Reinstall systemd user services broken by NixOS updates
if test (uname) != Darwin
    if test (lsb_release -i | cut -f2) = NixOS
        any-nix-shell fish --info-right | source
        fix_broken_services_by_nixos
    end
end

# Define a custom command-not-found handler
function fish_command_not_found
    if command -q command-not-found
        command-not-found $argv
    else
        echo "command not found: $argv"
    end
end

# Zellij setup
# if test $TERM != xterm-kitty -a $TERM != xterm-ghostty
#     eval (zellij setup --generate-auto-start fish | string collect)
# end

starship init fish | source
zoxide init fish | source
pay-respects fish --alias fk | source

gh completion --shell fish | source
jj util completion fish | source
#mise activate fish | source

# Setup Carapace for enhanced shell completions
# Temporarily disabled due to issues with ssh and git checkout completions.
# The default fish completions are working correctly.
# CARAPACE_BRIDGES enables completion bridging from other shells (zsh, fish, bash, inshellisense)
# set -Ux CARAPACE_BRIDGES 'zsh,fish,bash,inshellisense' # optional
# carapace _carapace | source

# Trigger the deferred loading functions on first prompt
emit fish_prompt
