function bootstrap_fisher
    echo "⚡ Bootstrapping Fish shell environment..."

    clean_old_plugins

    # Install Fisher
    if functions -q get
        get 'https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish' - | source
    else
        curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
    end

    fisher install jorgebucaran/fisher

    # Install Plugins
    fisher install \
        franciscolourenco/done \
        gazorby/fish-abbreviation-tips \
        jorgebucaran/autopair.fish \
        jorgebucaran/replay.fish \
        edc/bass \
        dracula/fish \
        PatrickF1/fzf.fish

    # Set Theme
    yes | fish_config theme choose 'Dracula Official'
    yes | fish_config theme save 'Dracula Official'
end
