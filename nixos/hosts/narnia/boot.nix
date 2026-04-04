# ----------------------------------------------------------------------------
# Boot Tuning for Narnia (Tongfang GK5CN6Z / Recoil II)
#
# Host-specific kernel parameters for Intel i7-8750H (Coffee Lake, 8th gen).
# These settings prioritize performance over security mitigations.
# ----------------------------------------------------------------------------
_: {
  boot.kernelParams = [
    # Security mitigations disabled for performance on older Intel CPU
    # WARNING: Reduces protection against Spectre/Meltdown vulnerabilities
    # Only appropriate for pre-10th gen Intel processors where mitigations
    # have significant performance impact
    "mitigations=off"
    "noibpb"
    "noibrs"
    "nopti"
    "nospectre_v1"
    "nospectre_v2"
    "nospec_store_bypass_disable"
    "no_stf_barrier"
    "l1tf=off"
    "mds=off"
    "tsx=on"
    "tsx_async_abort=off"
  ];
}
