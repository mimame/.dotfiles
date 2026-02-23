# ----------------------------------------------------------------------------
# Time, Timezone, and Location Services
#
# This file configures services related to keeping the system time accurate
# and automatically setting the timezone based on location.
# ----------------------------------------------------------------------------
_: {
  services = {
    # Enable Chrony for Network Time Protocol (NTP) synchronization.
    # This keeps the system clock accurate by syncing with a network of time servers.
    chrony = {
      enable = true;

      # Allow jumping (stepping) the clock if the drift is more than 1 second.
      # This ensures the time is corrected immediately after a long sleep/resume cycle,
      # instead of gradually adjusting it over many hours or days.
      # Syntax: makestep <threshold_seconds> <max_steps> (-1 = unlimited)
      extraConfig = ''
        makestep 1.0 -1
      '';
    };

    # Enable automatic timezone detection and setting.
    # This service uses a location provider to determine the system's geographical
    # location and sets the appropriate timezone.
    automatic-timezoned.enable = true;

    # ----------------------------------------------------------------------------
    # Geoclue2 Location Service
    #
    # Geoclue2 provides location information to applications. It is used by
    # `automatic-timezoned` for automatic screen temperature adjustments.
    #
    # See: https://github.com/NixOS/nixpkgs/issues/321121
    # ----------------------------------------------------------------------------
    geoclue2 = {
      enable = true;
      # Disable location sources that are not relevant for this device (e.g., 3G, CDMA).
      # This relies primarily on network-based location services.
      enable3G = false;
      enableCDMA = false;
      enableModemGPS = false;
      # Do not submit location data to upstream providers.
      submitData = false;

      # Grant specific applications access to location data.
      appConfig = {
      };
    };
  };

  location.provider = "geoclue2";
}
