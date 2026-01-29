_: {
  boot = {
    # --------------------------------------------------------------------------
    # Bootloader Configuration
    #
    # Configures the bootloader for UEFI systems. Systemd-boot is chosen for its
    # simplicity and integration with systemd.
    # --------------------------------------------------------------------------
    loader = {
      # Use systemd-boot as the bootloader.
      systemd-boot = {
        enable = true;
        # Add a boot menu option for Memtest86+, a memory testing tool.
        memtest86.enable = true;
      };

      # Configure EFI settings.
      efi = {
        # Allow the bootloader to write to EFI variables. This is necessary for
        # managing boot entries automatically.
        canTouchEfiVariables = true;
        # Specify the mount point for the EFI System Partition (ESP).
        efiSysMountPoint = "/boot/efi";
      };
    };

    # --------------------------------------------------------------------------
    # Kernel Runtime Parameters (Sysctl)
    # --------------------------------------------------------------------------
    kernel.sysctl = {
      # For zram swap, a high swappiness is recommended (e.g., 100-180) to
      # prioritize compressed RAM over disk cache eviction.
      "vm.swappiness" = 100;

      # Reduce VFS cache pressure (default 100). Lower values (e.g., 50) keep
      # more metadata (inodes/dentries) in RAM. This leverages the abundance
      # of system RAM to speed up recursive file operations (ls, fd, rg).
      "vm.vfs_cache_pressure" = 50;

      # Memory Writeback tuning:
      # These control how data changed in RAM is written to the SSD.
      # - dirty_background_ratio: Start background writes when 5% of RAM is dirty.
      # - dirty_ratio: Block new writes when 15% of RAM is dirty.
      # With 31Gi RAM, defaults (10/20) allow too much data to accumulate,
      # leading to massive I/O bursts that can cause UI micro-stutters.
      "vm.dirty_background_ratio" = 5;
      "vm.dirty_ratio" = 15;

      # Enable Transparent Huge Pages (THP) support. Note: The mode is set via
      # kernelParams. This ensures no static hugepages are pre-reserved.
      "vm.nr_hugepages" = 0;

      # Enable TCP BBR Congestion Control. Unlike traditional loss-based
      # algorithms, BBR focuses on actual bandwidth and RTT, significantly
      # improving throughput and reducing latency on most network types.
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";

      # Network Queue Tuning:
      # Increase max backlog to handle packet bursts during high-speed transfers.
      # While the default (1000) is often sufficient for home gigabit, 5000
      # provides extra headroom for high-load development scenarios.
      "net.core.netdev_max_backlog" = 5000;

      # Enable TCP Fast Open (TFO). This allows data exchange during the
      # initial SYN packet, reducing handshake latency for repeated connections.
      "net.ipv4.tcp_fastopen" = 3;

      # Keep TCP connections "hot" by avoiding slow-start after idle periods.
      # While slow-start exists to prevent network congestion, disabling it
      # on a desktop workstation improves perceived responsiveness when
      # resuming activity (e.g., clicking a link after reading a long page).
      "net.ipv4.tcp_slow_start_after_idle" = 0;

      # Increase TCP read/write buffer sizes (16MiB max).
      # Default Linux buffers are tuned for low-memory environments. Leveraging
      # the 31Gi RAM workstation setup, larger buffers prevent throughput
      # bottlenecks on high-speed fiber/gigabit networks, ensuring stable
      # and maximum speed during large file transfers and media streaming.
      "net.core.rmem_max" = 16777216;
      "net.core.wmem_max" = 16777216;
      "net.ipv4.tcp_rmem" = "4096 87380 16777216";
      "net.ipv4.tcp_wmem" = "4096 65536 16777216";
    };

    # --------------------------------------------------------------------------
    # Kernel Boot Parameters
    #
    # Disables various CPU speculative execution mitigations to improve
    # performance. This can be particularly beneficial on older Intel CPUs
    # (pre-10th gen).
    #
    # WARNING: Disabling these mitigations introduces security risks, as it could
    # allow sensitive information (e.g., cryptographic secrets) to leak between
    # different tasks on the system. This configuration prioritizes performance
    # over security from these specific hardware vulnerabilities.
    #
    # For more details on kernel parameters, see:
    # https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html
    # --------------------------------------------------------------------------
    kernelParams = [
      # Set the kernel preemption model to 'full' for better desktop
      # responsiveness. This ensures high-priority tasks (like Niri) can
      # interrupt lower-priority background work immediately.
      "preempt=full"

      # Enable Transparent Huge Pages (THP) in 'madvise' mode.
      # This allows performance-critical applications (DBs, compilers) to
      # request 2MB memory pages instead of 4KB, reducing translation overhead
      # without causing memory bloat in smaller processes.
      "transparent_hugepage=madvise"

      # Generic toggle for all mitigations
      "mitigations=off" # Disables a wide range of security mitigations (Spectre, Meltdown, etc.).

      # Spectre & Meltdown related mitigations
      "noibpb" # Disables Indirect Branch Prediction Barrier.
      "noibrs" # Disables Indirect Branch Restricted Speculation.
      "nopti" # Disables Kernel Page Table Isolation (Meltdown mitigation).
      "nospectre_v1" # Disables Spectre Variant 1 mitigation.
      "nospectre_v2" # Disables Spectre Variant 2 mitigation.
      "nospec_store_bypass_disable" # Disables Speculative Store Bypass mitigation.
      "no_stf_barrier" # Disables Store-to-Load Forwarding barrier.

      # Other hardware vulnerability mitigations
      "l1tf=off" # Disables L1 Terminal Fault (L1TF) mitigation.
      "mds=off" # Disables Microarchitectural Data Sampling (MDS) mitigation.

      # Performance-related tweaks
      "tsx=on" # Enables Transactional Synchronization Extensions (TSX) for better performance.
      "tsx_async_abort=off" # Disables a specific TSX mitigation (Async Abort).
    ];

    # --------------------------------------------------------------------------
    # Temporary Files Management
    # --------------------------------------------------------------------------
    # Use tmpfs for /tmp to keep temporary files in RAM.
    tmp.useTmpfs = true;
    # Clears the /tmp directory on every boot (handled by tmpfs automatically).
    # tmp.cleanOnBoot = true;
  };

  # ----------------------------------------------------------------------------
  # Kernel Selection
  #
  # The stable Linux kernel is used by default to avoid potential issues with
  # newer, less-tested versions. For example, previous attempts to use the
  # latest kernel resulted in Btrfs corruption and broken VirtualBox support.
  # ----------------------------------------------------------------------------
  # boot.kernelPackages = pkgs.linuxPackages_latest;

}
