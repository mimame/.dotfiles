{ pkgs, ... }:

{
  # Allow non-root users to use FUSE filesystems.
  programs.fuse.userAllowOther = true;

  environment.systemPackages =
    with pkgs;
    [
      # Disk and filesystem utilities
      dosfstools # Tools for creating and checking DOS FAT filesystems
      ntfs3g # NTFS filesystem driver
      parted # Disk partition manipulator

      # System information and diagnostics
      lsb-release # Print Linux Standard Base information
      lsof # List open files
      stress # Tool to generate CPU/memory/disk/IO load
      systeroid # A more powerful alternative to sysctl
      xdg-user-dirs # Manage user directories like Desktop, Downloads, etc.
      xdg-utils # Command line tools for integrating applications with the desktop environment
      shared-mime-info # Shared MIME database

      # Miscellaneous system tools
      desktop-file-utils # Command line utilities for working with .desktop files
    ]
    ++ (with pkgs.unstable; [
      # System monitoring and performance
      btop # A monitor of resources
      ctop # Top-like interface for container metrics
      dool # System activity reporter
      fastfetch # Neofetch-like system information tool
      inxi # A full featured CLI system information tool
      lshw # List hardware
      oxker # A modern top-like tool for containers
      procs # A modern replacement for ps
      zenith # A modern, interactive process viewer

      # Hardware utilities
      nvme-cli # NVM Express command line interface
      pciutils # PCI utilities
      smartmontools # S.M.A.R.T. hard disk monitoring utilities

      # Disk and filesystem utilities
      testdisk # Data recovery tool
      udiskie # Automount removable media
      util-linux # Collection of various system utilities
      (lib.hiPrio uutils-coreutils-noprefix) # Coreutils written in Rust

      # Configuration management
      stow # Manage dotfiles
      dotter # A dotfile manager

      # System updates and maintenance
      topgrade # Upgrade all the things
    ]);
}
