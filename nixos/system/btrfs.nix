# ----------------------------------------------------------------------------
# Btrfs Filesystem Configuration
#
# Optimizes Btrfs performance with SSD settings, automatic scrubbing, and
# compression for space savings.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  # Btrfs scrub: Monthly data integrity check
  # WHY: Detects and repairs bit rot/corruption before data loss
  # See: https://btrfs.readthedocs.io/en/latest/btrfs-scrub.html
  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };

  # Btrfs mount options: SSD-optimized with compression
  # WHY:
  # - compress=zstd: Transparent compression saves space (~30-40% on typical data)
  # - noatime: Reduces write amplification by not updating access timestamps
  # - ssd: Forces SSD-optimized block allocation
  # - discard=async: Background TRIM prevents micro-stutters during deletes
  # - space_cache=v2: Modern metadata for fast free-space lookups
  # See: https://btrfs.readthedocs.io/en/latest/Administration.html#mount-options
  fileSystems."/".options = [
    "compress=zstd"
    "noatime"
    "ssd"
    "discard=async"
    "space_cache=v2"
  ];

  # compsize: Measure compression ratios
  # WHY: Useful to see actual space savings from compression
  environment.systemPackages = with pkgs; [
    compsize
  ];
}
