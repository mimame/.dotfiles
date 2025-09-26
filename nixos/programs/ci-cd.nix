{ ... }:
{
  # --- CI/CD ---
  # Jenkins: A continuous integration and continuous delivery server.
  services.jenkins = {
    enable = false;
    withCLI = true;
    extraGroups = [
      "podman"
      "docker"
    ];
  };
}
