# Translate text using 'trans' and return the result
# If no arguments provided, uses pipeline input.
# Copies the result to the clipboard automatically.
def t [
    ...text: string    # Text to translate
    --lang (-l): string = ":es" # Language specification (e.g., ":en" or "en:fr")
] {
    if (which trans | is-empty) {
        return (error make { msg: "Error: 'trans' (Translate Shell) is not installed." })
    }

    # Handle language specification if provided as first argument
    let has_lang_spec = ($text | is-not-empty and ($text | first | str contains ":"))
    let final_lang = if $has_lang_spec { $text | first } else { $lang }
    let query = if $has_lang_spec { $text | skip 1 | str join " " } else { $text | str join " " }

    # If query is still empty, try pipeline input
    let final_query = if ($query | is-empty) { $in | into string } else { $query }

    if ($final_query | is-empty) {
        return (error make { msg: "Usage: t <text...> or pipeline input" })
    }

    let translation = (run-external trans "-brief" "-no-ansi" $final_lang $final_query | str trim)

    if ($translation | is-not-empty) {
        $translation | cb
        return $translation
    } else {
        return (error make { msg: "❌ Translation failed." })
    }
}

alias te = t
