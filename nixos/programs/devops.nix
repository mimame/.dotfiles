{ pkgs, ... }:
{
  # Disabled services
  # services.prometheus.enable = true;
  # services.grafana.enable = true;

  environment.systemPackages =
    with pkgs;
    (with pkgs.unstable; [
      # Cloud and Infrastructure as Code tools
      # awscli # v1 for awslocal localstack compatibility
      fly # Fly.io CLI for Fly.io platform
      packer # A tool for creating identical machine images for multiple platforms.
      tenv # A tool for managing different versions of Terraform and OpenTofu.
      lazydocker # A terminal UI for Docker
      ansible # Automation engine
      # pulumi-bin # A tool for creating, deploying, and managing infrastructure as code.

      # Disabled packages
      # grafana
      # grafana-loki
      # localstack
      # nodePackages.serverless
      # prometheus
      # python3Packages.localstack
    ]);
}
