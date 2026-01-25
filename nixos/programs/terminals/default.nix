{ pkgs, ... }:

{
  environment.systemPackages = with pkgs.unstable; [
    ghostty # A fast, modern, and hackable terminal emulator
    kitty # A GPU-accelerated terminal emulator
    zellij # A terminal workspace multiplexer and session manager
  ];
}
