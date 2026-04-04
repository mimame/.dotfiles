# ----------------------------------------------------------------------------
# Time, Timezone, and Location Services
#
# Configures NTP synchronization and automatic timezone detection.
# ----------------------------------------------------------------------------
_: {
  services = {
    # Chrony for Network Time Protocol (NTP) synchronization
    # Keeps system clock accurate by syncing with network time servers
    chrony = {
      enable = true;

      # Allow time jumps >1 second instead of gradual adjustment
      # Critical for fixing time after suspend/resume or long power-off periods.
      # Without this, the system would slowly adjust time over hours/days.
      # Syntax: makestep <threshold_seconds> <max_steps> (-1 = unlimited)
      extraConfig = ''
        makestep 1.0 -1
      '';
    };

    # Automatic timezone detection based on geographical location
    # Uses geoclue2 to determine location and set appropriate timezone
    automatic-timezoned.enable = true;

    # Geoclue2 location service
    # Provides location information for automatic-timezoned and other apps
    geoclue2 = {
      enable = true;

      # Disable location sources not relevant for laptop
      # Relies primarily on network-based location (Wi-Fi positioning)
      enable3G = false;
      enableCDMA = false;
      enableModemGPS = false;

      # Privacy: Do not submit location data to upstream providers
      submitData = false;

      # Application permissions (grant specific apps access to location)
      appConfig = { };
    };
  };

  location.provider = "geoclue2";
}
