# ----------------------------------------------------------------------------
# CI/CD Tools
#
# Continuous Integration and Continuous Delivery services and tools.
# ----------------------------------------------------------------------------
_: {
  # Jenkins: CI/CD automation server
  # WHY disabled: Resource-heavy, prefer GitHub Actions for most workflows
  services.jenkins = {
    enable = false;
    withCLI = true;
    extraGroups = [
      "podman"
      "docker"
    ];
  };
}
