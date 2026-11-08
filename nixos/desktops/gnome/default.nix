# ----------------------------------------------------------------------------
# GNOME Desktop Environment
#
# Full GNOME Shell session. This module adds GNOME Shell and GDM;
# gnome-services.nix provides the shared services layer (keyring, portals,
# GTK theming, core apps).
# ----------------------------------------------------------------------------
{ ... }:
{
  imports = [ ../gnome-services.nix ];

  # GDM (GNOME Display Manager): integrates with the GNOME services layer
  # (Keyring, settings daemon) and runs natively on Wayland. Enabled per
  # profile — the niri profile uses greetd instead (see niri/default.nix).
  services.displayManager.gdm.enable = true;

  services.desktopManager.gnome.enable = true;
}
