{ config, ... }:
{

  # Bootloader
  boot.loader = {
    systemd-boot = {
      enable = true;
      memtest86.enable = true;
    };
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
  };

  # Disable all CPU possible mitigations, lead to performance gains, especially on older Intel CPUs (pre-10th gen)
  # The risk is that sensitive information, such as cryptographic secrets, could leak between different tasks on the system.
  # For typical embedded systems with two user levels, where a remote attacker can already compromise the non-privileged user,
  # enabling these mitigations provides no additional security.

  # l1tf=off: Disables the L1TF (L1 Terminal Fault) mitigation.
  # mds=off: Disables the Microarchitectural Data Sampling (MDS) mitigation.
  # mitigations=off: Disables a range of security mitigations, including Spectre and Meltdown.
  # no_stf_barrier: Disables the Store-to-Load Forwarding (STF) barrier mitigation.
  # noibpb: Disables the Indirect Branch Prediction Barrier (IBPB) mitigation.
  # noibrs: Disables the Indirect Branch Restricted Speculation (IBRS) mitigation.
  # nopti: Disables the Optimistic Timing Estimator (OTE) mitigation.
  # nospec_store_bypass_disable: Disables the Speculative Store Bypass (SSB) mitigation.
  # nospectre_v1 and nospectre_v2: Disable specific Spectre mitigations.
  # tsx=on: Enables Transactional Synchronization Extensions (TSX), a hardware feature that can improve performance.
  # tsx_async_abort=off: Disables a specific TSX mitigation.
  boot.kernelParams = [
    "l1tf=off"
    "mds=off"
    "mitigations=off"
    "no_stf_barrier"
    "noibpb"
    "noibrs"
    "nopti"
    "nospec_store_bypass_disable"
    "nospectre_v1"
    "nospectre_v2"
    "tsx=on"
    "tsx_async_abort=off"
  ];

  # Delete all files in /tmp during boot
  # boot.tmp.cleanOnBoot = true;

}
