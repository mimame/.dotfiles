{ pkgs, ... }:
{
  environment.systemPackages = with pkgs.unstable; [
    # Lightweight browsers (GPU-accelerated browsers moved to nvidia-wrappers.nix)
    nyxt # Keyboard-driven web browser
  ];
}
