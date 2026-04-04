# ----------------------------------------------------------------------------
# Terminal Emulators
#
# GPU-accelerated terminal emulators and terminal multiplexers.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs.unstable; [
    ghostty # Fast, modern, hackable terminal
    kitty # GPU-accelerated terminal
    zellij # Terminal workspace multiplexer
  ];
}
