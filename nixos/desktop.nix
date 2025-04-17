{ pkgs, ... }:
let
in
{

  # Whether to run XDG autostart files for sessions without a desktop manager (with only a window manager), these sessions usually don’t handle XDG autostart files by default.
  services.xserver.desktopManager.runXdgAutostartIfNone = true;

  # Add IBus engines for text completion and emojis
  # i18n.inputMethod = {
  #   enable = true;
  #   type = "ibus";
  #   ibus.engines = with pkgs.unstable.ibus-engines; [
  #     typing-booster
  #     uniemoji
  #   ];
  # };

  environment.systemPackages =
    with pkgs;
    [

      clipman
      cmst # QT connman GUI
      gthumb
      inkscape
      keepassxc
      libreoffice
      rofi-wayland
      spotify
      zoom-us # White screen if the version is linked from pkgs.unstable
    ]
    ++ (with pkgs.unstable; [

      # betterbird
      bitwarden
      calibre
      catppuccin-cursors.mochaMauve
      cytoscape
      dbeaver-bin
      dropbox
      emote
      evince
      eww
      filezilla
      (pkgs.wrapFirefox (pkgs.firefox-unwrapped.override {
        ffmpegSupport = true;
        pipewireSupport = true;
      }) { })
      flameshot
      # floorp
      gimp
      # git-cola
      gitg
      glxinfo
      ffmpeg-full
      google-chrome
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-ugly
      gst_all_1.gstreamer
      joplin-desktop
      kdiff3
      klavaro
      lapce
      # logseq # removed from nixpkgs
      neovide
      # nheko
      obsidian
      pcmanfm
      pdfarranger
      playerctl
      qalculate-gtk
      qutebrowser
      ripdrag
      spicetify-cli
      sqlitebrowser
      telegram-desktop
      thunderbird
      tridactyl-native
      ulauncher
      usbimager
      (vivaldi.override {
        proprietaryCodecs = true;
        enableWidevine = true;
      })
      vlc
      vscode
      wev
      # wl-clipboard-rs
      wl-clipboard
      wlrctl
      wtype
      ydotool
      zathura
      zeal
      zed-editor
      zettlr
      zotero
      unetbootin

    ]);
}
