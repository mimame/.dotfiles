# Handler for when a command is not found.
# This function is autoloaded by Fish when a command is not found.
# It attempts to use the system's `command-not-found` handler if available,
# otherwise falls back to Fish's default handler.

function fish_command_not_found
    if command -q command-not-found
        command-not-found $argv
    else
        __fish_default_command_not_found_handler $argv
    end
end
