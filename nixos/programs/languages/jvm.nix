# This module defines packages for JVM-based languages, including Java and Clojure.
{
  pkgs,
  lib,
  ...
}:

{
  # Use jdk25 (latest LTS) unless nixpkgs default has already moved past it.
  # WHY: Prevents silently downgrading if the nixpkgs default JDK ever exceeds 25.
  programs.java = {
    enable = true;
    package = if lib.versionAtLeast pkgs.jdk.version "25" then pkgs.jdk else pkgs.jdk25;
  };

  environment.systemPackages = with pkgs.unstable; [
    # Clojure development tools
    clojure # Clojure CLI tools
    clojure-lsp # Language Server Protocol for Clojure
    leiningen # Automation tool for Clojure projects
  ];
}
