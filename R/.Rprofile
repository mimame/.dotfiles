## Objects
# Return estimation of object size with human format
size = function(object) {
  print(object.size(object), units='auto')
}

## Dataframes
# Show columns with their position number
columns <- function(df) {
  matrix(names(df))
}

# head + tail
ht = function(df, rows=5) {
  rbind(head(df, rows),tail(df, rows))
}

# head rows + head columns
hh = function(df, elements=5) {
  columns <- elements
  if (columns > ncol(df)) {
    columns <- ncol(df)
  }
  df[1:rows, 1:columns]
}

# Search string in any column and add their index
g <- function(df, search, ignore.case = TRUE, perl = FALSE, fixed = FALSE) {
  searched_index <- unique(unlist(apply(df, 2, function(column){grep(search, column, ignore.case, perl, fixed)})))
  # explicitly convert to dataframe to use index
  # tibble doesn't let to use colnames
  searched_df <- as.data.frame(df[searched_index, ])
  row.names(searched_df) <- searched_index
  return(searched_df)
}

## Options
# URLs of the repositories for use by update.packages.
# Defaults to c(CRAN="@CRAN@"), a value that causes some utilities to prompt for a CRAN mirror
options("repos" = c(CRAN = "http://cran.rstudio.com/"))

# Used in install.packages as default for the number of cpus to use in a potentially parallel installation
options("Ncpus" = 4)

## radian (interactive console) options
options(
    # see https://help.farbox.com/pygments.html
    # for a list of supported color schemes, default scheme is "native"
    radian.color_scheme = "monokai",

    # either  `"emacs"` (default) or `"vi"`.
    radian.editing_mode = "vi",

    # indent continuation lines
    # turn this off if you want to copy code without the extra indentation;
    # but it leads to less elegent layout
    radian.indent_lines = TRUE,

    # auto match brackets and quotes
    radian.auto_match = TRUE,

    # auto indentation for new line and curly braces
    radian.auto_indentation = TRUE,
    radian.tab_size = 2,

    # pop up completion while typing
    radian.complete_while_typing = TRUE,
    # timeout in seconds to cancel completion if it takes too long
    # set it to 0 to disable it
    radian.completion_timeout = 0.05,

    # automatically adjust R buffer size based on terminal width
    radian.auto_width = TRUE,

    # insert new line between prompts
    radian.insert_new_line = TRUE,

    # when using history search (ctrl-r/ctrl-s in emacs mode), do not show duplicate results
    radian.history_search_no_duplicates = TRUE,

    # custom prompt for different modes
    radian.prompt = "\033[0;34mr$>\033[0m ",
    radian.shell_prompt = "\033[0;31m#!>\033[0m ",
    radian.browse_prompt = "\033[0;33mBrowse[{}]>\033[0m ",

    # supress the loading message for reticulate
    radian.suppress_reticulate_message = FALSE,
    # enable reticulate prompt and trigger `~`
    radian.enable_reticulate_prompt = TRUE
)
