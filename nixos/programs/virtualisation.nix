# ----------------------------------------------------------------------------
# Virtualization & Containerization
#
# Container runtimes (Podman), VMs (libvirt, VirtualBox), and orchestration (Kubernetes).
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  # vhost_vsock: Required for LXC/Incus VMs
  boot.kernelModules = [ "vhost_vsock" ];

  virtualisation = {
    # Podman: Daemonless container engine (Docker alternative)
    # WHY Podman: No daemon, rootless by default, Docker-compatible
    podman = {
      enable = true;
      autoPrune.enable = true; # Clean up unused resources weekly
      dockerSocket.enable = true; # Docker-compatible socket
      dockerCompat = true; # `docker` command alias
      defaultNetwork.settings.dns_enabled = true; # Container DNS resolution
    };

    # LXC/Incus: System containers and VMs
    # WHY Incus: Modern fork of LXD with better security and features
    lxc = {
      enable = true;
      lxcfs.enable = true; # Filesystem for container /proc, /sys
    };
    incus = {
      enable = true;
      ui.enable = true; # Web UI for management
    };

    # VirtualBox: Desktop VM hypervisor
    # WHY no extension pack: Avoids compiling from source (slow)
    virtualbox.host = {
      enable = true;
      enableExtensionPack = false;
    };

    # Libvirt/QEMU: High-performance VMs with KVM
    # See: https://nixos.wiki/wiki/Libvirt
    libvirtd = {
      enable = true;
      # NSS integration: Resolve VM hostnames on host
      nss = {
        enable = true;
        enableGuest = true;
      };
      qemu = {
        runAsRoot = true;
        swtpm.enable = true; # TPM emulation for Windows 11
        vhostUserPackages = [ pkgs.virtiofsd ]; # Shared filesystem driver
      };
    };

    # SPICE: USB redirection for VMs (webcam, flash drives)
    spiceUSBRedirection.enable = true;
  };

  # VM management GUI
  programs.virt-manager.enable = true;

  # Apptainer (Singularity): HPC container runtime
  # WHY: Required for scientific computing workflows
  programs.singularity = {
    enable = true;
    enableFakeroot = true; # Unprivileged user namespaces
    enableSuid = true; # SUID for older kernels
  };

  environment.systemPackages =
    with pkgs;
    [
      # --- Container Tools ---
      distrobox # Run any Linux distro in a container
      podman-tui # Terminal UI for Podman

      # --- VM Tools ---
      quickemu # Quick QEMU VM launcher
      virt-viewer # VNC/SPICE viewer for VMs
      guestfs-tools # Disk image manipulation (mount, resize)
      libguestfs # Library for accessing VM disk images

      # --- Cloud/VM Utilities ---
      cloud-init # Cloud instance bootstrapping
      cloud-utils # Cloud image utilities

      # --- Kubernetes ---
      kompose # Docker Compose → Kubernetes converter
      kubectl # Kubernetes CLI
      kubernetes # Kubernetes control plane
      kubernetes-helm # Kubernetes package manager
      minikube # Local Kubernetes cluster
    ]
    ++ (with pkgs.unstable; [
      ptyxis # Container-based terminal emulator
    ]);
}
