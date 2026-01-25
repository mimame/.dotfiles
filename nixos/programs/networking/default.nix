{ pkgs, ... }:

{
  # Network diagnostic tools
  programs.mtr.enable = true; # Network diagnostic tool
  programs.wireshark.enable = true; # Network protocol analyzer
  programs.mosh.enable = true; # Mobile Shell

  environment.systemPackages =
    with pkgs;
    [
      # Network utilities
      bind # DNS utilities (dig, host, nslookup)
      putty # SSH and Telnet client
      rustscan # Fast port scanner
    ]
    ++ (with pkgs.unstable; [
      # Download and transfer tools
      aria2 # Lightweight multi-protocol & multi-source download utility
      curl # Command line tool for transferring data with URL syntax
      curlie # The power of curl, the ease of use of httpie
      rclone # Rclone syncs files to and from cloud storage
      rsync # Fast, versatile, remote (and local) file-copying tool
      wget # The non-interactive network downloader
      wget2 # Successor to Wget

      # Network analysis and diagnostics
      bluetui # Bluetooth TUI
      ddgr # DuckDuckGo from the terminal
      doggo # Command-line DNS client
      gping # Ping, but with a graph
      grpcurl # gRPC client
      httpie # HTTP client
      is-fast # Check if a website is fast
      # lychee # Link checker
      oha # HTTP load testing tool
      speedtest-go # Command-line speed test
      urlscan # Scan URLs for malicious activity
      xh # Friendly and fast tool for sending HTTP requests

      # Remote access and tunneling
      lazyssh # SSH client
      miniserve # A CLI tool to serve files and folders over HTTP
      monolith # Save web pages as a single HTML file
      sshfs # Mount remote filesystems over SSH
      # trurl # URL parsing and manipulation
    ]);
}
