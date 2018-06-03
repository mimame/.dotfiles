# .dotfiles

<!-- picture here alacritty, nvim, tmux -->

## Motivation

<!-- Personal dotfiles -->

## Description

## Setup

[Stow](https://www.gnu.org/software/stow/)

### Usage

`stow folder`

## Content

### [alacritty (terminal)](https://github.com/jwilm/alacritty) (./alacritty/.config/alacritty)

### [beets (Music organizer)](http://beets.io/) (./beets/.config/beets)

### bin (my own scripts) (./bin/.bin)

### [cmus (TUI music player)](https://cmus.github.io/) (./cmus/.config/cmus)

### [dunst (Replacement for the notification-daemon)](https://dunst-project.org/) (./dunst/.config/dunst)

### [grub (Boot loader)](https://www.gnu.org/software/grub/) (./etc/default/grub)

### [i3 (Tiling windows manager) + my own scripts](https://i3wm.org/) (./i3/.config/i3)

### [kitty (default terminal)](https://sw.kovidgoyal.net/kitty/) (./kitty/.config/kitty)

### [latex](https://www.latex-project.org/) (./latex/)

### [nvim](./nvim/.config/nvim3/init.vim) (./nvim/.config/nvim)

### [parallel](https://www.gnu.org/software/parallel/) (./parallel/.parallel)

### [rofi](https://github.com/DaveDavenport/rofi) (./Xresources)

### [ssh](https://www.openssh.com/) (./ssh/.ssh)

### [termite (terminal)](https://github.com/thestinger/termite) (./termite/.config/termite)

### [tig (TUI git)](https://jonas.github.io/tig/) (./tig/.config/tig)

### [urxvt (terminal)](http://software.schmorp.de/pkg/rxvt-unicode.html) (./Xresources)

### [vifm (TUI filemanager)](https://vifm.info/) (./vifm/.config/vifm)

### [vim](https://www.vim.org/) (./vim)

### [Xresources](https://wiki.archlinux.org/index.php/x_resources) (./Xresources)

### [zsh (Shell)](http://www.zsh.org/) (./zsh)

## Requirements
- [AnyEvent-I3](https://github.com/i3/i3/tree/next/AnyEvent-I3) (./i3/.config/i3/scripts/i3session)
- [aria2c](https://github.com/aria2/aria2) (./zsh/.zshrc)
- [axel](https://github.com/axel-download-accelerator/axel) (./zsh/.zshrc)
- [curl](https://github.com/curl/curl) (./zsh/.zshrc)
- [diff-so-fancy](https://github.com/so-fancy/diff-so-fancy) (./git/.config/git/config)
- [dropbox-cli](https://www.dropbox.com/) (./bin/.bin/dropbox-urls-extractor)
- [dunst](https://dunst-project.org/) (./i3/.config/i3/config)
- [fpp](http://facebook.github.io/PathPicker/) (./tmux/.tmux.conf)
- [fzf](https://github.com/junegunn/fzf) (./nvim/.config/nvim3/init.vim, ./vim/.vimrc, ./zsh/.zshrc)
- [gawk](https://www.gnu.org/software/gawk/) (./i3/.config/i3/scripts/i3session)
- [i3pystatus](https://github.com/enkore/i3pystatus) (./i3/.config/i3/bar.py)
- [imagemagick](https://www.imagemagick.org/script/index.php) (./i3/.config/i3/scripts/blurlock)
- [jq](https://stedolan.github.io/jq/) (./i3/.config/i3/scripts/i3session)
- [numlockx](https://wiki.archlinux.org/index.php/Activating_Numlock_on_Bootup) (./i3/.config/i3/config)
- [pamixer](https://github.com/cdemoulins/pamixer) (./i3/.config/i3/config)
- [pigz](https://zlib.net/pigz/) (./zsh/.zshenv)
- [pixz](https://github.com/vasi/pixz) (./zsh/.zshenv)
- [playerctl](https://github.com/acrisci/playerctl) (./i3/.config/i3/config)
- [pulseaudio](https://github.com/acrisci/playerctl) (./i3/.config/i3/scripts/dunstify_notification)
- [resize-font](https://github.com/simmel/urxvt-resize-font/) (./Xresources/.Xresources)
- [scrot](http://scrot.sourcearchive.com/) (./i3/.config/i3/scripts/blurlock)
- [setxkbmap](https://www.x.org/archive/X11R7.5/doc/man/man1/setxkbmap.1.html) (./i3/.config/i3/config)
- [udiskie](https://github.com/coldfix/udiskie) (./i3/.config/i3/config)
- [urlscan](https://github.com/firecat53/urlscan) (./tmux/.tmux.conf)
- [vmd](https://github.com/yoshuawuyts/vmd) (./nvim/.config/nvim/init.vim/, ./vim/.vimrc)
- [watchman](https://facebook.github.io/watchman/) (./git/.config/git/config)
- [wget](https://www.gnu.org/software/wget/) (./zsh/.zshrc)
- [wmctrl](http://tripie.sweb.cz/utils/wmctrl/) (./i3/.config/i3/scripts/i3session)
- [xcape](https://github.com/alols/xcape) (./i3/.config/i3/config)
- [xclip](https://github.com/astrand/xclip) (./vifm3/.config/vifm/vifmrc)
- [xdg-open](https://www.freedesktop.org/wiki/Software/xdg-utils/) (./tmux/.tmux.conf)
- [xsel](http://www.vergenet.net/~conrad/software/xsel/) (./bin/.bin/dropbox-urls-extractor,)

## Contributing

I only accept bug fixes, documentation and interesting features for me

1. Fork it ( <https://gitlab.com/mimadrid/dotfiles/fork> )
1. Create your fix branch (git checkout -b my-fix)
1. Commit your changes (git commit -am 'Add some fix')
1. Push to the branch (git push origin my-fix)
1. Create a new Pull Request

## Contributors

- Miguel Madrid Mencía ([mimadrid](https://github.com/mimadrid)) creator, maintainer
