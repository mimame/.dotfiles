{ pkgs, ... }:
let

  # bash script to let dbus know about important env variables and
  # propagate them to relevant services run at the end of sway config
  # see
  # https://github.com/emersion/xdg-desktop-portal-wlr/wiki/"It-doesn't-work"-Troubleshooting-Checklist
  # note: this is pretty much the same as  /etc/sway/config.d/nixos.conf but also restarts
  # some user services to make sure they have the correct environment variables
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;

    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user restart pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };

  # currently, there is some friction between sway and gtk:
  # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
  # the suggested way to set gtk settings is with gsettings
  # for gsettings to work, we need to tell it where the schemas are
  # using the XDG_DATA_DIR environment variable
  # run at the end of sway config
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text =
      let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsettings-schemas/${schema.name}";
      in
      ''
        export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
        export GTK_THEME="Sweet-Dark"
        gnome_schema=org.gnome.desktop.interface
        gsettings set $gnome_schema gtk-theme "Sweet-Dark"
        gsettings set $gnome_schema theme "Sweet-Dark"
        gsettings set $gnome_schema icon-theme "BeautyLine"
        gsettings set $gnome_schema cursor-theme "Catppuccin-Mocha-Mauve-Cursors"
        gsettings set $gnome_schema cursor-size 32
        gsettings set org.gnome.desktop.wm.preferences theme "Sweet-Dark"
        gsettings set $gnome_schema document-font-name 'JetBrainsMonoNL 13'
        gsettings set $gnome_schema font-name 'JetBrainsMonoNL 13'
        gsettings set $gnome_schema monospace-font-name 'JetBrainsMonoNL 13'
      '';
  };
in
{
  # systemd units
  systemd = {
    user.services = {
      gammastep = {
        enable = true;
        description = "gammastep";
        wants = [ "default.target" ];
        wantedBy = [ "default.target" ];
        after = [ "default.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.gammastep}/bin/gammastep";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
      swayidle = {
        enable = true;
        description = "swayidle";
        wants = [ "default.target" ];
        wantedBy = [ "default.target" ];
        after = [ "default.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.unstable.swayidle}/bin/swayidle timeout 3600 'systemctl suspend-then-hibernate'";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
  };

  # GNOME Keyring daemon
  services.gnome.gnome-keyring.enable = true;
  # Enable GNOME settings
  services.gnome.gnome-settings-daemon.enable = true;
  # Enable GNOME online accounts
  services.gnome.gnome-online-accounts.enable = true;

  # xdg-desktop-portal works by exposing a series of D-Bus interfaces
  # known as portals under a well-known name
  # (org.freedesktop.portal.Desktop) and object path
  # (/org/freedesktop/portal/desktop).
  # The portal interfaces include APIs for file access, opening URIs,
  # printing and others.
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # use the portal to open programs
    # Broken when XDG_CURRENT_DESKTOP=sway
    xdgOpenUsePortal = false;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # enable sway window manager
  programs.sway = {
    enable = true;
    # sway unstable breaks electron apps like vivaldi, obsidian and google-chrome
    # package = pkgs.unstable.sway;
    wrapperFeatures.gtk = true;
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
      export GTK_USE_PORTAL=1
      export QT_IM_MODULE=ibus
      export XMODIFIERS=@im=ibus
      export GTK_IM_MODULE=ibus
    '';
  };

  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };

  services.displayManager = {
    defaultSession = "sway";
    autoLogin = {
      enable = true;
      user = "mimame";
    };
  };

  # Whether to run XDG autostart files for sessions without a desktop manager (with only a window manager), these sessions usually don’t handle XDG autostart files by default.
  services.xserver.desktopManager.runXdgAutostartIfNone = true;

  environment.systemPackages =
    with pkgs;
    [

      configure-gtk
      dbus-sway-environment
      ironbar
      swaynotificationcenter
      swayosd
      swayr
      waybar

    ]
    ++ (with pkgs.unstable; [

      i3status-rust

    ]);
}
