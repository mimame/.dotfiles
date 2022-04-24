# https://fishshell.com/docs/current/interactive.html?highlight=vim#syntax-highlighting
# Monokai
set -U fish_color_normal F8F8F2 # the default color
set -U fish_color_command A6E22E --bold --bold # the color for commands
set -U fish_color_quote E6DB74 # the color for quoted blocks of text
set -U fish_color_redirection AE81FF # the color for IO redirections
set -U fish_color_end F8F8F2 # the color for process separators like ';' and '&'
set -U fish_color_error F8F8F2 --background=F92672 # the color used to highlight potential errors
set -U fish_color_param 2986cc # the color for regular command parameters
set -U fish_color_comment 75715E # the color used for code comments
set -U fish_color_match F8F8F2 # the color used to highlight matching parenthesis
set -U fish_color_search_match --background=49483E # the color used to highlight history search matches
set -U fish_color_operator AE81FF # the color for parameter expansion operators like '*' and '~'
set -U fish_color_escape 66D9EF # the color used to highlight character escapes like '\n' and '\x70'
set -U fish_color_cwd 66D9EF # the color used for the current working directory in the default prompt

# Additionally, the following variables are available to change the highlighting in the completion pager:
set -U fish_pager_color_prefix 75715E # the color of the prefix string, i.e. the string that is to be completed
set -U fish_pager_color_completion F8F8F2 # the color of the completion itself
set -U fish_pager_color_description F8F8F2 # the color of the completion description
set -U fish_pager_color_progress 75715E # the color of the progress bar at the bottom left corner
set -U fish_pager_color_secondary 75715E # the background color of the every second completion
