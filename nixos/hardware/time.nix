{ pkgs, ... }:
{
  # Enable automatic time synchronization
  services.chrony.enable = true;
  services.automatic-timezoned.enable = true;

  # Start GeoClue2 daemon
  # enabled by services.automatic-timezoned.enable = true;
  # https://github.com/NixOS/nixpkgs/issues/321121
  location.provider = "geoclue2";
  services.geoclue2 = {
    enable = true;
    enable3G = false;
    enableCDMA = false;
    enableModemGPS = false;
    geoProviderUrl = "https://beacondb.net/v1/geolocate";
    # submit data, only possible with a GPS antenna
    submitData = false;
    # submissionUrl = "https://beacondb.net/v2/geosubmit";
  };
  services.geoclue2.appConfig.gammastep = {
    isAllowed = true;
    isSystem = true;
  };
}
