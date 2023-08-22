{ pkgs, ... }: {

  # lxc required module for running proper VMs
  boot.kernelModules = [ "vhost_vsock" ];

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
    lxd.enable = true;
    virtualbox = {
      host = {
        enable = true;
        enableExtensionPack = false; # Avoid compilation
      };
      guest.enable = false;
    };
    libvirtd.enable = true;
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
      commands = [
        {
          command = "/run/current-system/sw/bin/podman";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/lxc";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/lxd";
          options = [ "NOPASSWD" ];
        }
      ];
    }];
  };

  environment.systemPackages = with pkgs;
    [

      qemu_test
      qemu-utils # Let lxc to create --vm

    ] ++ (with pkgs.unstable; [

      grafana
      grafana-loki
      kubernetes
      minikube
      packer
      podman-tui
      prometheus
      pulumi-bin
      terraform
      vagrant

    ]);
}
