# Open files or directories with the default system application
# If no targets are provided, opens current directory using 'y' or system opener.
# Returns a table of opened items and their status.
def o [
    ...targets: string # List of files, directories, or URIs to open
] {
    let is_darwin = ($nu.os-info.name == "macos")
    let has_gio = (which gio | is-not-empty)
    let has_xdg = (which xdg-open | is-not-empty)

    let opener = if $is_darwin {
        "open"
    } else if $has_gio {
        "gio open"
    } else if $has_xdg {
        "xdg-open"
    } else {
        null
    }

    if $opener == null {
        return (error make { msg: "No system opener found (gio, open, or xdg-open)" })
    }

    # Handle empty case (default to current directory)
    if ($targets | is-empty) {
        if (which y | is-not-empty) {
            y .
        } else {
            run-external ...($opener | split row " ") "."
        }
        return
    }

    # Process multiple targets and return as a table
    $targets | each { |target|
        let exists = ($target | path exists)
        let is_uri = ($target | str starts-with "http")

        if $exists or $is_uri {
            run-external ...($opener | split row " ") $target
            { target: $target, status: "opened" }
        } else {
            { target: $target, status: "error: not found" }
        }
    }
}
