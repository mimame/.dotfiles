{ pkgs, ... }:
{
  # MySQL/MariaDB service configuration.
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };
  # users.mysql.enable = true;

  environment.systemPackages =
    with pkgs;
    [
      # Database servers
      postgresql # PostgreSQL database server

      # SQL clients
      litecli # CLI for SQLite with auto-completion and syntax highlighting
      mycli # CLI for MySQL with auto-completion and syntax highlighting
      usql # Universal SQL client

      # Redis
      redis # In-memory data structure store

      # SQL linting and utilities
      sqlfluff # SQL linter and auto-formatter
      sqlite-interactive # Interactive SQLite shell
      sqlite-utils # CLI for manipulating SQLite databases

      # Database-specific tools
      turso-cli # CLI for Turso database

      # mariadb-connector-c # For Rails but generates too many collisions
    ]
    ++ (with pkgs.unstable; [

    ]);
}
