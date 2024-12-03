{ config, ... }:
{

  # Update the CPU microcode for Intel processors
  hardware.cpu.intel.updateMicrocode = true;

  # Prevent overheating of Intel CPUs and improve performance
  services.thermald.enable = true;

  # Improve battery scaling the CPU governor and optimizing the general power
  services.auto-cpufreq.enable = true;

  # Distribute hardware interrupts across processors on a multiprocessor system in order to increase performance
  # https://wiki.archlinux.org/title/Improving_performance#irqbalance
  services.irqbalance.enable = true;

}
