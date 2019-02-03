## Objects
# Return estimation of object size with human format
size = function(object) {
  print(object.size(object), units='auto')
}

## Dataframes
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

