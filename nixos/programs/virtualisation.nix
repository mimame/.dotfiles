{ pkgs, ... }:
{
  # Required kernel module for running virtual machines with LXC/LXD (incus).
  boot.kernelModules = [ "vhost_vsock" ];

  # --- Virtualisation and Containerization ---
  virtualisation = {
    # Podman: A daemonless container engine for developing, managing, and running OCI Containers.
    podman = {
      enable = true;
      autoPrune.enable = true; # Automatically prune unused resources.
      dockerSocket.enable = true; # Provide a Docker-compatible socket.
      dockerCompat = true; # Enable Docker compatibility.
      # Allow containers to resolve hostnames.
      defaultNetwork.settings = {
        dns_enabled = true;
      };
    };

    # LXC: A lightweight container and virtual machine manager.
    lxc = {
      enable = true;
      lxcfs.enable = true; # Filesystem for LXC containers.
    };

    # Incus: A modern, secure and powerful system container and virtual machine manager (a fork of LXD).
    incus = {
      enable = true;
      ui.enable = true; # Enable the web UI.
    };

    # VirtualBox: Host configuration for VirtualBox.
    virtualbox = {
      host = {
        enable = true;
        enableExtensionPack = false; # Avoids compilation from source.
      };
      guest.enable = false;
    };

    # Libvirt: A toolkit to manage virtualization platforms.
    # https://nixos.wiki/wiki/Libvirt
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.unstable.qemu_kvm; # Use the unstable QEMU package.
        runAsRoot = true;
        swtpm.enable = true; # Enable TPM emulation.
        ovmf = {
          enable = true; # Enable UEFI support for VMs.
          packages = [
            (pkgs.OVMFFull.override {
              secureBoot = true;
              tpmSupport = true;
            }).fd
          ];
        };
      };
    };

    # Enable SPICE USB redirection for VMs.
    spiceUSBRedirection.enable = true;
  };

  # virt-manager: A graphical user interface for managing virtual machines through libvirt.
  programs.virt-manager = {
    enable = true;
    package = pkgs.unstable.virt-manager;
  };

  # Apptainer (formerly Singularity): A container platform for HPC and enterprise.
  programs.singularity = {
    enable = true;
    enableFakeroot = true;
    enableSuid = true;
  };

  # --- Sudo Rules ---
  # FIXME: sudo-rs doesn't write to /etc/sudoers file the extraConfig and extraRules
  security.sudo = {
    # Allow running virtualization CLIs without a password.
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

  # --- System Packages ---
  environment.systemPackages =
    with pkgs;
    [
      # Tools for accessing and modifying virtual machine disk images.
      guestfs-tools
      libguestfs
      # vagrant # A tool for building and managing virtual machine environments.
    ]
    ++ (with pkgs.unstable; [
      # Cloud and Virtualization tools
      cloud-init # For bootstrapping cloud instances.
      cloud-utils # Utilities for cloud images.
      distrobox # Use any Linux distribution inside your terminal.
      virt-viewer # A lightweight UI for connecting to the graphical display of virtual machines.

      # Kubernetes and Container tools
      kompose # A conversion tool to go from Docker Compose to Kubernetes.
      kubectl # The Kubernetes command-line tool.
      kubernetes # The Kubernetes container orchestration system.
      kubernetes-helm # The Kubernetes package manager.
      minikube # A tool that runs a single-node Kubernetes cluster locally.
      podman-tui # A Terminal User Interface for Podman.
      ptyxis # A container-based terminal.
      qemu-utils # Let lxc to create --vm

      # Disabled packages
      # qemu_test
    ]);
}
