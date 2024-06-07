if status --is-interactive

    # Function to clean up old plugin files
    function clean_old_plugins
        set plugin_files ~/.config/fish/functions/__abbr* \
                         ~/.config/fish/functions/_autopair* \
                         ~/.config/fish/functions/fisher.fish \
                         ~/.config/fish/functions/_fzf_*.fish \
                         ~/.config/fish/functions/fzf_configure_bindings.fish \
                         ~/.config/fish/functions/fzf.fish \
                         ~/.config/fish/functions/replay.fish \
                         ~/.config/fish/functions/__bass.py \
                         ~/.config/fish/functions/bass.fish
        for file in $plugin_files
            rm -f $file
        end
        rm -fr ~/.config/fish/completions ~/.config/fish/conf.d
    end

    # Check if Fisher or plugin file is missing, then clean and reinstall plugins
    if not functions --query fisher; or not test -f ~/.config/fish/fish_plugins
        clean_old_plugins

        # Install Fisher and plugins
        wget2 -q -O- https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
        fisher install jorgebucaran/fisher
        fisher install franciscolourenco/done gazorby/fish-abbreviation-tips jorgebucaran/autopair.fish jorgebucaran/replay.fish edc/bass PatrickF1/fzf.fish

        # Install and set the theme
        wget2 -q 'https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/fish_themes/tokyonight_moon.theme' -O ~/.config/fish/themes/'Tokyonight Moon.theme'
        fish_config theme save "Tokyonight Moon"
    end

    # Initialize various commands and completions
    broot --print-shell-function fish | source
    gh completion --shell fish | source
    starship init fish | source
    thefuck --alias fk | source
    zoxide init fish | source
    mise activate fish | source

    # Initialize direnv if available
    if command -q direnv
        direnv hook fish | source
    end

    # Start ssh-agent if not already running
    if not set -q SSH_AUTH_SOCK
        eval (ssh-agent -c) >/dev/null
    end

    # Download wezterm terminfo if not present
    if not test -f ~/.terminfo/**/wezterm
        set terminfo_tempfile (mktemp)
        wget2 -q -O $terminfo_tempfile https://raw.githubusercontent.com/wez/wezterm/main/termwiz/data/wezterm.terminfo
        tic -x -o ~/.terminfo $terminfo_tempfile
        sudo tic -x -o /usr/share/terminfo $terminfo_tempfile
        rm $terminfo_tempfile
    end

    # Install VSCode font for broot if not present
    set vscode_font_path ~/.local/share/fonts/vscode.ttf
    if not test -f $vscode_font_path
        mkdir -p ~/.local/share/fonts/
        wget2 -q -O $vscode_font_path 'https://github.com/Canop/broot/blob/master/resources/icons/vscode/vscode.ttf?raw=true'
        fc-cache ~/.local/share/fonts/
    end

    # Download and set bat theme if not present
    set bat_theme_path (bat --config-dir)/themes/Enki-Tokyo-Night.tmTheme
    if not test -f $bat_theme_path
        mkdir -p (bat --config-dir)/themes/
        wget2 -q -O $bat_theme_path https://raw.githubusercontent.com/enkia/enki-theme/master/scheme/Enki-Tokyo-Night.tmTheme
        bat cache --build
    end

    # Set wallpaper if not present
    set wallpaper_path ~/Pictures/unicat.png
    if not test -f $wallpaper_path
        mkdir -p ~/Pictures
        wget2 -q -O $wallpaper_path https://github.com/zhichaoh/catppuccin-wallpapers/raw/main/minimalistic/unicat.png
    end

    # Source custom Fish scripts
    source ~/.config/fish/variables.fish
    source ~/.config/fish/abbr.fish

    # Source nnn script if it exists
    if test -f ~/.config/fish/nnn.fish
        source ~/.config/fish/nnn.fish
    end

    # Start pueued daemon if not running
    if not pgrep -x "pueued" >/dev/null
        pueued --daemonize >/dev/null
    end

    # Reinstall systemd user services broken by NixOS updates
    if test (uname) != "Darwin"
        if test (lsb_release -i | cut -f2) = "NixOS"
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
    eval (zellij setup --generate-auto-start fish | string collect)
end
