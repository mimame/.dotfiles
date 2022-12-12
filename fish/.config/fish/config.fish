if status --is-interactive

    if not functions --query fisher
        curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
        fisher install jorgebucaran/replay.fish
        fisher install franciscolourenco/done
        fisher install jorgebucaran/autopair.fish
        fisher install gazorby/fish-abbreviation-tips
        fisher install jorgebucaran/replay.fish
    end

    # This doesn't work with NixOS
    # because for each updated binary the hash path is different
    # Speed up source commands using functions files and regenerating them one time per week
    #if not test -f ~/.config/fish/functions/fk.fish
    #    or test (date '+%s' --date '7 days ago') -ge (date '+%s' -r ~/.config/fish/functions/fk.fish)
    #    thefuck --alias fk >~/.config/fish/functions/fk.fish
    #    gh completion --shell fish >~/.config/fish/functions/gh.fish
    #    zoxide init fish >~/.config/fish/functions/z.fish
    #    starship init fish --print-full-init >~/.config/fish/functions/fish_prompt.fish
    # end

    starship init fish | source
    zoxide init fish | source
    gh completion --shell fish | source
    thefuck --alias fk | source
    broot --print-shell-function fish | source

    if not functions --query __direnv_export_eval
        direnv hook fish | source
    end

    # Start ssh agent by default
    if test -z "$SSH_AUTH_SOCK"
        eval (ssh-agent -c) >/dev/null
    end

    # Install vscode fonts for broot
    set vscode_font ~/.local/share/fonts/vscode.ttf
    if not test -f $vscode_font
      wget 'https://github.com/Canop/broot/blob/master/resources/icons/vscode/vscode.ttf?raw=true' -O $vscode_font --quiet
      fc-cache ~/.local/share/fonts/
    end

    source ~/.config/fish/variables.fish
    source ~/.config/fish/abbr.fish
    source ~/.config/fish/monokai.fish
end
