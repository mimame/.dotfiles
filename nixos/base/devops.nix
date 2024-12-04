{ pkgs, ... }:
{

  # lxc required module for running proper VMs
  boot.kernelModules = [ "vhost_vsock" ];

  # Virtualisation
  virtualisation = {
    podman = {
      enable = true;
      autoPrune.enable = true;
      dockerSocket.enable = true;
      dockerCompat = true;
      # containers and processes connected to this network can resolve hostnames
      defaultNetwork.settings = {
        dns_enabled = true;
      };
    };
    lxc = {
      enable = true;
      lxcfs.enable = true;
    };
    incus = {
      enable = true;
      ui.enable = true;
    };
    virtualbox = {
      host = {
        enable = true;
        enableExtensionPack = false; # Avoid compilation
      };
      guest.enable = false;
    };
    # https://nixos.wiki/wiki/Libvirt
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.unstable.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [
            (pkgs.OVMFFull.override {
              secureBoot = true;
              tpmSupport = true;
            }).fd
          ];
        };
      };
    };
    spiceUSBRedirection.enable = true;
  };

  # GUI for libvirtd
  programs.virt-manager = {
    enable = true;
    package = pkgs.unstable.virt-manager;
  };

  # apptainer
  programs.singularity = {
    enable = true;
    enableFakeroot = true;
    enableSuid = true;
  };

  security.sudo-rs = {
    # Configure podman to be use by minikube
    extraRules = [
      {
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
      }
    ];
  };

  services.jenkins = {
    enable = false;
    withCLI = true;
    extraGroups = [
      "podman"
      "docker"
    ];
  };

  # services.prometheus.enable = true;
  # services.grafana.enable = true;

  environment.systemPackages =
    with pkgs;
    [

      guestfs-tools
      libguestfs
      # vagrant

    ]
    ++ (with pkgs.unstable; [

      # awscli # v1 for awslocal localstack compatibility
      fly
      # grafana
      # grafana-loki
      kompose
      kubectl
      kubernetes
      kubernetes-helm
      # localstack
      minikube
      # nodePackages.serverless
      packer
      podman-tui
      # prometheus
      # pulumi-bin # terraform
      # python3Packages.localstack
      # qemu_test
      # qemu-utils # Let lxc to create --vm
      tenv # opentofu and terraform
    ]);
}
