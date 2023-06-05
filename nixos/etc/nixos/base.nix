{ pkgs, ... }: {

  # Compress ram with zstd when needed to avoid use the swap
  zramSwap.enable = true;

  # Prevent overheating of Intel CPUs before hardware takes aggressive correction action.
  # It does not conflict with auto-cpufreq in any way, and is even recommended
  # It can increases the performance
  services.thermald.enable = true;

  # Power
  # DBus service that provides power management support to applications.
  services.upower.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "altgr-intl";
    exportConfiguration = true;
  };

  # Configure console keymap
  console.keyMap = "us";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  # Synchronise time and date automatically
  services.chrony.enable = true;
  services.automatic-timezoned.enable = true;

  # Service discovery on a local network
  services.avahi.enable = true;

  # DBus service that allows applications to query and manipulate storage devices
  services.udisks2.enable = true;

  services.interception-tools = {
    enable = true;
    udevmonConfig = ''
      - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc -m 1 | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
        DEVICE:
          EVENTS:
            EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
    '';
  };

  # Network
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  networking = {
    firewall = {
      # Or disable the firewall altogether.
      enable = true;
      # Open ports in the firewall.
      allowedUDPPorts = [ ];
      allowedTCPPorts = [ ];
    };
    hostName = "narnia";
    wireless.iwd.settings = {
      Network = {
        EnableIPv6 = true;
        RoutePriorityOffset = 300;
      };
      # Verify wifi connections have autoConnect in both iwd and connman configs
      Settings = { AutoConnect = true; };
    };
  };
  services.connman = {
    package = pkgs.connmanFull;
    enable = true;
    wifi.backend = "iwd";
    extraFlags = [ "--nodnsproxy" ];
  };

  services.unbound = {
    enable = true;
    settings = {
      server = { interface = [ "127.0.0.1" ]; };
      forward-zone = [{
        name = ".";
        forward-addr = "1.1.1.1@853#cloudflare-dns.com";
      }];
      remote-control.control-enable = true;
    };
  };

  # OpenSSH daemon
  services.openssh = {
    enable = true;
    settings = { X11Forwarding = true; };
  };
  # Virtualisation
  virtualisation.podman.enable = true;
  virtualisation.virtualbox = {
    host = {
      enable = true;
      enableExtensionPack = true;
    };
    guest = { enable = true; };
  };
  programs.singularity = {
    enable = true;
    enableSuid = true;
    enableFakeroot = true;
  };

  # Always enable the shell system-wide
  # Otherwise it wont source the necessary files
  programs.fish.enable = true;

  # Many programs look at /etc/shells to determine
  # if a user is a "normal" user and not a "system" user
  environment.shells = [ pkgs.unstable.fish ];

  # Policy that allows unprivileged processes to speak to privileged processes
  security.polkit.enable = true;
  # Security
  security.sudo = {
    # Only ask sudo password one time for all tty
    # Ask sudo password each 2h instead 5 minutes
    extraConfig = ''
      Defaults !tty_tickets
      Defaults timestamp_timeout=120
    '';
    # Configure podman to be use by minikube
    extraRules = [{
      users = [ "mimame" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/podman";
          options = [ "NOPASSWD" ];
        }
        {
          command =
            "/run/current-system/sw/bin/systemctl restart geoclue.service";
          options = [ "NOPASSWD" ];
        }
      ];
    }];
  };

  # Primary font paths
  fonts.fonts = with pkgs.unstable; [
    (nerdfonts.override { fonts = [ "Hack" ]; })
    font-awesome
  ];

  # Enable apropos(1) and the -k option of man(1)
  documentation.man.generateCaches = true;

  nix = {
    # Be sure to run nix-collect-garbage one time per week
    gc = {
      automatic = true;
      persistent = true;
      dates = "weekly";
      options = "--delete-old";
    };
    settings = {
      # Replace identical files in the nix store with hard links
      auto-optimise-store = true;
      # Unify many different Nix package manager utilities
      # https://nixos.org/manual/nix/stable/command-ref/experimental-commands.html
      experimental-features = [ "nix-command" ];
      trusted-users = [ "root" "@wheel" ];
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Auto upgrade packages by default without reboot
  system.autoUpgrade = {
    allowReboot = false;
    enable = true;
  };

  # Use the latest available version of Linux
  # By now the stable version is used to avoid break the virtualbox virtualisation
  # boot.kernelPackages = pkgs.linuxPackages_latest;

  environment.systemPackages = with pkgs;
    [

      firmwareLinuxNonfree
      interception-tools
      libevdev
      libnotify

    ] ++ (with pkgs.unstable;
      [

      ]);
}
