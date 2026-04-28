# ----------------------------------------------------------------------------
# CPU Configuration for Narnia (Tongfang GK5CN6Z / Recoil II)
#
# Hardware: Intel Core i7-8750H (Coffee Lake, 6-core, 2018)
# - Base: 2.2 GHz, Boost: 4.1 GHz
# - TDP: 45W (configurable via throttled service)
# - Features: Intel UHD 630 iGPU, 12MB cache
#
# This module configures CPU-specific settings for this specific laptop,
# including microcode updates, thermal management, and power optimization.
# ----------------------------------------------------------------------------
_: {
  hardware.cpu.intel.updateMicrocode = true;

  boot.kernelParams = [
    # Use Intel's modern hardware P-state driver for better frequency scaling.
    # Provides more responsive CPU frequency adjustments than legacy ACPI.
    "intel_pstate=active"
  ];

  nix.settings = {
    # Limit builds to prevent extreme fan noise on this 6-core/12-thread laptop.
    # By using 1 job and 4 cores, we keep 8 threads free for system responsiveness
    # and significantly reduce heat generation during large compilations.
    max-jobs = 1;
    cores = 4;
  };

  services = {
    # Fix Intel CPU power limit throttling issues on Tongfang chassis.
    # Prevents premature thermal throttling during sustained workloads.
    throttled.enable = true;

    # Thermal management daemon for Intel CPUs.
    # Monitors temperatures and adjusts cooling policy to prevent overheating.
    # Complements power-profiles-daemon by handling hardware safety.
    thermald.enable = true;

    # Desktop power profile management via D-Bus API.
    # Provides user-controlled Performance/Balanced/Power Saver modes.
    # Preferred over auto-cpufreq for desktop environments with explicit control.
    power-profiles-daemon = {
      enable = true;
      # Set to balanced to prevent "scary" fan noise during heavy builds.
      # WHY: The i7-8750H in this chassis can hit 88°C+ during CUDA decompression
      # if allowed to boost aggressively in 'performance' mode.
      defaultProfile = "balanced";
    };

    # Conflicts with power-profiles-daemon - explicitly disabled.
    auto-cpufreq.enable = false;

    # Distribute hardware interrupts across CPU cores for better responsiveness.
    # Prevents I/O bottlenecks on single cores during high interrupt loads.
    irqbalance.enable = true;
  };
}
