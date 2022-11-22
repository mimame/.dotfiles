# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  unstableTarball =
    fetchTarball "https://github.com/nixos/nixpkgs/tarball/nixos-unstable";
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

  system.autoUpgrade = {
    allowReboot = false;
    enable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  networking.firewall.enable = true;

  # Synchronise time and date
  services.chrony.enable = true;
  services.localtime.enable = true;
  services.geoclue2.enable = true;

  # Locate service
  services.locate.enable = true;
  services.locate.locate = pkgs.plocate;
  services.locate.localuser = null;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

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
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.defaultUserShell = pkgs.unstable.fish;
  users.users.mimame = {
    isNormalUser = true;
    description = "mimame";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs;
      [
        #  firefox
        #  thunderbird
      ];
  };

  # Enable automatic login for the user.
  services.xserver.displayManager = {
    lightdm.enable = true;
    autoLogin = {
      enable = true;
      user = "mimame";
    };
  };

  services.xserver.windowManager.i3.enable = true;

  services.gnome.gnome-keyring.enable = true;

  # TODO: fix locate.latitude
  # for that simply use geoclue2 in the config file instead a fixed latitude
  # services.redshift.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

    # zoom-us # timeout when downloading the package
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
    barrier
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
    dunst
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
    haskellPackages.greenclip
    unstable.helix
    hexyl
    htop
    unstable.httpie
    hugo
    unstable.hyperfine
    hyphen
    i3lock
    i3status-rust
    inkscape
    jc
    jekyll
    jq
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
    linuxKernel.kernels.linux_zen
    linuxKernel.packages.linux_zen.virtualbox
    litecli
    lnav
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
    nnn
    nodePackages.npm
    ntfs3g
    unstable.nushell
    unstable.obsidian
    onefetch
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
    podman
    podman-compose
    podman-tui
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
    qutebrowser
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
    sweet
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
    vagrant
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
    wmctrl
    xautolock
    xbanish
    unstable.xcape
    xclip
    xdg-user-dirs
    xdg-utils
    xdotool
    unstable.xh
    unstable.xonsh
    xsel
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

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    forwardX11 = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}