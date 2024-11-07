{ pkgs, ... }:
{

  # Update the CPU microcode for Intel processors
  hardware.cpu.intel.updateMicrocode = true;

  # Enable periodic SSD TRIM to maintain SSD performance
  services.fstrim.enable = true;

  # Enable ZRAM with zstd compression to avoid using swap
  zramSwap.enable = true;

  # Prevent overheating of Intel CPUs and improve performance
  services.thermald.enable = true;

  # Enable power management support via UPower
  services.upower.enable = true;

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
  i18n.defaultLocale = "en_US.utf8";

  # Enable automatic time synchronization
  services.chrony.enable = true;
  services.automatic-timezoned.enable = true;

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

  # Primary font paths
  fonts = {
    fontDir.enable = true;
    enableDefaultPackages = true;
    packages = with pkgs.unstable; [
      # Comparing JetBrainsMono (No Ligatures) and Hack:
      # - Hack is a monospaced font, but has visual inconsistencies with characters of variable width
      #   (e.g., parenthesis, brackets, and characters with different styles, like ||).
      # - JetBrains Mono focuses on consistent spacing and legibility, making it a preferred choice for coding.
      # Referenced issue for context: https://github.com/freeCodeCamp/freeCodeCamp/issues/49174

      # Merriweather:
      # - A serif font that is more contemporary and warm compared to Noto Serif.
      # - Optimized for screen readability, making it suitable for both body text and headlines.

      # Roboto:
      # - A modern, geometric sans-serif font known for its high readability.
      # - Preferred over Noto Sans for its clean and versatile design.
      (nerdfonts.override {
        fonts = [
          "JetBrainsMono"
          "Hack"
        ];
      })
      font-awesome
      merriweather
      noto-fonts
      noto-fonts-color-emoji
      roboto
      source-sans-pro
    ];
    fontconfig = {
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        serif = [
          "Merriweather"
          # "Noto Serif"
          "Noto Color Emoji"
        ];
        sansSerif = [
          "Roboto"
          # "Noto Sans"
          "Noto Color Emoji"
        ];
        monospace = [
          "JetBrainsMonoNL Nerd Font Mono"
          "Noto Color Emoji"
          # "Hack"
        ];
      };
    };
  };

  # Enable apropos(1) and the -k option of man(1)
  documentation.man.generateCaches = true;

  # Use the latest available version of Linux
  # By now the stable version is used to avoid break the virtualbox virtualisation
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
  };

  environment.systemPackages =
    with pkgs;
    [

      interception-tools
      libevdev
      libnotify
    ]
    ++ (with pkgs.unstable; [

    ]);
}
