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

    # Kernel sysctl tuning for performance and responsiveness
    kernel.sysctl = {
      # Memory Management
      # High swappiness for zram: prioritize compressed RAM over disk cache eviction
      "vm.swappiness" = 100;

      # Lower cache pressure to keep more metadata (inodes/dentries) in RAM
      # Speeds up recursive file operations (ls, fd, rg) by reducing filesystem lookups
      "vm.vfs_cache_pressure" = 50;

      # Start background writes early to prevent I/O bursts
      # With 31GB RAM, defaults (10/20) allow too much dirty data accumulation,
      # causing UI micro-stutters during large write operations
      "vm.dirty_background_ratio" = 5;
      "vm.dirty_ratio" = 15;

      # No static hugepages (using THP madvise mode via kernel parameter)
      "vm.nr_hugepages" = 0;

      # Network Performance
      # TCP BBR congestion control: focuses on bandwidth/RTT instead of packet loss
      # Significantly improves throughput and reduces latency
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";

      # Increase network queue for high-speed transfers
      "net.core.netdev_max_backlog" = 5000;

      # TCP Fast Open: allows data exchange during initial SYN packet
      # Reduces handshake latency for repeated connections
      "net.ipv4.tcp_fastopen" = 3;

      # Disable TCP slow-start after idle to improve responsiveness
      # When resuming activity (e.g., clicking link after reading), skip ramp-up
      "net.ipv4.tcp_slow_start_after_idle" = 0;

      # Network Buffers (16MiB max for high-speed connections)
      # Default Linux buffers are tuned for low-memory environments
      # Larger buffers prevent throughput bottlenecks on gigabit networks
      "net.core.rmem_max" = 16777216;
      "net.core.wmem_max" = 16777216;
      "net.ipv4.tcp_rmem" = "4096 87380 16777216";
      "net.ipv4.tcp_wmem" = "4096 65536 16777216";
    };

    # Kernel boot parameters (host-specific overrides in hosts/*/boot.nix)
    kernelParams = [
      # Desktop responsiveness: Full preemption for low latency
      # Allows high-priority tasks (like compositor) to interrupt background work immediately
      "preempt=full"

      # Transparent Huge Pages in madvise mode
      # Performance-critical apps (databases, compilers) can request 2MB pages
      # instead of 4KB, reducing translation overhead without bloating memory
      "transparent_hugepage=madvise"
      # Disable USB runtime autosuspend
      # WHY: A USB Billboard device (1-1.5, USB-C alt-mode indicator, no driver)
      # fails to resume from runtime suspend. When the system tries to enter S3,
      # the kernel must wake every device first, and this one returns EIO — which
      # aborts the entire suspend. Disabling autosuspend keeps the device active
      # during runtime so the S3 transition doesn't trip over it.
      "usbcore.autosuspend=-1"
    ];

    # Use tmpfs for /tmp (RAM-based temporary storage)
    # Faster than disk and automatically cleared on reboot
    tmp.useTmpfs = true;
  };

  # Use stable kernel by default
  # Previous attempts with latest kernel caused Btrfs corruption and VirtualBox issues
  # boot.kernelPackages = pkgs.linuxPackages_latest;
}
