# ----------------------------------------------------------------------------
# Networking Tools
#
# Network diagnostics, download utilities, HTTP clients, and remote access tools.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  # Network diagnostic programs
  programs = {
    mtr.enable = true; # Network diagnostic (traceroute + ping)
    wireshark.enable = true; # Network protocol analyzer
    mosh.enable = true; # Mobile Shell (SSH for unreliable networks)
  };

  environment.systemPackages =
    with pkgs;
    [
      # --- Core Network Utilities ---
      bind # DNS utilities (dig, host, nslookup)
      putty # SSH and Telnet client
      rustscan # Fast port scanner
    ]
    ++ (with pkgs.unstable; [
      # --- Download & Transfer ---
      aria2 # Multi-protocol download utility
      curl # URL data transfer tool
      curlie # curl + httpie UX
      rclone # Cloud storage sync
      rsync # Fast file-copying tool
      wget # Non-interactive downloader
      wget2 # Wget successor

      # --- Network Analysis & Diagnostics ---
      bluetui # Bluetooth TUI
      ddgr # DuckDuckGo from terminal
      doggo # Command-line DNS client
      gping # Ping with graph
      grpcurl # gRPC client
      httpie # User-friendly HTTP client
      is-fast # Website speed tester
      oha # HTTP load testing
      speedtest-go # Speed test CLI
      urlscan # Scan URLs for malicious activity
      wsdd # Web Service Discovery for SMB/Samba
      xh # Fast, friendly HTTP client

      # --- Remote Access & Tunneling ---
      lazyssh # SSH client TUI
      miniserve # Serve files over HTTP
      monolith # Save web pages as single HTML
      sshfs # Mount filesystems over SSH
    ]);
}
