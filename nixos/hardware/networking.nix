# ------------------------------------------------------------------------------
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
{ hostname, ... }:
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
    hostName = hostname;
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

  # wpa_supplicant is known to have issues with Wi-Fi after hibernation.
  # This option forces wpa_supplicant to restart when the system wakes up,
  # which should fix the issue.
  # systemd.services.wpa_supplicant.serviceConfig = {
  #   Restart = "always";
  #   RestartSec = "5s";
  # };
  # powerManagement.resumeCommands = ''
  #   # Restart wpa_supplicant to fix Wi-Fi after hibernation
  #   systemctl restart wpa_supplicant
  #   systemctl restart systemd-resolved
  #   systemctl restart NetworkManager
  # '';

  services.resolved = {
    enable = true;
    # DNS-over-TLS (DoT) Configuration:
    # DoT encrypts DNS queries, enhancing privacy by preventing eavesdropping.
    # The `dnsovertls` option is set to "true", which enables opportunistic mode.
    #
    # In opportunistic mode, `systemd-resolved` attempts to use DoT. However,
    # if the server doesn't support it, or if an active attacker on the network
    # blocks the DoT connection (port 853), it will fall back to standard,
    # unencrypted DNS (port 53).
    #
    # This mode is vulnerable to active downgrade attacks.
    # It is chosen to prioritize reliability and compatibility across different
    # networks over strict security. It protects against passive eavesdropping,
    # but not an active man-in-the-middle attacker.
    #
    # A stricter setup would involve exclusively defining DoT-enabled servers in
    # `extraConfig` and potentially using firewall rules to block outgoing
    # unencrypted DNS traffic, but this can lead to connection failures on
    # restrictive networks.
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

    # Fallback DNS Configuration:
    # While it is possible to force specific DNS servers using `extraConfig`,
    # this can lead to network instability. For example, a mismatch between
    # a globally forced DNS (e.g., 1.1.1.1) and a network-provided DNS
    # (e.g., 8.8.8.8 from a Wi-Fi network) can cause resolution failures,
    # requiring a manual restart of the `systemd-resolved` service.
    #
    # To avoid this, we rely on the default `FallbackDNS` servers built into
    # `systemd-resolved`. This provides a reliable "just works" experience.
    # When `dnsovertls` is enabled, `systemd-resolved` automatically attempts
    # to use DNS-over-TLS with these fallback servers. It gracefully manages
    # connections by using DoT when available and falling back to standard DNS
    # when not, ensuring a balance of security and reliability. This approach,
    # combined with respecting DNS servers from the local network, ensures
    # seamless connectivity across different network environments.
    #
    # By default, systemd-resolved uses Cloudflare, Google, Quad9 and DNS0 Public DNS servers.
    # For more details, see: https://github.com/systemd/systemd/blob/main/docs/DISTRO_PORTING.md
    #
    # The following `extraConfig` examples are commented out to prevent DNS conflicts.
    # If you need to enforce a specific set of servers, uncomment one of them,
    # but be aware of the potential for network issues as described above.
    #
    # The first format provides a space-separated list of IP addresses.
    # extraConfig = ''
    #   # Cloudflare and Google DNS servers
    #   DNS=1.1.1.1 1.0.0.1 2606:4700:4700::1111 2606:4700:4700::1001 8.8.8.8 8.8.4.4 2001:4860:4860::8888 2001:4860:4860::8844
    # '';
    #
    # The second format (`IP#ServerName`) is used for DNS-over-TLS (DoT) to
    # authenticate the server. The part after the '#' is the server's
    # authentication domain name, which is used to verify its TLS certificate.
    # This ensures you are connecting to the intended DNS server.
    extraConfig = ''
      # DNS servers with hostnames for verification
      DNS = 1.1.1.1#cloudflare-dns.com 8.8.8.8#dns.google 1.0.0.1#cloudflare-dns.com 8.8.4.4#dns.google 2606:4700:4700::1111#cloudflare-dns.com 2001:4860:4860::8888#dns.google 2606:4700:4700::1001#cloudflare-dns.com 2001:4860:4860::8844#dns.google
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

  # OpenSSH daemon configuration
  services.openssh = {
    enable = true;
    settings = {
      # --- Security Hardening ---
      # Disable password-based login to enforce key-based authentication.
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      # Prevent root login to minimize attack surface.
      PermitRootLogin = "no";
      # Disable X11 forwarding as it is not needed for Wayland and reduces risk.
      X11Forwarding = false;

      # --- Performance Optimizations ---
      # Disable DNS lookups (performing a reverse DNS lookup and then a forward
      # DNS lookup to see if the IP matches the hostname) to speed up connection time.
      UseDns = false;
      # Enable TCP KeepAlive to detect dead connections and prevent timeouts.
      TCPKeepAlive = true;
    };

    # --- Cryptographic Policy ---
    # Explicitly configure modern, high-performance, and secure algorithms.
    # - KexAlgorithms: Prioritize Curve25519 for fast and secure key exchange.
    # - Ciphers: Prioritize ChaCha20-Poly1305 (fast without AES-NI) and AES-GCM.
    # - MACs: Use EtM (Encrypt-then-MAC) modes for superior integrity protection.
    extraConfig = ''
      KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256
      Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
      MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com
    '';
    # Automatically open ports in the firewall for SSH
    openFirewall = true;
  };

  # --- SSH Agent Configuration ---
  #
  # This provides a robust, system-wide agent that keychain can manage,
  # avoiding conflicts with the GNOME GCR agent and fixing repeated passphrase prompts.
  programs.ssh.startAgent = true;

  # Global Environment Variables
  # Setting SSH_AUTH_SOCK here ensures all system processes (including
  # those not started from a shell) can reach the systemd SSH agent.
  environment.variables = {
    SSH_AUTH_SOCK = "/run/user/1000/ssh-agent";
  };

  environment.systemPackages = [ ];
}
