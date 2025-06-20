{ pkgs, ... }:
{

  # Enable periodic SSD TRIM to maintain SSD performance
  services.fstrim.enable = true;

  # Enable ZRAM with zstd compression to avoid using swap
  zramSwap.enable = true;

  # Enable power management support via UPower
  services.upower.enable = true;

  # Aims to provide high performance and reliability,
  # while keeping compatibility to the D-Bus reference implementation
  services.dbus.implementation = "broker";

  # Configure X11 keymap with US layout and AltGr international variant
  services.xserver = {
    xkb = {
      layout = "us";
      variant = "altgr-intl";
    };
    exportConfiguration = true;
  };

  # Configure console keymap to US layout
  console.keyMap = "us";

  # Enable uinput support for user-level input handling
  hardware.uinput.enable = true;

  # Set default locale to US English with UTF-8 encoding
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable UDisks2 for storage device management
  services.udisks2.enable = true;

  # Enable and configure interception-tools for Caps Lock to Escape remapping
  services.interception-tools = {
    enable = true;
    udevmonConfig = ''
      - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc -m 1 | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
        DEVICE:
          EVENTS:
            EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
    '';
  };

  # 3200-2000-1200-800DPI
  # ls -l /dev/input/by-id/*
  # mouse-dpi-tool /dev/input/event27
  # mouse:usb:v1bcfp0053:name:USB Optical Mouse  Mouse:
  #  MOUSE_DPI=2000@145
  services.udev.extraHwdb = ''
    mouse:usb:*
     MOUSE_DPI=3200@145
  '';

  # Always enable the shell system-wide
  # Otherwise it won't source the necessary files
  # Use completion files provided by other packages
  # Source configuration snippets provided by other packages
  # Autoload fish functions provided by other packages
  programs.fish = {
    enable = true;
    package = pkgs.unstable.fish;
  };

  # Many programs look at /etc/shells to determine
  # if a user is a "normal" user and not a "system" user
  environment.shells = [ pkgs.unstable.fish ];

  # Policy that allows unprivileged processes to speak to privileged processes
  security.polkit.enable = true;
  # Security
  security.sudo-rs = {
    # Only ask sudo password one time for all tty
    # Ask sudo password each 2h instead 5 minutes
    package = pkgs.unstable.sudo-rs;
  };
  # FIXME: sudo-rs doesn't write to /etc/sudoers file the extraConfig and extraRules
  security.sudo = {
    extraConfig = ''
      Defaults !tty_tickets
      Defaults timestamp_timeout=120
    '';
    extraRules = [
      {
        users = [ "mimame" ];
        commands = [
          {
            command = "/run/current-system/sw/bin/systemctl restart geoclue.service";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };

  services.kmscon = {
    enable = true;
    extraConfig = ''
      font-name=JetBrainsMonoNL Nerd Font Mono
      font-size=16
      xkb-layout=us
      xkb-variant=altgr-intl
    '';
    extraOptions = "--term wezterm";
    hwRender = true;
  };

  # Enable apropos(1) and the -k option of man(1)
  documentation.man.generateCaches = true;

  environment.systemPackages =
    with pkgs;
    [

      exfatprogs # exfat format support
      interception-tools
      libevdev # mouse-dpi-tool
      libnotify

    ]
    ++ (with pkgs.unstable; [

    ]);
}
