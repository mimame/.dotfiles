# Helper to install completions lazily
# Usage: install_completion <command_name> <generation_command>
function install_completion --argument name cmd
    set -l comp_file ~/.config/fish/completions/$name.fish
    if not test -f $comp_file
        echo "⚙️  Generating completion for $name..."
        eval $cmd >$comp_file
    end
end
