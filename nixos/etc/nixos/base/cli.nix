{ pkgs, ... }: {
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
    mtr.enable = true;
    wireshark.enable = true;
  };

  # Enable Espanso
  security.wrappers.espanso = {
    capabilities = "cap_dac_override+p";
    source = "${pkgs.espanso-wayland.out}/bin/espanso";
    owner = "root";
    group = "input";
  };

  # Maybe not needed
  services.udev.packages = [ pkgs.espanso-wayland ];
  services.udev.extraRules = ''
    KERNEL=="uinput", GROUP="input", OPTIONS+="static_node=uinput", MODE=0660
  '';
  # systemd unit for espanso not working using sway instead
  # systemd = {
  #   user.services = {
  #     espanso-wayland = {
  #       enable = true;
  #       description = "espanso-wayland";
  #       wants = [ "default.target" ];
  #       wantedBy = [ "default.target" ];
  #       after = [ "default.target" ];
  #       serviceConfig = {
  #         Type = "simple";
  #         ExecStart = "${pkgs.espanso-wayland}/bin/espanso worker";
  #         Restart = "on-failure";
  #         RestartSec = 3;
  #         TimeoutStopSec = 10;
  #       };
  #     };
  #   };
  # };

  environment.systemPackages = with pkgs;
    [

      at
      avfs
      axel
      bc
      bind
      dosfstools
      espanso-wayland
      fakeroot
      httpie
      jc
      libarchive
      lnav
      lsb-release
      lsof
      ntfs3g
      openssl
      parallel
      parted
      pkg-config
      putty
      pv
      pwgen
      python3Packages.howdoi
      python3Packages.pip
      rustscan
      rustup
      strace
      stress
      sudo
      tesseract5
      time
      util-linux
      xdg-user-dirs
      xdg-utils

    ] ++ (with pkgs.unstable; [

      aria2
      bat
      bitwarden-cli
      broot
      brotli
      btop
      bzip2
      clifm
      coreutils
      curl
      curlie
      delta
      difftastic
      direnv
      diskus
      dogdns
      dos2unix
      dstat
      dua
      duf
      dura
      entr
      exa
      fd
      file
      fuse-common
      fzf
      gawk
      gcc
      gdu
      git
      git-extras
      github-cli
      gitoxide
      gitui
      glow
      gomi
      gpg-tui
      grc
      grex
      gron
      gzip
      handlr
      helix
      hexyl
      hyperfine
      imagemagick
      jless
      jq
      just
      kitty
      kubernetes
      lazydocker
      lazygit
      litecli
      lsd
      massren
      mcfly
      mdcat
      micro
      minikube
      navi
      ncdu_2
      neofetch
      neovim
      newsboat
      ninja
      (nnn.override { withNerdIcons = true; })
      nodejs
      nodePackages.npm
      onefetch
      ouch
      pandoc
      pdftk
      pigz
      pixz
      podman-tui
      poppler_utils
      postgresql
      pre-commit
      procs
      progress
      pueue
      ranger
      rclone
      ripgrep
      rlwrap
      rsync
      scc
      sd
      spacer
      sqlite
      sqlite-utils
      sshfs
      starship
      stow
      tealdeer
      tectonic
      testdisk
      thefuck
      tokei
      topgrade
      translate-shell
      trash-cli
      tree
      tz
      udiskie
      unrar
      unzip
      urlscan
      vagrant
      vifm
      visidata
      vivid
      watchexec
      wezterm
      wget
      xarchiver
      xh
      xonsh
      xplr
      zellij
      zenith
      zig
      zip
      zlib-ng
      zola
      zoxide
      zstd

    ]);
}
