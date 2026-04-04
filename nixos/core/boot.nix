# ----------------------------------------------------------------------------
# Boot Configuration
#
# Bootloader, kernel parameters, and system-wide runtime tuning for performance
# and desktop responsiveness on modern hardware.
#
# Host-specific settings (e.g., security mitigations) are in hosts/*/boot.nix
# ----------------------------------------------------------------------------
_: {
  boot = {
    # Bootloader: systemd-boot for UEFI systems
    loader = {
      systemd-boot = {
        enable = true;
        memtest86.enable = true;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };

    # Kernel sysctl tuning
    kernel.sysctl = {
      # Memory Management
      "vm.swappiness" = 100; # High swappiness for zram
      "vm.vfs_cache_pressure" = 50; # Keep more metadata in RAM
      "vm.dirty_background_ratio" = 5; # Start background writes early
      "vm.dirty_ratio" = 15; # Block writes before RAM fills
      "vm.nr_hugepages" = 0; # No static hugepages (using THP madvise)

      # Network Performance
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr"; # TCP BBR for better throughput
      "net.core.netdev_max_backlog" = 5000;
      "net.ipv4.tcp_fastopen" = 3;
      "net.ipv4.tcp_slow_start_after_idle" = 0;

      # Network Buffers (16MiB max for high-speed connections)
      "net.core.rmem_max" = 16777216;
      "net.core.wmem_max" = 16777216;
      "net.ipv4.tcp_rmem" = "4096 87380 16777216";
      "net.ipv4.tcp_wmem" = "4096 65536 16777216";
    };

    # Kernel boot parameters (host-specific overrides in hosts/*/boot.nix)
    kernelParams = [
      # Desktop responsiveness
      "preempt=full" # Full preemption for low latency
      "transparent_hugepage=madvise" # THP only when requested
    ];

    # Use tmpfs for /tmp (RAM-based temporary storage)
    tmp.useTmpfs = true;
  };

  # Use stable kernel by default (latest has caused Btrfs issues in the past)
  # boot.kernelPackages = pkgs.linuxPackages_latest;
}
