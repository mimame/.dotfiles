# This module configures Btrfs-specific settings for the NixOS system.
# It enables periodic scrubbing to maintain data integrity and sets up
# transparent file compression to save disk space.
{ pkgs, ... }:

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
  #
  # Note: 'zstd' is the recommended default for modern CPUs, offering a great
  # balance between compression ratio and performance. 'noatime' is used to
  # reduce disk writes by disabling access-time updates.
  #
  # Optimizations for SSD/NVMe:
  # - 'ssd': Forces SSD-optimized block allocation patterns.
  # - 'discard=async': Offloads block discard (TRIM) to a background thread,
  #   preventing micro-stutters during heavy file deletions.
  # - 'space_cache=v2': A modern metadata system that speeds up free space
  #   lookups, improving performance as the drive fills up.
  #
  # Compression is applied only to newly written data. To recompress existing
  # files: 'sudo btrfs filesystem defrag -r -v -czstd /'
  fileSystems = {
    "/".options = [
      "compress=zstd"
      "noatime"
      "ssd"
      "discard=async"
      "space_cache=v2"
    ];
  };
  environment.systemPackages = with pkgs; [

    compsize

  ];
}
