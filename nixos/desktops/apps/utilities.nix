{ pkgs, ... }:
{
  environment.systemPackages = with pkgs.unstable; [
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
    ydotool # Command-line tool to simulate keyboard and mouse input
  ];
}
