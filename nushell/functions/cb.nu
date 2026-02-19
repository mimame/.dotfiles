# Universal clipboard utility for macOS and Linux
#
# Usage:
#   cb "hello"    # Copy text
#   cb file.txt   # Copy file content
#   "hello" | cb  # Copy from pipeline
#   cb            # Paste and return content
def cb [
    input?: any        # Text or file path to copy. If null, uses pipeline input.
] {
    let is_darwin = ($nu.os-info.name == "macos")
    let has_wl = (which wl-copy | is-not-empty)
    let has_xclip = (which xclip | is-not-empty)
    let has_xsel = (which xsel | is-not-empty)

    let copy_cmd = if $is_darwin { "pbcopy" } else if $has_wl { "wl-copy" } else if $has_xclip { "xclip -selection clipboard" } else if $has_xsel { "xsel --clipboard --input" } else { null }
    let paste_cmd = if $is_darwin { "pbpaste" } else if $has_wl { "wl-paste -n" } else if $has_xclip { "xclip -selection clipboard -o" } else if $has_xsel { "xsel --clipboard --output" } else { null }

    # Capture pipeline input early to avoid it being lost
    let pipe_input = $in

    # PASTE CASE: No input provided and no pipeline input
    if ($input == null) and ($pipe_input == null) {
        if $paste_cmd == null { return (error make {msg: "No clipboard tool found"}) }
        return (run-external ...($paste_cmd | split row " ") | str trim)
    }

    # COPY CASE
    let raw_input = if $input != null { $input } else { $pipe_input }

    # Handle file paths vs strings
    let is_file = if ($raw_input | into string | path exists) {
        ($raw_input | into string | path type) == "file"
    } else {
        false
    }

    let content = if $is_file {
        open --raw ($raw_input | into string) | decode utf-8
    } else {
        $raw_input | into string
    }

    if $copy_cmd == null { return (error make {msg: "No clipboard tool found"}) }
    $content | run-external ...($copy_cmd | split row " ")
}
