{ }:
{

  # Update the CPU microcode for Intel processors
  hardware.cpu.intel.updateMicrocode = true;

  # Prevent overheating of Intel CPUs and improve performance
  services.thermald.enable = true;

  # Improve battery scaling the CPU governor and optimizing the general power
  services.auto-cpufreq.enable = true;

}
