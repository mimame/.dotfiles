# ----------------------------------------------------------------------------
# Database Tools & Servers
#
# SQL/NoSQL databases, CLI clients, and database utilities.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  # MySQL/MariaDB service
  # WHY MariaDB: Drop-in MySQL replacement with better performance and licensing
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  environment.systemPackages = with pkgs; [
    # --- Database Servers ---
    postgresql # PostgreSQL RDBMS
    redis # In-memory data structure store

    # --- SQL Clients (with auto-completion) ---
    litecli # SQLite client with syntax highlighting
    mycli # MySQL/MariaDB client with syntax highlighting
    usql # Universal SQL client (supports multiple DBs)

    # --- SQL Utilities ---
    sqlfluff # SQL linter and auto-formatter
    sqlite-interactive # Interactive SQLite shell
    sqlite-utils # CLI for manipulating SQLite databases

    # --- Cloud Database Tools ---
    turso-cli # CLI for Turso (edge database)
  ];
}
