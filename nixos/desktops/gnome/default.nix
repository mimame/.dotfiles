# ----------------------------------------------------------------------------
# GNOME Desktop Environment
#
# Full GNOME Shell session. gnome-services.nix provides GDM, keyring, portals,
# GTK theming, and core apps — this module only adds GNOME Shell on top.
# ----------------------------------------------------------------------------
{ ... }:
{
  imports = [ ../gnome-services.nix ];
  services.xserver.desktopManager.gnome.enable = true;
}
