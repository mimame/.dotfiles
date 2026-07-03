# ----------------------------------------------------------------------------
# User Configuration: mimame
#
# Defines the main user account and group memberships.
# ----------------------------------------------------------------------------
{ pkgs, username, ... }:
{
  users = {
    # Default shell for all users
    # WHY stable: see nixos/system/base.nix — fish 4.8.0 completion generator
    # breaks with the 26.05 NixOS module.
    defaultUserShell = pkgs.fish;

    users.${username} = {
      isNormalUser = true;
      description = "${username} Account";

      # Group memberships for hardware access and system management
      extraGroups = [
        "audio" # Audio devices
        "incus-admin" # Incus/LXD container management
        "input" # Input devices (controllers, etc.)
        "libvirtd" # Libvirt virtualization
        "lxd" # LXD container management
        "networkmanager" # Network management
        "podman" # Podman container management
        "vboxusers" # VirtualBox access
        "video" # Video devices and hardware acceleration
        "wheel" # Sudo access
      ];
    };
  };
}
