# sh -c "$(curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs)"
# https://github.com/jarun/nnn/wiki/Usage#configuration
set -x NNN_OPTS H
set -x NNN_TRASH 1
# set NNN_ARCHIVE "\\.(7z|bz2|gz|tar|tgz|zip|zst)$"

# https://github.com/catppuccin/catppuccin/issues/150
# # The first option is a translation of the catppuccin colors to their closest match in a 256 color scheme (dependency free)
# BLK="E5" CHR="E5" DIR="99" EXE="97" REG="07" HARDLINK="E1" SYMLINK="E1" MISSING="08" ORPHAN="D3" FIFO="9F" SOCK="E5" UNKNOWN="D3"

# # Export Context Colors
# export NNN_COLORS="#9997E5D3;4231"

# This second option relies on you're terminal using the catppuccin theme and well use true catppuccin colors:
set BLK 03
set CHR 03
set DIR 04
set EXE 02
set REG 07
set HARDLINK 05
set SYMLINK 05
set MISSING 08
set ORPHAN 01
set FIFO 06
set SOCK 03
set UNKNOWN 01

# Export Context Colors
set -x NNN_COLORS "#04020301;4231"

# Finally Export the set file colors ( Both options require this)
set -x NNN_FCOLORS "$BLK$CHR$DIR$EXE$REG$HARDLINK$SYMLINK$MISSING$ORPHAN$FIFO$SOCK$UNKNOWN"

# https://github.com/jarun/nnn/blob/master/plugins/README.md
set -x NNN_PLUG 'f:finder;o:fzopen;p:mocq;d:diffs;t:nmount;v:imgview;z:autojump;w:dragdrop;u:getplugsk'
