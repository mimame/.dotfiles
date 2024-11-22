{ pkgs, ... }:
{
  # Enable automatic time synchronization
  services.chrony.enable = true;
  services.automatic-timezoned.enable = true;

  # Start GeoClue2 daemon
  # enabled by services.automatic-timezoned.enable = true;
  # services.geoclue2.enable = true;
  # location.provider = "geoclue2";
  # https://github.com/NixOS/nixpkgs/issues/321121
  services.geoclue2 = {
    geoProviderUrl = "https://beacondb.net/v1/geolocate";
    # submitData = true;
    # submissionUrl = "https://beacondb.net/v2/geosubmit";
  };
  services.geoclue2.appConfig.gammastep = {
    isAllowed = true;
    isSystem = true;
  };
}
