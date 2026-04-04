# ----------------------------------------------------------------------------
# System Tools
#
# System monitoring, hardware utilities, disk tools, and configuration management.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  # Allow non-root users to mount FUSE filesystems
  programs.fuse.userAllowOther = true;

  environment.systemPackages =
    with pkgs;
    [
      # --- Disk & Filesystem ---
      dosfstools # FAT filesystem tools
      ntfs3g # NTFS filesystem driver
      parted # Disk partition manipulator

      # --- System Information ---
      lsb-release # Linux Standard Base info
      lsof # List open files
      stress # CPU/memory/disk/IO load generator
      systeroid # Powerful sysctl alternative
      xdg-user-dirs # Manage user directories (Desktop, Downloads)
      xdg-utils # Desktop environment integration
      shared-mime-info # Shared MIME database

      # --- Miscellaneous ---
      desktop-file-utils # .desktop file utilities
    ]
    ++ (with pkgs.unstable; [
      # --- System Monitoring ---
      btop # Resource monitor (CPU, memory, disk, network)
      ctop # Container metrics (top-like)
      dool # System activity reporter
      fastfetch # System info tool (neofetch-like)
      inxi # Full-featured CLI system info
      lshw # List hardware
      oxker # Modern top for containers
      procs # Modern ps replacement
      zenith # Interactive process viewer

      # --- Hardware Utilities ---
      nvme-cli # NVMe command-line interface
      pciutils # PCI utilities (lspci)
      smartmontools # S.M.A.R.T. disk monitoring
      usbutils # USB utilities (lsusb)

      # --- Disk & Filesystem ---
      testdisk # Data recovery tool
      udiskie # Automount removable media
      util-linux # System utilities collection
      # WHY hiPrio: Prefer Rust coreutils over GNU coreutils
      (lib.hiPrio uutils-coreutils-noprefix)

      # --- Configuration Management ---
      stow # Symlink farm manager (dotfiles)
      dotter # Dotfile manager

      # --- System Updates ---
      topgrade # Upgrade all package managers at once
    ]);
}
