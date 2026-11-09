# ----------------------------------------------------------------------------
# Virtualization: VMs (opt-in, NOT imported by default)
#
# Hypervisors (Libvirt/QEMU, VirtualBox) and VM management tooling.
# Opt in by uncommenting ./virtualisation-vm.nix in ./default.nix.
# Split from virtualisation.nix (2026-11-09); containers live in
# ./virtualisation-containers.nix.
#
# WHY COMMENTED BY DEFAULT: libvirtd was inactive and the last VM log dated
# 2024-08; vboxnet0.service adds ~800ms to the greetd critical chain at boot.
# Group memberships are declared HERE, so the single import is the toggle —
# leaving the module off cannot leave stale libvirtd/vboxusers memberships
# behind (usermod fails at activation when a listed group does not exist).
# ----------------------------------------------------------------------------
{ pkgs, username, ... }:
{
  virtualisation = {
    # VirtualBox: Desktop VM hypervisor
    # WHY no extension pack: Avoids compiling from source (slow)
    virtualbox.host = {
      enable = true;
      enableExtensionPack = false;
    };

    # Libvirt/QEMU: High-performance VMs with KVM
    # See: https://nixos.wiki/wiki/Libvirt
    libvirtd = {
      enable = true;
      # NSS integration: Resolve VM hostnames on host
      nss = {
        enable = true;
        enableGuest = true;
      };
      qemu = {
        runAsRoot = true;
        swtpm.enable = true; # TPM emulation for Windows 11
        vhostUserPackages = [ pkgs.virtiofsd ]; # Shared filesystem driver
      };
    };

    # SPICE: USB redirection for VMs (webcam, flash drives)
    spiceUSBRedirection.enable = true;
  };

  # Hypervisor group access (see header note on co-location).
  users.users.${username}.extraGroups = [
    "libvirtd" # Libvirt virtualization
    "vboxusers" # VirtualBox access
  ];

  # VM management GUI
  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    # --- VM Tools ---
    quickemu # Quick QEMU VM launcher
    virt-viewer # VNC/SPICE viewer for VMs
    guestfs-tools # Disk image manipulation (mount, resize)

    # --- Cloud/VM Utilities ---
    cloud-init # Cloud instance bootstrapping
    cloud-utils # Cloud image utilities
  ];
}
