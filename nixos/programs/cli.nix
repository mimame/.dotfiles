{ pkgs, ... }:
{
  # Locate service
  services.locate = {
    enable = true;
    package = pkgs.unstable.plocate;
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
  # services.udev.packages = [ pkgs.unstable.espanso-wayland ];
  # services.udev.extraRules = ''
  #   KERNEL=="uinput", GROUP="input", OPTIONS+="static_node=uinput", MODE=0660
  # '';
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

  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    acceleration = "cuda";
    loadModels = [ "gemma3" ];
  };
  services.nextjs-ollama-llm-ui.enable = true;

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "mimame";
    dataDir = "/home/mimame";
  };

  programs.mosh.enable = true;

  # programs.fuse
  programs.fuse.userAllowOther = true;

  environment.systemPackages =
    with pkgs;
    [

      at
      avfs
      axel
      bc
      bind
      # (buku.override { withServer = true; })
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
      # python3Packages.howdoi
      rustscan
      strace
      stress
      systeroid
      tailspin
      termscp
      tesseract5
      time
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
      bzip3
      carapace
      chafa
      choose
      clifm
      comma
      convco
      copyq
      ctop
      curl
      curlie
      ddgr
      delta
      difftastic
      direnv
      diskus
      dogdns
      dool
      dos2unix
      dotter
      du-dust
      dua
      duf
      dura
      dysk
      emacs
      entr
      erdtree
      evil-helix
      eza
      fastfetch
      fd
      fend
      file
      frawk
      fx
      fzf
      gawk
      gcc
      gdu
      gfold
      ghostscript
      ghostty
      git-extras
      gitFull
      github-cli
      gitoxide
      gitu
      gitui
      glow
      goawk
      gomi
      gopass
      gpg-tui
      gping
      grex
      gron
      grpcurl
      gzip
      halp
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
      libsecret
      lnav
      lsd
      lshw
      lychee
      massren
      mcfly
      mermaid-cli
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
      nix-direnv
      nix-index
      nix-tree
      nix-update
      nixos-generators
      (nnn.override { withNerdIcons = true; })
      nvme-cli
      oha
      onefetch
      ouch
      ov
      oxker
      pandoc
      pastel
      pay-respects
      pbzip2
      pciutils
      pdftk
      pigz
      pixz
      poop
      poppler_utils
      postgresql
      pre-commit
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
      smartmontools
      spacer
      speedtest-go
      sshfs
      starship
      stow
      tealdeer
      television
      testdisk
      tokei
      topgrade
      translate-shell
      trash-cli
      tre-command
      tree
      trurl
      tz
      udiskie
      ueberzugpp
      unar
      unrar
      unzip
      urlscan
      util-linux
      uutils-coreutils-noprefix
      vifm
      visidata
      vivid
      watchexec
      wezterm
      wget2
      xan
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
