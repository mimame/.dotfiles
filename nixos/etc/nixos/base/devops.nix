{ pkgs, ... }: {

  # Virtualisation
  virtualisation = {
    podman = {
      enable = true;
      dockerSocket.enable = true;
      dockerCompat = true;
    };
    lxc = {
      enable = true;
      lxcfs.enable = true;
    };
    lxd = { enable = true; };
    virtualbox = {
      host = {
        enable = true;
        enableExtensionPack = true;
      };
      guest = { enable = false; };
    };
  };

  programs.singularity = {
    enable = true;
    enableSuid = true;
    enableFakeroot = true;
  };

  security.sudo = {
    # Configure podman to be use by minikube
    extraRules = [{
      users = [ "mimame" ];
      commands = [{
        command = "/run/current-system/sw/bin/podman";
        options = [ "NOPASSWD" ];
      }];
    }];
  };

  environment.systemPackages = with pkgs;
    [

    ] ++ (with pkgs.unstable; [

      grafana
      grafana-loki
      kubernetes
      minikube
      packer
      podman-tui
      prometheus
      vagrant

    ]);
}
