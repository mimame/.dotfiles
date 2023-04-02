# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  unstableTarball =
    fetchTarball "https://github.com/nixos/nixpkgs/tarball/nixos-unstable";

  # bash script to let dbus know about important env variables and
  # propagate them to relevent services run at the end of sway config
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
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      export GTK_THEME="Sweet-Dark"
      gnome_schema=org.gnome.desktop.interface
      gsettings set $gnome_schema gtk-theme "Sweet-Dark"
      gsettings set $gnome_schema theme "Sweet-Dark"
      gsettings set $gnome_schema icon-theme "BeautyLine"
      gsettings set $gnome_schema cursor-theme "Catppuccin-Mocha-Mauve-Cursors"
      gsettings set $gnome_schema cursor-size 32
      gsettings set org.gnome.desktop.wm.preferences theme "Sweet-Dark"
      gsettings set $gnome_schema document-font-name 'Hack 13'
      gsettings set $gnome_schema font-name 'Hack 13'
      gsettings set $gnome_schema monospace-font-name 'Hack 13'
    '';
  };

in {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  # Add unstable packages injecting directly the unstable channel url
  nixpkgs.config = {
    packageOverrides = pkgs:
      with pkgs; {
        unstable = import unstableTarball { config = config.nixpkgs.config; };
      };
  };

  # Bootloader
  boot.loader = {
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
  };

  # Compress ram with zstd when needed to avoid use the swap
  zramSwap.enable = true;

  # Use the latest available version of Linux
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Power
  # DBus service that provides power management support to applications.
  services.upower.enable = true;
  # Configuration for suspension, hibernation and the laptop lid
  # Suspend in 10 minutes of inactivity and hibernate half hour later
  services.logind = {
    lidSwitch = "hibernate";
    lidSwitchDocked = "hibernate";
    lidSwitchExternalPower = "hibernate";
    extraConfig = ''
      AllowSuspend=yes
      AllowHibernation=yes
      AllowSuspendThenHibernate=yes
      SuspendMode=suspend-then-hibernate
      SuspendState=suspend-then-hibernate
      IdleActionSec=600
      IdleAction=suspend-then-hibernate
      HibernateDelaySec=1800
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
  services.connman.enable = true;
  services.connman.package = pkgs.unstable.connmanFull;
  services.connman.wifi.backend = "iwd";
  # OpenSSH daemon
  services.openssh = {
    enable = true;
    forwardX11 = true;
  };
  # Service discovery on a local network
  services.avahi.enable = true;

  # DBus service that allows applications to query and manipulate storage devices
  services.udisks2.enable = true;

  # Virtualisation
  virtualisation.podman.enable = true;
  virtualisation.virtualbox.host.enable = true;
  programs.singularity = {
    enable = true;
    # enableSuid = true; # FIXME: available in the next nixos release
    # enableFakeroot = true; # FIXME: available in the next nixos release
  };

  # Improve battery scaling the CPU governor and optimizing the general power
  services.auto-cpufreq.enable = true;

  # Prevent overheating of Intel CPUs before hardware takes aggressive correction action.
  # It does not conflict with auto-cpufreq in any way, and is even recommended
  # It can increases the performance
  services.thermald.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  # Synchronise time and date automatically
  services.chrony.enable = true;
  services.automatic-timezoned.enable = true;

  # Enable the X11 windowing system.
  programs.xwayland.enable = true;
  services.xserver = {
    enable = true;
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
      };
      defaultSession = "sway";
      autoLogin = {
        enable = true;
        user = "mimame";
      };
    };
    # Enable touchpad support (enabled by default in most desktopManager).
    libinput.enable = true;
  };

  services.interception-tools = {
    enable = true;
    udevmonConfig = ''
      - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc -m 1 | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
        DEVICE:
          EVENTS:
            EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
    '';
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "altgr-intl";
  };

  # Configure console keymap
  console.keyMap = "us";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    # media-session.enable = true;
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  environment.etc = {
    "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
      bluez_monitor.properties = {
        ["bluez5.enable-sbc-xq"] = true,
        ["bluez5.enable-msbc"] = true,
        ["bluez5.enable-hw-volume"] = true,
        ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
      }
    '';
  };

  # Always enable the shell system-wide
  # Otherwise it wont source the necessary files
  programs.fish.enable = true;

  # Many programs look at /etc/shells to determine
  # if a user is a "normal" user and not a "system" user
  environment.shells = [ pkgs.unstable.fish ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = pkgs.unstable.fish;
    users.mimame = {
      isNormalUser = true;
      description = "mimame";
      extraGroups = [ "wheel" "video" "podman" "vboxusers" ];
      packages = with pkgs;
        [
          #  firefox
          #  thunderbird
        ];

    };
  };

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
      commands = [{
        command = "/run/current-system/sw/bin/podman";
        options = [ "NOPASSWD" ];
      }];
    }];
  };
  # GNOME Keyring daemon
  services.gnome.gnome-keyring.enable = true;
  # Policy that allows unprivileged processes to speak to privileged processes
  security.polkit.enable = true;

  # systemd units
  systemd = {
    user.services.gammastep = {
      enable = true;
      description = "gammastep";
      wants = [ "default.target" ];
      wantedBy = [ "default.target" ];
      after = [ "default.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.unstable.gammastep}/bin/gammastep";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
    user.services.swayidle = {
      enable = true;
      description = "swayidle";
      wants = [ "default.target" ];
      wantedBy = [ "default.target" ];
      after = [ "default.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart =
          "${pkgs.unstable.swayidle}/bin/swayidle timeout 1800 'systemctl suspend-then-hibernate'";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

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
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # enable sway window manager
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraSessionCommands = ''
      export SDL_VIDEODRIVER=wayland
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
      export GTK_USE_PORTAL=1
    '';
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
    # Replace identical files in the nix store with hard links
    settings.auto-optimise-store = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Auto upgrade packages by default without reboot
  system.autoUpgrade = {
    allowReboot = false;
    enable = true;
  };

  # Locate service
  services.locate = {
    enable = true;
    locate = pkgs.unstable.plocate;
    localuser = null;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    java.enable = true;
    light.enable = true;
    mtr.enable = true;
    nm-applet.enable = true;
    seahorse.enable = true;
    wireshark.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs;
    [

      at
      avfs
      axel
      baobab
      bc
      bind
      bison
      bluez-tools
      clipman
      configure-gtk
      dbus-sway-environment
      dmenu-wayland
      dosfstools
      fakeroot
      firmwareLinuxNonfree
      glib # gsettings
      gparted
      graphviz
      gthumb
      gvfs
      httpie
      hyphen
      inkscape
      interception-tools
      jc
      keepassxc
      libarchive
      libevdev
      libinput-gestures
      libnotify
      libreoffice-fresh
      lnav
      lsb-release
      lsof
      lua
      lxappearance
      meld
      nixfmt
      nixpkgs-review
      ntfs3g
      openssl
      parallel
      parted
      pavucontrol
      pkg-config
      pulseaudio # to be able to use pactl
      putty
      pv
      pwgen
      python3Packages.cython
      python3Packages.howdoi
      python3Packages.ipython
      python3Packages.pip
      python3Packages.ptpython
      qutebrowser
      rustscan
      rustup
      spotify
      strace
      stress
      stylua
      sudo
      tesseract5
      time
      util-linux
      wayland
      wev
      wl-clipboard
      wlrctl
      xdg-user-dirs
      xdg-utils
      ydotool

    ] ++ (with pkgs.unstable; [

      ameba
      ansible
      aria2
      asciidoc-full
      asciidoctor
      autoconf
      automake
      bat
      bitwarden
      bitwarden-cli
      broot
      brotli
      btop
      bzip2
      calibre
      catppuccin-cursors.mochaMauve
      # clang # breaks the lvim treesitter compilation
      clifm
      cmake
      cmst # QT connman GUI
      coreutils
      crystal
      curl
      curlie
      delta
      difftastic
      direnv
      diskus
      dogdns
      dos2unix
      dropbox
      dstat
      dua
      duf
      dura
      elixir
      entr
      espanso
      evince
      exa
      fd
      file
      filezilla
      firefox
      flameshot
      fuse-common
      fzf
      gawk
      gcc
      gdu
      gimp
      git
      git-cola
      git-extras
      gitg
      github-cli
      gitoxide
      gitui
      glow
      gnumake
      gnupatch
      go
      gomi
      google-chrome
      grc
      grex
      gron
      gzip
      handlr
      helix
      hexyl
      (hiPrio
        beauty-line-icon-theme) # collition warnings: needed for avoid default gnome icon themes
      (hiPrio fish) # collition warnings: needed for programs.fish.enable
      (hiPrio sway) # collition warnings: needed for bindgesture
      hugo
      hunspellDicts.en-us-large
      hunspellDicts.es-es
      hunspellDicts.fr-moderne
      hyperfine
      i3status-rust
      imagemagick
      jekyll
      jless
      jq
      julia-bin
      just
      kitty
      klavaro
      kubernetes
      lazydocker
      lazygit
      litecli
      llvm
      logseq
      lsd
      massren
      mcfly
      mdcat
      meson
      micro
      minikube
      navi
      ncdu_2
      neofetch
      neovim
      newsboat
      nextflow
      nim
      ninja
      (nnn.override { withNerdIcons = true; })
      nodejs
      nodePackages.npm
      nuspell
      obsidian
      onefetch
      ouch
      pandoc
      pcmanfm
      pcre2
      pdftk
      pigz
      pixz
      plantuml
      playerctl
      podman-tui
      postgresql
      pre-commit
      procs
      progress
      pueue
      python3Full
      ranger
      rclone
      ripgrep
      rlwrap
      rnix-lsp
      rofi
      rsync
      scc
      sd
      shards
      shellcheck
      shfmt
      spicetify-cli
      sqlite
      sqlitebrowser
      sqlite-utils
      sshfs
      starship
      stow
      swaynotificationcenter
      swayr
      sweet
      tealdeer
      tectonic
      testdisk
      thefuck
      thunderbird
      tokei
      topgrade
      translate-shell
      tree
      tridactyl-native
      udiskie
      universal-ctags
      unrar
      unzip
      urlscan
      vagrant
      vifm
      visidata
      vivaldi
      vivid
      vlc
      vscode
      watchexec
      wezterm
      wget
      xarchiver
      xdragon
      xh
      xonsh
      xplr
      zathura
      zellij
      zenith
      zig
      zip
      zlib-ng
      zoom-us
      zotero
      zoxide
      zstd

    ]);

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
