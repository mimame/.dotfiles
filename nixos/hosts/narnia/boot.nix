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
    #
    # NOTE: mitigations=off covers all individual spectre/meltdown flags
    # (noibpb, noibrs, nopti, nospectre_v*, l1tf=off, mds=off, etc.) — no need
    # to list them separately. tsx=on is kept explicit: some kernels disable TSX
    # by default regardless of mitigations, so this ensures it stays enabled.
    "mitigations=off"
    "tsx=on"

    # Stability Fixes for Tongfang GK5CN6Z
    #
    # WHY: Disabling PCIe Active State Power Management (ASPM) prevents system
    # stutters and "NOHZ tick-stop" errors caused by aggressive power state
    # transitions on the PCIe bus. This is a common requirement for this chassis.
    "pcie_aspm=off"
  ];

  # ----------------------------------------------------------------------------
  # Swap strategy: disk-backed swap + zswap (NOT zram)
  # ----------------------------------------------------------------------------
  # GOAL: when RAM fills up, evict cold pages so applications keep running.
  #
  # ZRAM (previous setup, removed): a RAM-only block device formatted as swap.
  # Pages are compressed and kept in memory. Two problems for THIS machine:
  # 1. The compressed data still occupies real RAM — it competes with the
  #    workload it is supposed to relieve under sustained pressure.
  # 2. It evaporates on power-off, so it can never hold a hibernation image.
  # Worse, zramSwap.priority=100 meant it absorbed ALL swap traffic before the
  # disk partition: `swapon --show` confirmed nvme0n1p3 had 0 bytes used ever,
  # i.e. the hibernate target was dead weight while hibernating to it.
  #
  # ZSWAP (this setting): not a fake disk — a compression cache in front of the
  # REAL disk swap. Pages heading to disk are compressed into a RAM pool
  # (zstd, NixOS default; best ratio — matching modern workstation guidance).
  # Only when the pool is full do pages actually hit the SSD.
  # Net effect:
  # - Same speed benefit as zram for the hot-but-cold working set.
  # - Disk-backed overflow → the nvme0n1p3 partition gets real use → hibernate
  #   (resumeDevice in configuration.nix) works as designed.
  # - Fewer SSD writes than plain swap (pool absorbs most spill traffic).
  # - RAM pool is dynamic, so it self-limits instead of the fixed zram cap.
  #
  # Pair with vm.swappiness=100 (core/boot.nix): prefer spilling into the zswap
  # pool over letting RAM go idle. Tune empirically, not by instinct — if
  # /sys/class/zswap-control/pool_prefs shows rising fail/reject counts, the
  # pool is thrashing and swappiness should be LOWERED, not raised.
  boot.zswap.enable = true;
}
