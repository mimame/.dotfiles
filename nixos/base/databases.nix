{ pkgs, ... }: {

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };
  # users.mysql.enable = true;

  environment.systemPackages = with pkgs;
    [

    ] ++ (with pkgs.unstable; [

      mariadb-connector-c
      mycli
      redis

    ]);
}
