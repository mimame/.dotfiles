# ----------------------------------------------------------------------------
# Networking Configuration for Narnia (Tongfang GK5CN6Z / Recoil II)
#
# Host-specific networking tweaks to silence hardware-specific log noise.
# ----------------------------------------------------------------------------
_: {
  boot.kernel.sysctl = {
    # Ensure RAs are disabled for existing interfaces to silence immediate log spam.
    #
    # WHY: On Narnia, the kernel frequently attempts to process IPv6 Router
    # Advertisements (RAs) before NetworkManager (which handles them in userspace)
    # can take control. This leads to "ndisc_router_discovery failed to add
    # default route" spam. Explicitly disabling it per-interface silences this.
    "net.ipv6.conf.all.accept_ra" = 0;
    "net.ipv6.conf.default.accept_ra" = 0;
    "net.ipv6.conf.enp4s0.accept_ra" = 0; # Ethernet
    "net.ipv6.conf.wlp5s0.accept_ra" = 0; # Wi-Fi
  };
}
