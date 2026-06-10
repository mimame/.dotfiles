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
{ lib, hostname, ... }:
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

  # ----------------------------------------------------------------------------
  # Kernel Networking Tweaks
  # ----------------------------------------------------------------------------
  boot.kernel.sysctl = {
    # Disable kernel-level IPv6 Router Advertisement (RA) acceptance.
    # WHY: NetworkManager handles RAs in userspace. When the kernel also tries
    # to process them, it often fails to add redundant default routes, leading
    # to "ICMPv6: RA: ndisc_router_discovery failed to add default route" spam
    # in journalctl.
    "net.ipv6.conf.all.accept_ra" = lib.mkDefault 0;
    "net.ipv6.conf.default.accept_ra" = lib.mkDefault 0;

    # Disable kernel-level IPv6 autoconfiguration.
    # WHY: Prevents the kernel from trying to configure addresses automatically
    # when RAs are received. This is particularly important when forwarding is
    # enabled (for containers/VMs), as the kernel's RA handling can conflict
    # with NetworkManager's userspace management.
    "net.ipv6.conf.all.autoconf" = lib.mkDefault 0;
    "net.ipv6.conf.default.autoconf" = lib.mkDefault 0;
  };

  # DNS-over-TLS (DoT) with systemd-resolved
  services.resolved = {
    enable = true;

    # DNSSEC disabled: Many DNS servers are misconfigured and fail validation,
    # breaking domain resolution. Prioritizing reliability over validation.
    # Options: "false" (off), "true" (strict), "allow-downgrade" (pragmatic)
    # dnssec = "true";

    settings.Resolve = {
      # Opportunistic DoT: tries encryption, falls back to plaintext if unavailable.
      # Protects against passive eavesdropping but NOT active downgrade attacks.
      # Chosen for reliability over strict security (works on all networks).
      DNSOverTLS = "opportunistic";

      # Cloudflare and Google DNS with DoT authentication
      # Format: IP#ServerName where ServerName verifies TLS certificate
      DNS = "1.1.1.1#cloudflare-dns.com 8.8.8.8#dns.google 1.0.0.1#cloudflare-dns.com 8.8.4.4#dns.google 2606:4700:4700::1111#cloudflare-dns.com 2001:4860:4860::8888#dns.google 2606:4700:4700::1001#cloudflare-dns.com 2001:4860:4860::8844#dns.google";
    };
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

    openFirewall = true;
  };

  # Standard NixOS ssh-agent
  # Provides consistent SSH_AUTH_SOCK across all sessions (including systemd
  # services and non-interactive shells), allowing keychain to manage keys
  # without starting its own private agent.
  programs.ssh.startAgent = true;

  environment.systemPackages = [ ];
}
