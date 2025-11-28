{ pkgs, ... }:
{
  # Documentation: Example of how GTK theme settings were previously applied via an imperative script.
  # This approach has been replaced by declarative dconf settings using programs.dconf.profiles.
  #
  # let
  #   # The configure-gtk script sets the GTK theme, icons, and other appearance-related
  #   # settings using gsettings. This was necessary because non-GNOME window managers
  #   # did not have a built-in way to manage these settings.
  #   #
  #   # The script was run as a systemd user service after the window manager started,
  #   # ensuring that the correct theme was applied at login. It required the
  #   # gsettings-desktop-schemas to be available in XDG_DATA_DIRS to find the
  #   # necessary schemas for the settings it modified.
  #   configure-gtk = pkgs.writeTextFile {
  #     name = "configure-gtk";
  #     destination = "/bin/configure-gtk";
  #     executable = true;
  #     text =
  #       let
  #         schema = pkgs.gsettings-desktop-schemas;
  #         datadir = "${schema}/share/gsettings-schemas/${schema.name}";
  #       in
  #       ''
  #         #!/bin/sh
  #         export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
  #         export GTK_THEME="Sweet-Dark"
  #         gnome_schema=org.gnome.desktop.interface
  #         gsettings set $gnome_schema color-scheme prefer-dark
  #         gsettings set $gnome_schema gtk-theme "Sweet-Dark"
  #         gsettings set org.gnome.desktop.wm.preferences theme "Sweet-Dark"
  #         gsettings set $gnome_schema icon-theme "candy-icons"
  #         gsettings set $gnome_schema cursor-theme "capitaine-cursors-white"
  #         gsettings set $gnome_schema cursor-size "48"
  #         gsettings set $gnome_schema document-font-name 'JetBrainsMonoNL 13'
  #         gsettings set $gnome_schema font-name 'JetBrainsMonoNL 13'
  #         gsettings set $gnome_schema monospace-font-name 'JetBrainsMonoNL 13'
  #       '';
  #   };
  # in

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

  imports = [
    ./apps/browsers.nix
    ./apps/clipboard.nix
    ./apps/communication.nix
    ./apps/development.nix
    ./apps/graphics.nix
    ./apps/media.nix
    ./apps/networking.nix
    ./apps/notes.nix
    ./apps/security.nix
    ./apps/utilities.nix
  ];
}
