# This module defines packages for JVM-based languages, including Java and Clojure.
{
  pkgs,
  ...
}:

{
  # Java Development Kit (JDK) configuration.
  programs.java = {
    enable = true;
    package = pkgs.unstable.jdk21;
  };

  environment.systemPackages = with pkgs.unstable; [
    # Clojure development tools
    clojure # Clojure CLI tools
    leiningen # Automation tool for Clojure projects
  ];
}
