{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Clipboard manager
    clipman # Clipboard manager for Wayland
  ];
}
