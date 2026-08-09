function fish_command_not_found --description "Handler for when a command is not found"
    set -l cmd $argv[1]

    # Delegate to nix-index's command-not-found handler (NixOS) so the
    # nix-locate package suggestion keeps working. fish 3.2+ calls this
    # function directly and does not emit the fish_command_not_found event.
    if functions -q __fish_command_not_found_handler
        __fish_command_not_found_handler $argv
    else
        __fish_default_command_not_found_handler $argv
    end

    echo "" >&2

    # Suggest 'fk' (pay-respects) for typos first
    if functions -q fk
        echo "💡 Tip: Type 'fk' to fix the typo with pay-respects" >&2
    else if $IS_DARWIN; and command -q brew
        # Fallback to brew search on macOS if pay-respects isn't available
        echo "💡 Tip: Search for it with 'brew search $cmd'" >&2
    end
end
