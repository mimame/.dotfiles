# ----------------------------------------------------------------------------
# Networking Configuration
#
# WHY NetworkManager + wpa_supplicant + systemd-resolved?
#
# After extensive testing, this combination has proven most robust for:
# - Reliable suspend/hibernate Wi-Fi recovery (iwd fails to auto-reconnect)
# - Stable mobile tethering (connman has connection cycle issues)
# - DNS-over-TLS with systemd-resolved (simpler than unbound for desktop use)
#
# The iwd/connman/unbound stack, while modern, showed these problems:
# - iwd: Still experimental, requires manual service restart after suspend
# - connman: Less intuitive, inconsistent with tethering
# - unbound: Too strict for captive portals, causes resolution failures
# ----------------------------------------------------------------------------
{ hostname, ... }:
{
  networking = {
    hostName = hostname;
    nftables.enable = true; # Required for Incus on NixOS (iptables unsupported)
    firewall = {
      enable = true;
      allowedUDPPorts = [ ];
      allowedTCPPorts = [ ];
      trustedInterfaces = [
        "incusbr0" # Incus container bridge
        "virbr0" # libvirt default network
        "virbr1" # libvirt additional network
      ];
    };
  };

  networking.networkmanager = {
    enable = true;
    wifi.backend = "wpa_supplicant"; # More reliable after suspend than iwd
    dns = "systemd-resolved";
  };

  # DNS-over-TLS (DoT) with systemd-resolved
  services.resolved = {
    enable = true;

    # Opportunistic DoT: Attempts encryption but falls back to unencrypted DNS
    # if the server doesn't support it or if blocked by network. This mode
    # protects against passive eavesdropping but NOT active downgrade attacks.
    # Chosen for reliability over strict security (works on all networks).
    dnsovertls = "true";

    # DNSSEC disabled: Many DNS servers are misconfigured and fail validation,
    # breaking domain resolution. Prioritizing reliability over validation.
    # Options: "false" (off), "true" (strict), "allow-downgrade" (pragmatic)
    # dnssec = "true";

    # Cloudflare and Google DNS with DoT authentication
    # Format: IP#ServerName where ServerName verifies TLS certificate
    extraConfig = ''
      DNS = 1.1.1.1#cloudflare-dns.com 8.8.8.8#dns.google 1.0.0.1#cloudflare-dns.com 8.8.4.4#dns.google 2606:4700:4700::1111#cloudflare-dns.com 2001:4860:4860::8888#dns.google 2606:4700:4700::1001#cloudflare-dns.com 2001:4860:4860::8844#dns.google
    '';
  };

  # OpenSSH daemon
  services.openssh = {
    enable = true;
    settings = {
      # Security hardening
      PasswordAuthentication = false; # Enforce key-based authentication
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no"; # Minimize attack surface
      X11Forwarding = false; # Not needed for Wayland, reduces risk

      # Performance optimizations
      UseDns = false; # Skip reverse DNS lookup, faster connections
      TCPKeepAlive = true; # Detect dead connections, prevent timeouts
    };

    # Modern cryptography prioritizing performance and security:
    # - KexAlgorithms: Curve25519 for fast, secure key exchange
    # - Ciphers: ChaCha20-Poly1305 (fast without AES-NI), AES-GCM (AEAD)
    # - MACs: EtM (Encrypt-then-MAC) for superior integrity protection
    extraConfig = ''
      KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256
      Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
      MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com
    '';
    openFirewall = true;
  };

  # Standard NixOS ssh-agent
  # Provides consistent SSH_AUTH_SOCK across all sessions (including systemd
  # services and non-interactive shells), allowing keychain to manage keys
  # without starting its own private agent.
  programs.ssh.startAgent = true;

  environment.systemPackages = [ ];
}
