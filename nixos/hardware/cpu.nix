# ----------------------------------------------------------------------------
# CPU Configuration & Power Management
#
# This file configures CPU-specific settings, including microcode updates,
# thermal management, and performance/power optimization services.
# ----------------------------------------------------------------------------
_:
{
  # Enable automatic updates for Intel CPU microcode.
  # This is crucial for applying security patches and stability fixes provided
  # by Intel to address hardware vulnerabilities and bugs.
  hardware.cpu.intel.updateMicrocode = true;

  # Enable the Thermal Daemon (thermald).
  # This service monitors and controls CPU temperatures to prevent overheating
  # and ensure optimal performance under load, especially for Intel CPUs.
  services.thermald.enable = true;

  # Enable auto-cpufreq for dynamic power management.
  # This tool automatically adjusts CPU governor and frequency settings based on
  # system load, optimizing for performance when needed and saving power when
  # idle. It is particularly effective for improving battery life on laptops.
  services.auto-cpufreq.enable = true;

  # Enable irqbalance to optimize interrupt handling.
  # This daemon distributes hardware interrupts (IRQs) across multiple CPU
  # cores, preventing a single core from being bottlenecked by I/O tasks.
  # This can improve overall system responsiveness and performance.
  # See: https://wiki.archlinux.org/title/Improving_performance#irqbalance
  services.irqbalance.enable = true;
}
