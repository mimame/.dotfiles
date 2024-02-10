if status --is-interactive

    if not functions --query fisher; or not test -f ~/.config/fish/fish_plugins
        # Delete all plugins files ignore fail if if they don't exist
        rm -f ~/.config/fish/functions/__abbr*
        rm -f ~/.config/fish/functions/_autopair*
        rm -f ~/.config/fish/functions/fisher.fish
        rm -f ~/.config/fish/functions/fzf_configure_bindings.fish
        rm -f ~/.config/fish/functions/fzf.fish
        rm -f ~/.config/fish/functions/replay.fish
        rm -f ~/.config/fish/functions/__bass.py
        rm -f ~/.config/fish/functions/bass.fish
        rm -fr ~/.config/fish/completions
        rm -fr ~/.config/fish/conf.d
        curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
        wget2 'https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/fish_themes/tokyonight_moon.theme' -O ~/.config/fish/themes/'Tokyonight Moon.theme'
        # Only run the first time
        yes | fish_config theme save "Tokyonight Moon"
        fisher install franciscolourenco/done
        fisher install gazorby/fish-abbreviation-tips
        fisher install jorgebucaran/autopair.fish
        fisher install jorgebucaran/replay.fish
        fisher install edc/bass
        fisher install PatrickF1/fzf.fish
    end

    # Initialize commands
    broot --print-shell-function fish | source
    gh completion --shell fish | source
    starship init fish | source
    thefuck --alias fk | source
    zoxide init fish | source
    mise activate fish | source

    if command -q direnv
        direnv hook fish | source
    end

    # Start ssh agent by default
    if test -z "$SSH_AUTH_SOCK"
        eval (ssh-agent -c) >/dev/null
    end

    # Download wezterm terminfo automatically
    if not test -f ~/.terminfo/w/wezterm
        set tempfile $(mktemp) \
            && curl -o $tempfile https://raw.githubusercontent.com/wez/wezterm/main/termwiz/data/wezterm.terminfo \
            && tic -x -o ~/.terminfo $tempfile \
            && sudo tic -x -o /usr/share/terminfo $tempfile \
            && rm $tempfile
    end

    # Install vscode fonts for broot
    set vscode_font ~/.local/share/fonts/vscode.ttf
    if not test -f $vscode_font
        mkdir -p ~/.local/share/fonts/
        wget2 'https://github.com/Canop/broot/blob/master/resources/icons/vscode/vscode.ttf?raw=true' -O $vscode_font --quiet
        fc-cache ~/.local/share/fonts/
    end

    set bat_theme "$(bat --config-dir)/themes/Enki-Tokyo-Night.tmTheme"
    if not test -f $bat_theme
        mkdir -p "$(bat --config-dir)/themes/"
        wget2 https://raw.githubusercontent.com/enkia/enki-theme/master/scheme/Enki-Tokyo-Night.tmTheme -O $bat_theme --quiet
        bat cache --build
    end

    set wallpaper ~/Pictures/unicat.png
    if not test -f $wallpaper
        mkdir -p ~/Pictures
        wget2 https://github.com/zhichaoh/catppuccin-wallpapers/raw/main/minimalistic/unicat.png -O $wallpaper --quiet
    end

    source ~/.config/fish/variables.fish
    source ~/.config/fish/abbr.fish

    if test -f ~/.config/fish/nnn.fish
        source ~/.config/fish/nnn.fish
    end

    # set aws_local ~/.bin/awslocal
    # if not command -q awslocal
    #     wget2 https://raw.githubusercontent.com/localstack/awscli-local/master/bin/awslocal -O $aws_local
    #     chmod 755 $aws_local
    # end

    # Reinstall systemd user services broken by NixOS updates
    # There is not lsb_release in Darwin
    if not test $(uname) = Darwin
        set system $(lsb_release -i | cut -f2)
        if test $system = NixOS
            fix_broken_services_by_nixos
        end
    end

    eval (zellij setup --generate-auto-start fish | string collect)
end
