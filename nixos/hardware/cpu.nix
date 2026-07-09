# ----------------------------------------------------------------------------
# CPU Configuration & Power Management
#
# Defaults for CPU-related services shared across all hosts. Host-specific
# overrides (e.g., enabling throttled for Tongfang laptops) go in the host's
# own configuration.
# ----------------------------------------------------------------------------
{ lib, ... }: {
  # Intel CPU Power Limit Throttling — off by default.
  # Only enable per-host where the Intel thermal bug applies (e.g., Tongfang).
  services.throttled.enable = lib.mkDefault false;
}
