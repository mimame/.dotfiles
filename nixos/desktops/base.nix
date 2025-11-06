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
      # Clipboard manager
      clipman # Clipboard manager for Wayland
    ]
    ++ (with pkgs.unstable; [
      # Web browsers
      (pkgs.wrapFirefox (pkgs.firefox-unwrapped.override {
        ffmpegSupport = true;
        pipewireSupport = true;
      }) { }) # Firefox with multimedia support
      google-chrome # Google Chrome web browser
      nyxt # Keyboard-driven web browser
      qutebrowser # Keyboard-driven, vim-like browser
      (vivaldi.override {
        proprietaryCodecs = true;
        enableWidevine = true;
      }) # Vivaldi web browser
      thunderbird # Email client

      # Communication
      telegram-desktop # Telegram messaging app

      # Productivity and Notes
      joplin-desktop # Note-taking and to-do application
      logseq # Privacy-first, open-source knowledge base
      obsidian # Knowledge base and note-taking app
      zed-editor # A high-performance, collaborative code editor
      zettlr # Markdown editor for researchers and writers
      zoom-us # Video conferencing
      # zeal # Offline documentation browser

      # Password management
      bitwarden-desktop # Desktop password manager
      keepassxc # Cross-platform password manager

      # File synchronization and transfer
      dropbox # Cloud storage service
      filezilla # FTP, FTPS and SFTP client

      # Graphics and image manipulation
      (flameshot.override { enableWlrSupport = true; }) # Screenshot tool
      gimp3 # GNU Image Manipulation Program
      inkscape # Vector graphics editor

      # Media players and codecs
      ffmpeg-full # Complete FFmpeg suite
      gst_all_1.gst-plugins-bad # GStreamer bad plugins
      gst_all_1.gst-plugins-base # GStreamer base plugins
      gst_all_1.gst-plugins-good # GStreamer good plugins
      gst_all_1.gst-plugins-ugly # GStreamer ugly plugins
      gst_all_1.gstreamer # GStreamer multimedia framework
      spotify # Music streaming service
      vlc # VLC media player

      # Development tools (GUI)
      dbeaver-bin # Universal database tool
      gitg # Git graphical user interface
      lapce # Lightning-fast and powerful code editor
      neovide # Neovim GUI
      vscode # Visual Studio Code

      # Utilities
      anyrun # Application launcher
      calibre # E-book management
      cytoscape # Graph visualization and analysis
      emote # Emoji picker
      eww # Elkowar's Wacky Widgets
      klavaro # Touch typing tutor
      mesa-demos # Mesa 3D graphics library demos
      playerctl # Command-line utility for controlling media players
      qalculate-gtk # Powerful and versatile desktop calculator
      ripdrag # Drag and drop utility
      rofi # Application launcher and more
      satty # Screenshot annotation tool
      spicetify-cli # Customize Spotify client
      sqlitebrowser # SQLite database browser
      tridactyl-native # Keyboard interface for Firefox
      ulauncher # Application launcher
      unetbootin # Create bootable Live USB drives
      usbimager # Write compressed disk images to USB drives
      wev # Wayland event viewer
      wl-clipboard # Wayland clipboard utilities
      wlrctl # Control Wayland compositors
      wtype # Type text on Wayland
      ydotool # Command-line tool to simulate keyboard and mouse input

      # Disabled packages
      # betterbird
      # floorp
      # git-cola
      # kdiff3
      # nheko
      # wl-clipboard-rs
      # rofi-calc
      # (rofi-calc.override {
      #   rofi-unwrapped = rofi-wayland-unwrapped;
      # })
      # pcmanfm
    ]);
}
