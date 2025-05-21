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
      (flameshot.override { enableWlrSupport = true; })
    ]
    ++ (with pkgs.unstable; [

      # betterbird
      # floorp
      # git-cola
      # kdiff3
      # nheko
      # wl-clipboard-rs
      bitwarden
      calibre
      catppuccin-cursors.mochaMauve
      cytoscape
      dbeaver-bin
      dropbox
      emote
      evince
      eww
      ffmpeg-full
      filezilla
      (pkgs.wrapFirefox (pkgs.firefox-unwrapped.override {
        ffmpegSupport = true;
        pipewireSupport = true;
      }) { })
      gimp3
      gitg
      glxinfo
      google-chrome
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-ugly
      gst_all_1.gstreamer
      gthumb
      inkscape
      joplin-desktop
      keepassxc
      klavaro
      lapce
      libreoffice
      logseq # removed from nixpkgs
      neovide
      obsidian
      pcmanfm
      pdfarranger
      playerctl
      qalculate-gtk
      qutebrowser
      ripdrag
      rofi-wayland
      spicetify-cli
      spotify
      sqlitebrowser
      telegram-desktop
      thunderbird
      tridactyl-native
      ulauncher
      unetbootin
      usbimager
      (vivaldi.override {
        proprietaryCodecs = true;
        enableWidevine = true;
      })
      vlc
      vscode
      wev
      wl-clipboard
      wlrctl
      wtype
      ydotool
      zathura
      zeal
      zed-editor
      zettlr
      zoom-us
      zotero

    ]);
}
