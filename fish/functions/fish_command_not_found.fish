function fish_command_not_found --description "Handler for when a command is not found"
    set -l cmd $argv[1]

    # 1. Use system's command-not-found if available (Ubuntu, NixOS, etc.)
    # This is usually the most accurate way to find missing packages on Linux.
    if command -q command-not-found
        command-not-found $argv
        return
    end

    # 2. Call default Fish handler for standard error reporting
    __fish_default_command_not_found_handler $argv

    # 3. Provide intelligent hints
    echo "" >&2

    # Suggest 'fk' (pay-respects) for typos first
    if functions -q fk
        echo "💡 Tip: Type 'fk' to fix the typo with pay-respects" >&2
    else if test (uname) = Darwin; and command -q brew
        # Fallback to brew search on macOS if pay-respects isn't available
        echo "💡 Tip: Search for it with 'brew search $cmd'" >&2
    end
end
