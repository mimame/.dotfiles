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

  services.jenkins = {
    enable = false;
    withCLI = true;
    extraGroups = [ "podman" "docker" ];
  };

  environment.systemPackages = with pkgs;
    [

      qemu_test
      qemu-utils # Let lxc to create --vm

    ] ++ (with pkgs.unstable; [

      awscli # v1 for awslocal localstack compatibility
      grafana
      grafana-loki
      kompose
      kubectl
      kubernetes
      kubernetes-helm
      localstack
      minikube
      nodePackages.serverless
      packer
      podman-tui
      prometheus
      pulumi-bin
      python3Packages.boto3
      python3Packages.localstack
      terraform
      vagrant

    ]);
}
