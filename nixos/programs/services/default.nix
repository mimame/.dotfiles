{ pkgs, username, ... }:

{
  services = {
    # Locate service
    locate = {
      enable = true;
      package = pkgs.unstable.plocate;
    };

    ollama = {
      enable = true;
      package = pkgs.ollama-cuda;
      acceleration = "cuda";
      loadModels = [ "gemma3" ];
    };

    # Ollama service for running large language models locally
    nextjs-ollama-llm-ui.enable = true; # Next.js UI for Ollama

    # Syncthing service for file synchronization
    syncthing = {
      enable = true;
      openDefaultPorts = true;
      user = "${username}";
      dataDir = "/home/${username}";
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false; # Don't allow to use empty passphrases
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
  # services.udev.packages = [ pkgs.espanso-wayland ];
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
  #         ExecStart = "${pkgs.espanso-wayland}/bin/espanso worker";
  #         Restart = "on-failure";
  #         RestartSec = 3;
  #         TimeoutStopSec = 10;
  #       };
  #     };
  #   };
  # };
}
