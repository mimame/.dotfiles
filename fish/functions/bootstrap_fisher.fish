function bootstrap_fisher
    echo "⚡ Bootstrapping Fish shell environment..."

    clean_old_plugins

    # 1. Install Fisher
    set -l fisher_url 'https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish'
    set -l fisher_path ~/.config/fish/functions/fisher.fish
    mkdir -p (dirname $fisher_path)

    if functions -q get
        get $fisher_url - >$fisher_path
    else
        curl -sL $fisher_url -o $fisher_path
    end

    # Source fisher immediately so it's available for the rest of the script
    source $fisher_path

    # 2. Install Plugins
    # We suppress stderr during installation to avoid "Command not found"
    # transient errors while plugins are being partially loaded.
    echo "📥 Installing plugins via Fisher..."
    fisher install \
        jorgebucaran/fisher \
        franciscolourenco/done \
        gazorby/fish-abbreviation-tips \
        jorgebucaran/autopair.fish \
        jorgebucaran/replay.fish \
        edc/bass \
        dracula/fish \
        PatrickF1/fzf.fish 2>/dev/null

    # 3. Set Theme
    echo "🎨 Configuring theme..."
    yes | fish_config theme choose 'Dracula Official' 2>/dev/null
    yes | fish_config theme save 'Dracula Official' 2>/dev/null

    # 4. Finalize
    # We clear the functions and re-source everything to ensure a clean state.
    echo "🔄 Refreshing environment..."
    set -p fish_function_path ~/.config/fish/functions
    source ~/.config/fish/config.fish

    echo "✅ Bootstrapping complete!"
end
