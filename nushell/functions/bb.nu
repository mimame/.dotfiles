# Interactive navigate up the directory tree
def bb [start_path: path = "."] {
    if (which tv | is-empty) {
        print "Error: television is not installed."
        return
    }

    let start_path = ($start_path | path expand)

    mut dirs = []
    mut current = $start_path
    $dirs = ($dirs | append $current)

    while ($current != "/") {
        $current = ($current | path dirname)
        $dirs = ($dirs | append $current)
    }

    let preview_cmd = "eza --all --color=always --sort .name --classify --git --icons {}"
    let final_dir = ($dirs | str join "\n" | tv --preview-command $preview_cmd | str trim)

    if ($final_dir | is-not-empty) and ($final_dir | path exists) {
        cd $final_dir
    }
}
