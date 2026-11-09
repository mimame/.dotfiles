# ----------------------------------------------------------------------------
# Virtualization: Containers
#
# Container runtimes (Podman, Incus, Apptainer/Singularity) and orchestration
# tooling (Kubernetes). Split from virtualisation.nix (2026-11-09); the VM
# half lives in ./virtualisation-vm.nix.
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
      # NOTE: The agent runs INSIDE Incus guest images (virtio-9p config channel).
      # Enabling it on bare metal makes incus-agent.service fail-loop every 5s
      # ("9pnet_virtio: no channels available"). Guest integration
      # (incus exec, file push) comes from the guest image, not the host.
      agent.enable = false;
      ui.enable = true; # Web UI — run `incus webui` to open in browser; or set core.https_address (convention: :8443) for persistent access
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
  };

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

      # --- Kubernetes ---
      kompose # Docker Compose → Kubernetes converter
      kubernetes-helm # Kubernetes package manager
      k3s # Lightweight K8s (includes kubectl) — run `k3s server` for a local cluster
    ]
    ++ (with pkgs.unstable; [
      ptyxis # Container-based terminal emulator
    ]);
}
