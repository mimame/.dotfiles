{ pkgs, ... }:
{

  # Use by default wpa_supplicant
  # Use by default unbound or dnsmasq
  # Use by default networkmanager if connman still do weird things

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
    wireless.iwd = {
      settings = {
        Network = {
          EnableIPv6 = true;
          RoutePriorityOffset = 300;
        };
        # Verify wifi connections have autoConnect in both iwd and connman configs
        Settings = {
          AutoConnect = true;
        };
      };
    };
  };

  networking.networkmanager = {
    enable = true;
    # wifi.backend = "iwd"; # iwd doesn't connect automatically after suspension/hibernation, still experimental
    wifi.backend = "wpa_supplicant";
    # dns = "unbound";
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
