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

    # Incus: System containers and VMs
    # WHY Incus: Modern fork of LXD with better security and features
    # NOTE: The separate LXC service is NOT enabled — Incus manages its own
    #       LXC backend internally. Enabling both would cause conflicts.
    incus = {
      enable = true;
      agent.enable = true; # Host-guest integration for VMs (exec, file push)
      ui.enable = true; # Web UI for management
      # Preseed: Fully declarative Incus bootstrap, no manual `incus admin init`.
      # All three sections (storage_pools + networks + profiles) must be declared
      # together — preseed replaces the entire init. Omitting networks skips the
      # default bridge, and omitting profiles leaves the default profile without
      # a root disk or nic, making `incus launch` fail on first use.
      # WHY btrfs: Root fs is already btrfs — instant snapshots/clones,
      #            space-efficient container copies via subvolumes.
      #            Modest quota overhead is worth it for the perf gain.
      preseed = {
        storage_pools = [
          {
            name = "default";
            driver = "btrfs";
          }
        ];
        networks = [
          {
            name = "incusbr0";
            type = "bridge";
            config = {
              "ipv4.address" = "10.10.10.1/24";
              "ipv4.nat" = "true";
            };
          }
        ];
        profiles = [
          {
            name = "default";
            devices = {
              eth0 = {
                name = "eth0";
                network = "incusbr0";
                type = "nic";
              };
              root = {
                path = "/";
                pool = "default";
                type = "disk";
              };
            };
          }
        ];
      };
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
      distrobuilder # LXC/Incus system container image builder
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
      kubernetes-helm # Kubernetes package manager
      k3s # Lightweight K8s — run `k3s server` for a local cluster
    ]
    ++ (with pkgs.unstable; [
      ptyxis # Container-based terminal emulator
    ]);
}
