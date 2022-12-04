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
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
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
      gsettings set $gnome_schema cursor-theme "capitaine-cursors-white"
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
  nixpkgs.config = {
    packageOverrides = pkgs:
      with pkgs; {
        unstable = import unstableTarball { config = config.nixpkgs.config; };
      };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  powerManagement.cpuFreqGovernor = "ondemand";

  system.autoUpgrade = {
    allowReboot = false;
    enable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  # Synchronise time and date
  services.chrony.enable = true;
  services.localtimed.enable = true;
  services.geoclue2.enable = true;
  services.avahi.enable = true;

  # Locate service
  services.locate.enable = true;
  services.locate.locate = pkgs.plocate;
  services.locate.localuser = null;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.displayManager = {
    gdm.enable = true;
    defaultSession = "sway";
    autoLogin = {
      enable = true;
      user = "mimame";
    };
  };
  services.xserver.libinput.enable = true;

  services.interception-tools.enable = true;
  services.interception-tools.udevmonConfig = ''
    - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc -m 1 | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
      DEVICE:
        EVENTS:
          EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
  '';

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
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.defaultUserShell = pkgs.unstable.fish;
  users.users.mimame = {
    isNormalUser = true;
    description = "mimame";
    extraGroups = [ "networkmanager" "wheel" "video" ];
    packages = with pkgs;
      [
        #  firefox
        #  thunderbird
      ];
  };

  services.gnome.gnome-keyring.enable = true;

  security.polkit.enable = true;

  # TODO: fix locate.latitude
  # for that simply use geoclue2 in the config file instead a fixed latitude
  # services.redshift.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

    ansible
    aria2
    asciidoc-full
    asciidoctor
    aspell
    aspellDicts.en
    aspellDicts.es
    aspellDicts.fr
    at
    auto-cpufreq
    autoconf
    automake
    avfs
    axel
    baobab
    unstable.bat
    bc
    bind
    bison
    blueman
    bluez
    bluez-tools
    unstable.broot
    brotli
    unstable.btop
    bzip2
    caffeine-ng
    unstable.calibre
    capitaine-cursors
    clang # Maybe breaks the lvim treesitter compilation
    cmake
    coreutils
    unstable.crystal
    curl
    curlie
    unstable.delta
    unstable.difftastic
    direnv
    diskus
    dogdns
    dos2unix
    dosfstools
    dstat
    dua
    duf
    dura
    entr
    unstable.espanso
    unstable.exa
    unstable.fd
    filezilla
    firefox
    firmwareLinuxNonfree
    unstable.fish
    flameshot
    fuse-common
    fuse3
    unstable.fzf
    gawk
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
    gnome.seahorse
    gnumake
    gnupatch
    gnupg
    unstable.go
    google-chrome
    gparted
    gparted
    graphviz
    grc
    grex
    gron
    gthumb
    gvfs
    gzip
    handlr
    unstable.helix
    hexyl
    htop
    unstable.httpie
    hugo
    unstable.hyperfine
    hyphen
    unstable.i3status-rust
    inkscape
    jc
    jekyll
    jq
    unstable.julia-bin
    just
    keepassxc
    unstable.kitty
    kitty-themes
    klavaro
    lazydocker
    lazygit
    less
    libarchive
    libreoffice-fresh
    light
    linuxKernel.kernels.linux_zen
    linuxKernel.packages.linux_zen.virtualbox
    litecli
    lnav
    unstable.logseq
    lsb-release
    lsd
    lsof
    lua
    lxappearance
    man-db
    man-pages
    massren
    mcfly
    mdcat
    meld
    meson
    unstable.micro
    mosh
    mtr
    unstable.navi
    ncdu_2
    neofetch
    unstable.neovim
    networkmanagerapplet
    newsboat
    unstable.nim
    ninja
    nixfmt
    nixpkgs-review
    nodePackages.npm
    ntfs3g
    unstable.nushell
    unstable.obsidian
    onefetch
    openssl
    ouch
    pulseaudio # to be able to use pactl
    pandoc
    parallel
    parted
    pass
    passExtensions.pass-import
    pcmanfm
    pcre2
    pdftk
    pigz
    pixz
    plantuml
    playerctl
    plocate
    unstable.podman
    unstable.podman-compose
    unstable.podman-tui
    procs
    progress
    pueue
    putty
    pv
    pwgen
    python310
    python310Packages.cython
    python310Packages.howdoi
    python310Packages.ipython
    unstable.qutebrowser
    unstable.ranger
    rclone
    ripgrep
    rlwrap
    unstable.rofi
    unstable.rsync
    rustscan
    rustup
    unstable.scc
    scrot
    unstable.sd
    unstable.shards
    unstable.shellcheck
    unstable.shfmt
    singularity
    spicetify-cli
    spotify
    sqlite
    sqlite-utils
    sqlitebrowser
    sshfs
    unstable.starship
    unstable.stow
    strace
    stress
    stylua
    sudo
    unstable.sweet
    unstable.beauty-line-icon-theme
    unstable.tealdeer
    tectonic
    tesseract5
    testdisk
    thefuck
    time
    unstable.tokei
    trash-cli
    tree
    tridactyl-native
    udiskie
    udisks
    universal-ctags
    unrar
    urlscan
    util-linux
    unstable.vagrant
    unstable.vifm
    virtualbox
    visidata
    vivaldi
    unstable.vivid
    unstable.vlang
    vlc
    unstable.vscode
    watchexec
    wget
    xdg-user-dirs
    xdg-utils
    unstable.xh
    unstable.xonsh
    yarn
    zathura
    unstable.zellij
    fakeroot
    unstable.zenith
    unstable.zig
    unstable.zlib-ng
    unstable.zotero
    unstable.zoxide
    unstable.zstd

    interception-tools
    libevdev
    sway
    wev
    dbus-sway-environment
    configure-gtk
    wayland
    glib # gsettings
    wlrctl
    swaylock
    swayidle
    ydotool
    clipman
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    swaynotificationcenter
    libnotify

  ];

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "Hack" ]; })
    font-awesome
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
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

  programs.light.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    forwardX11 = true;
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ ];
  networking.firewall.allowedUDPPorts = [ ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
