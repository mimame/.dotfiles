{ pkgs, ... }:
{

  # Set ghostty as the default terminal. This fixes the behavior of the "Open With"
  # menu in Nautilus/Files for terminal applications like yazi or nvim, ensuring
  # they launch in the correct terminal. It also sets the default for applications
  # that explicitly call the `xdg-terminal-exec` script.
  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = [ "com.mitchellh.ghostty.desktop" ];
    };
  };

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
      libreoffice-fresh
    ]
    ++ (with pkgs.unstable; [

      # betterbird
      # floorp
      # git-cola
      # kdiff3
      # nheko
      # wl-clipboard-rs
      anyrun
      # calibre
      bitwarden-desktop
      cytoscape
      dbeaver-bin
      dropbox
      emote
      eww
      ffmpeg-full
      filezilla
      (flameshot.override { enableWlrSupport = true; })
      (pkgs.wrapFirefox (pkgs.firefox-unwrapped.override {
        ffmpegSupport = true;
        pipewireSupport = true;
      }) { })
      gimp3
      # gitbutler
      gitg
      google-chrome
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-ugly
      gst_all_1.gstreamer
      inkscape
      joplin-desktop
      keepassxc
      klavaro
      lapce
      logseq
      # megasync
      mesa-demos
      neovide
      nyxt
      obsidian
      # pcmanfm
      playerctl
      qalculate-gtk
      qutebrowser
      ripdrag
      # rofi-calc
      # (rofi-calc.override {
      #   rofi-unwrapped = rofi-wayland-unwrapped;
      # })
      rofi
      satty
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
      # zeal
      zed-editor
      zettlr
      zoom-us
      zotero

    ]);
}
