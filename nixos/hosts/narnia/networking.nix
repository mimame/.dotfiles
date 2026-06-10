# ----------------------------------------------------------------------------
# Networking Configuration for Narnia (Tongfang GK5CN6Z / Recoil II)
#
# Host-specific networking tweaks to silence hardware-specific log noise.
# ----------------------------------------------------------------------------
_: {
  boot.kernel.sysctl = {
    # Per-interface IPv6 RA suppression for Narnia's physical interfaces.
    #
    # WHY: The kernel attempts to process RAs before NetworkManager takes
    # control, causing "ndisc_router_discovery failed to add default route"
    # log spam. hardware/networking.nix already sets all/default with mkDefault;
    # these per-interface keys are the host-specific addition that silences the
    # noise on the actual interfaces present on this machine.
    "net.ipv6.conf.enp4s0.accept_ra" = 0; # Ethernet
    "net.ipv6.conf.wlp5s0.accept_ra" = 0; # Wi-Fi
  };
}
