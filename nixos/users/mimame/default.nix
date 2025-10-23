# ----------------------------------------------------------------------------
# User-Specific Configuration: mimame
#
# This file defines the configuration for the user "mimame".
# ----------------------------------------------------------------------------
{ pkgs, username, ... }:
{
  users = {
    # Set the default shell for all users.
    defaultUserShell = pkgs.unstable.fish;
    users.${username} = {
      isNormalUser = true;
      description = "${username} Account";
      # Add user to essential groups for hardware access and system management.
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
      # User-specific packages can be installed here.
      packages = with pkgs; [
        #  firefox
        #  thunderbird
      ];
    };
  };
}
