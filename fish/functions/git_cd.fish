# Commit with a date stamp, intended for use as a git alias.
# - If the last commit message starts with today's date stamp (e.g., 25.09.26.Fr), it amends the commit.
# - If the last commit message starts with a different date stamp, it creates a new commit,
#   replacing the old date stamp with today's and preserving the rest of the message.
# - If the last commit message has no date stamp, it amends the commit by prepending today's date stamp.
function git_cd
    set -l today_date_ymd (date +%y.%m.%d)
    set -l today_stamp (date +%y.%m.%d).(date +%a | string sub -l 2)

    set -l last_commit_date_ymd (git log -1 --format=%cd --date=format:%y.%m.%d)

    if test "$last_commit_date_ymd" = "$today_date_ymd"
        # Case 1: Last commit is from today's date.
        # Amend without changing the message.
        git commit --amend --no-edit
    else
        # Case 2: Last commit is from an older date.
        # Create a new commit with just today's date stamp as the message.
        git commit -m "$today_stamp"
    end
end
