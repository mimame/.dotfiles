{ pkgs, ... }:
{

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };
  # users.mysql.enable = true;

  environment.systemPackages =
    with pkgs;
    [

      litecli
      # mariadb-connector-c # For Rails but generates too much collisions
      mycli
      redis
      usql

    ]
    ++ (with pkgs.unstable; [

    ]);
}
