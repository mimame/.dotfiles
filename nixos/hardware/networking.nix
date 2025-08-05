#------------------------------------------------------------------------------
#
# NETWORKING CONFIGURATION
#
# This module defines the networking stack for the system, prioritizing
# stability and reliability for a seamless daily-driver experience.
#
# ### Why NetworkManager + wpa_supplicant + systemd-resolved?
#
# After extensive testing, the combination of NetworkManager, wpa_supplicant,
# and systemd-resolved has proven to be the most robust and dependable solution for
# managing network connections on this system. This stack excels in scenarios
# where other configurations, particularly those involving `iwd` and `connman`,
# have shown instability.
#
# Key advantages of this setup include:
#
# - **Reliable Suspend/Hibernate Recovery:** Unlike `iwd`, which can struggle
#   to automatically reconnect to Wi-Fi networks after the system wakes from
#   sleep or hibernation, the `wpa_supplicant` backend for NetworkManager
#   handles these transitions flawlessly. This ensures that the network is
#   immediately available without manual intervention.
#
# - **Stable Tethering:** Mobile tethering, a frequent use case, is
#   significantly more reliable with NetworkManager. It gracefully handles
#   connection and disconnection cycles, which can be problematic with `connman`.
#
# - **Secure and Simple DNS:** `systemd-resolved` is used as the DNS backend to
#   provide simple, reliable, and secure DNS resolution with caching.
#   It is configured to use DNS-over-TLS (DoT) by default, encrypting all DNS
#   queries and enhancing privacy. While `unbound` offers more powerful
#   features, `systemd-resolved` provides a "just works" experience that is
#   perfectly integrated into the OS.
#
# ### The `iwd`, `connman`, and `unbound` Stack: A Note on Instability
#
# While `iwd` is a modern and promising replacement for `wpa_supplicant`, and
# `connman` is designed to be lightweight, this combination has exhibited the
# following issues in practice:
#
# - **`iwd`:** Still considered experimental by some distributions, it can fail
#   to auto-connect after suspend/hibernate, requiring manual restarts of the
#   service.
#
# - **`connman`:** Can be less intuitive for managing complex network setups
#   and has shown inconsistencies with tethered connections.
#
# - **`unbound`:** A powerful recursive resolver, but its strictness can lead
#   to resolution failures in public Wi-Fi or captive portal scenarios.
#
# For these reasons, the current configuration remains the recommended and
# default choice for this machine.
#
#------------------------------------------------------------------------------
{ pkgs, ... }:
{

  # Network
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  networking = {
    # Incus on NixOS is unsupported using iptables
    nftables.enable = true;
    firewall = {
      # Or disable the firewall altogether.
      enable = true;
      # Open ports in the firewall.
      allowedUDPPorts = [ ];
      allowedTCPPorts = [ ];
      trustedInterfaces = [
        "incusbr0"
        "virbr0"
        "virbr1"
      ];
    };
    hostName = "narnia";
    # wireless.iwd = {
    #   settings = {
    #     Network = {
    #       EnableIPv6 = true;
    #       RoutePriorityOffset = 300;
    #     };
    #     # Verify wifi connections have autoConnect in both iwd and connman configs
    #     Settings = {
    #       AutoConnect = true;
    #     };
    #   };
    # };
  };

  networking.networkmanager = {
    enable = true;
    wifi.backend = "wpa_supplicant";
    dns = "systemd-resolved";
  };

  services.resolved = {
    enable = true;
    # Use DNS-over-TLS
    dnsovertls = "true";

    # DNSSEC Validation:
    # DNSSEC cryptographically verifies that DNS responses are authentic. However,
    # many DNS servers in the wild are misconfigured and cause validation to fail,
    # which can make domains unreachable and break the user experience.
    # For this reason, systemd developers recommend caution.
    # The available options are:
    # - "false" (default): Disables validation. Maximizes compatibility.
    # - "true": Enforces strict validation. Most secure, but may break browsing.
    # - "allow-downgrade": A pragmatic compromise. It attempts validation but
    #   falls back to an insecure lookup if the server appears to be broken.
    # It is currently disabled to prioritize reliability over strict validation.
    # dnssec = "true";

    # Define the primary DNS servers using the `DNS=` setting. These will be
    # used with DNS-over-TLS and override any servers provided by the network.
    # The servers are listed in the order of Cloudflare, then Google.
    # - Cloudflare: 1.1.1.1, 1.0.0.1, 2606:4700:4700::1111, 2606:4700:4700::1001
    # - Google:     8.8.8.8, 8.8.4.4, 2001:4860:4860::8888, 2001:4860:4860::8844
    extraConfig = ''
      DNS=1.1.1.1 1.0.0.1 2606:4700:4700::1111 2606:4700:4700::1001 8.8.8.8 8.8.4.4 2001:4860:4860::8888 2001:4860:4860::8844
    '';
  };

  # services.connman = {
  #   enable = true;
  #   enableVPN = false;
  #   extraFlags = [ "--nodnsproxy" ];
  #   package = pkgs.connmanFull;
  #   wifi.backend = "iwd"; # iwd doesn't connect automatically after suspension/hibernation, still experimental
  # wifi.backend = "wpa_supplicant";
  # };

  # services.unbound = {
  #   enable = true;
  #   settings = {
  #     server = {
  #       interface = [ "127.0.0.1" ];
  #     };
  #     forward-zone = [
  #       {
  #         name = ".";
  #         forward-addr = [
  #           "1.1.1.1@853#cloudflare-dns.com"
  #           "1.0.0.1@853#cloudflare-dns.com"
  #           "8.8.8.8@853#dns.google"
  #           "8.8.4.4@853#dns.google"
  #         ];
  #       }
  #     ];
  #     remote-control.control-enable = true;
  #   };
  # };

  # OpenSSH daemon
  services.openssh = {
    enable = false;
    settings = {
      X11Forwarding = true;
    };
  };

  programs.ssh.startAgent = true;

  environment.systemPackages =
    with pkgs;
    [
      # cmst # QT connman GUI
      networkmanagerapplet
    ]
    ++ (with pkgs.unstable; [

    ]);
}
