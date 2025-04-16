{ pkgs, ... }:
let
in
{
  # https://github.com/NixOS/nixpkgs/issues/373273
  # https://github.com/nix-community/nixGL/pull/190
  programs.niri = {
    enable = true;
    # package = pkgs.unstable.niri;
  };

  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };

  services.displayManager = {
    defaultSession = "niri";
    autoLogin = {
      enable = true;
      user = "mimame";
    };
  };

  # Whether to run XDG autostart files for sessions without a desktop manager (with only a window manager), these sessions usually don’t handle XDG autostart files by default.
  services.xserver.desktopManager.runXdgAutostartIfNone = true;

  environment.systemPackages =
    with pkgs;
    [

      xwayland-satellite
    ]
    ++ (with pkgs.unstable; [

      swaynotificationcenter
      swayosd
      swayr
      walker
      waybar
      waybar

    ]);
}
