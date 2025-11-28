{ pkgs, ... }:
{
  environment.systemPackages = with pkgs.unstable; [
    # Communication
    telegram-desktop # Telegram messaging app
    thunderbird # Email client
    zoom-us # Video conferencing
  ];
}
