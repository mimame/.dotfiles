# ----------------------------------------------------------------------------
# Intel CPU Power Limit Throttling Module (throttled)
#
# WHY THIS MODULE IS NEEDED:
# 1. Intel Thermal Bug: Many Intel-based laptops (especially Tongfang/OEM
#    chassis like Narnia) suffer from buggy MSR (Model Specific Register)
#    states that prematurely throttle the CPU power limits (PL1/PL2).
# 2. Performance Recovery: This service overrides these registers to ensure
#    the CPU can reach its rated TDP (45W for i7-8750H) without being stuck
#    at 15W or 25W after a thermal event.
#
# DEFAULT BEHAVIOR:
# - Global Default: Disabled. This prevents unexpected thermal spikes or
#   undervolt instability on systems that don't specifically need it.
# - Host-Specific: Enabled only on laptops known to have the throttling bug.
# ----------------------------------------------------------------------------
{ lib, config, ... }:
{
  config = {
    # Default behavior: disabled.
    # Must be explicitly enabled in host-specific configurations.
    services.throttled.enable = lib.mkDefault false;
  };
}
