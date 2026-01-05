function git_cd --description "Commit with a journal-style date stamp"
    # Ensure we are in a git repository
    if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo "Error: Not a git repository" >&2
        return 1
    end

    # Generate today's stamp: YY.MM.DD.dd (e.g., 26.01.05.Mo)
    # We use LC_ALL=C to ensure stable day abbreviations regardless of system locale
    set -l today_date_ymd (date +%y.%m.%d)
    set -l day_abbr (LC_ALL=C date +%a | string sub -l 2)
    set -l today_stamp "$today_date_ymd.$day_abbr"

    # Get the last commit message (subject line)
    set -l last_msg (git log -1 --format=%s 2>/dev/null)

    # Define regex for any date stamp pattern (YY.MM.DD.dd)
    set -l stamp_regex '^\d{2}\.\d{2}\.\d{2}\.[A-Za-z]{2}'

    if string match -qr "^$today_stamp" -- "$last_msg"
        # Case 1: Last commit starts with today's stamp.
        # Amend without changing the message.
        git commit --amend --no-edit
    else
        # Case 2: Last commit is either from an older date stamp or has no stamp.
        # Create a new commit with today's date stamp as the message.
        git commit -m "$today_stamp"
    end
end
