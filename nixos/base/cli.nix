{ pkgs, ... }:
{
  # Locate service
  services.locate = {
    enable = true;
    package = pkgs.unstable.plocate;
    localuser = null;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = false; # Don't allow to use empty passphrases
    };
    java.enable = true;
    mtr.enable = true;
    wireshark.enable = true;
  };

  # Enable Espanso

  # FIXME: Enable after https://github.com/NixOS/nixpkgs/pull/316519 is merged
  # services.espanso = {
  #   enable = true;
  #   package = pkgs.unstable.espanso-wayland;
  # };
  # security.wrappers.espanso = {
  #   capabilities = "cap_dac_override+p";
  #   source = "${pkgs.unstable.espanso-wayland.out}/bin/espanso";
  #   owner = "root";
  #   group = "input";
  # };

  # Maybe not needed
  services.udev.packages = [ pkgs.unstable.espanso-wayland ];
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
  #         ExecStart = "${pkgs.unstable.espanso-wayland}/bin/espanso worker";
  #         Restart = "on-failure";
  #         RestartSec = 3;
  #         TimeoutStopSec = 10;
  #       };
  #     };
  #   };
  # };

  services.ollama.enable = true;

  environment.systemPackages =
    with pkgs;
    [

      at
      avfs
      axel
      bc
      bind
      (buku.override { withServer = true; })
      dosfstools
      fakeroot
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
      strace
      stress
      tesseract5
      time
      util-linux
      xdg-user-dirs
      xdg-utils
    ]
    ++ (with pkgs.unstable; [

      any-nix-shell
      aria2
      artem
      atuin
      bat
      bitwarden-cli
      broot
      brotli
      btop
      bzip2
      carapace
      chafa
      choose
      clifm
      convco
      copyq
      coreutils
      ctop
      curl
      curlie
      ddgr
      delta
      devbox
      difftastic
      direnv
      diskus
      dogdns
      dos2unix
      dotter
      dstat
      dua
      du-dust
      duf
      dura
      dysk
      emacs29
      entr
      erdtree
      evil-helix
      eza
      fastfetch
      fd
      fend
      file
      frawk
      fuse-common
      fx
      fzf
      gawk
      gcc
      gdu
      gfold
      ghostscript
      git
      git-extras
      github-cli
      # gitoxide
      gitui
      glow
      goawk
      gomi
      gopass
      gpg-tui
      gping
      grc
      grex
      gron
      grpcurl
      gzip
      handlr
      hexyl
      httpie
      hurl
      hyperfine
      imagemagick
      inxi
      jaq
      jc
      jless
      jnv
      jp2a
      jq
      jujutsu
      just
      kitty
      lazydocker
      lazygit
      libarchive
      libqalculate
      lnav
      lsd
      lshw
      massren
      mcfly
      mdcat
      micro
      miniserve
      moar
      monolith
      navi
      ncdu_2
      neofetch
      neovim
      newsboat
      ninja
      nix-tree
      (nnn.override { withNerdIcons = true; })
      oha
      onefetch
      ouch
      ov
      oxker
      pandoc
      pastel
      pciutils
      pdftk
      pigz
      pixz
      poop
      poppler_utils
      postgresql
      procs
      progress
      pueue
      # qsv
      ranger
      rclone
      ripgrep
      rlwrap
      rnr
      rsync
      ruplacer
      scc
      sd
      sequoia-sq
      spacer
      speedtest-go
      sqlite
      sqlite-utils
      sshfs
      starship
      stow
      systeroid
      tailspin
      tealdeer
      tectonic
      termscp
      testdisk
      thefuck
      tokei
      topgrade
      translate-shell
      trash-cli
      tre-command
      tree
      tz
      udiskie
      unar
      unrar
      unzip
      urlscan
      vifm
      visidata
      vivid
      watchexec
      wezterm
      wget2
      xh
      xonsh
      xplr
      yazi
      yq
      zellij
      zenith
      zip
      zlib-ng
      zola
      zoxide
      zstd
    ]);
}
