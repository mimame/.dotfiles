# This module configures Btrfs-specific settings for the NixOS system.
# It enables periodic scrubbing to maintain data integrity and sets up
# transparent file compression to save disk space.
{ lib, pkgs, ... }:

{
  # Btrfs auto-scrubbing helps ensure data integrity by checking for and
  # repairing silent data corruption. It's scheduled to run monthly.
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };

  # Enables transparent file compression using the Zstandard algorithm (zstd)
  # for the root filesystem ("/"). This reduces the amount of disk space used.
  # Note: Compression is applied only to newly written data.
  # Existing data won't be compressed unless rewritten. (e.g., btrfs filesystem defrag -r -v -czstd /path)
  fileSystems = {
    "/".options = [ "compress=zstd" ];
  };
  environment.systemPackages = with pkgs; [

    compsize

  ];
}
