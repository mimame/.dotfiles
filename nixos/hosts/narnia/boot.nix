# ----------------------------------------------------------------------------
# Boot Tuning for Narnia (Tongfang GK5CN6Z / Recoil II)
#
# Host-specific kernel parameters for Intel i7-8750H (Coffee Lake, 8th gen).
# These settings prioritize performance over security mitigations.
# ----------------------------------------------------------------------------
_: {
  boot.kernelParams = [
    # Security mitigations disabled for performance on pre-10th gen Intel CPU
    #
    # WARNING: Reduces protection against Spectre/Meltdown CPU vulnerabilities
    #
    # WHY: These mitigations have significant performance impact on older Intel
    # processors (pre-10th gen). On Coffee Lake (i7-8750H), disabling them
    # provides noticeable improvement in CPU-intensive tasks.
    #
    # TRADE-OFF: Security vs Performance
    # - Risk: Potential information leakage between processes/users
    # - Benefit: Measurably better performance on daily tasks
    # - Justification: Single-user laptop, not a multi-tenant server
    #
    # Only appropriate for pre-10th gen Intel where mitigations are expensive.
    # Newer CPUs (10th gen+) have hardware fixes with minimal performance cost.
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
