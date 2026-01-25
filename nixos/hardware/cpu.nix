# ----------------------------------------------------------------------------
# CPU Configuration & Power Management
#
# This file configures CPU-specific settings, including microcode updates,
# thermal management, and performance/power optimization services.
# ----------------------------------------------------------------------------
_: {
  # Enable automatic updates for Intel CPU microcode.
  # This is crucial for applying security patches and stability fixes provided
  # by Intel to address hardware vulnerabilities and bugs.
  hardware.cpu.intel.updateMicrocode = true;

  services = {
    # Enable the Thermal Daemon (thermald).
    # This service monitors and controls CPU temperatures to prevent overheating
    # and ensure optimal performance under load, especially for Intel CPUs.
    #
    # It is complementary to power-profiles-daemon: while the latter handles
    # user intent (Performance vs. Power Saver), thermald ensures hardware
    # safety by managing thermals more granularly than the default kernel logic.
    thermald.enable = true;

    # Enable power-profiles-daemon for standard desktop power management.
    # This is preferred for DMS Shell and modern desktops because it provides
    # a D-Bus API specifically designed for graphical interfaces.
    #
    # It solves two use cases:
    # 1. "Low Power" mode for manual or system-triggered battery saving.
    # 2. "Performance" mode to access hardware-specific high-performance states.
    #
    # Why not auto-cpufreq?
    # It lacks a D-Bus interface and operates automatically by monitoring CPU
    # usage, which can conflict with user intent (e.g., wanting to save power
    # even during high CPU tasks).
    power-profiles-daemon.enable = true;

    # Disable auto-cpufreq as it conflicts with power-profiles-daemon.
    auto-cpufreq.enable = false;

    # Enable irqbalance to optimize interrupt handling.
    # This daemon distributes hardware interrupts (IRQs) across multiple CPU
    # cores, preventing a single core from being bottlenecked by I/O tasks.
    # This can improve overall system responsiveness and performance.
    # See: https://wiki.archlinux.org/title/Improving_performance#irqbalance
    irqbalance.enable = true;
  };
}
