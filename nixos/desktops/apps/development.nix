{ pkgs, ... }:
{
  environment.systemPackages = with pkgs.unstable; [
    # Development tools (GUI)
    dbeaver-bin # Universal database tool
    gitg # Git graphical user interface
    lapce # Lightning-fast and powerful code editor
  ];
}
