# ----------------------------------------------------------------------------
# DevOps & Infrastructure Tools
#
# Cloud platforms, Infrastructure as Code (IaC), container tools, and monitoring.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs.unstable; [
    # --- Cloud Platform CLIs ---
    fly # Fly.io deployment platform

    # --- Infrastructure as Code (IaC) ---
    packer # Multi-platform machine image builder
    opentofu # Open-source IaC engine (replaces tenv/terraform)
    terraform-ls # Language Server Protocol (LSP) for HCL/OpenTofu
    tflint # Linter for catching errors in HCL code

    # --- Automation & Config Management ---
    ansible # IT automation engine
    ansible-lint # Best practices checker for Ansible

    # --- Container/Docker Tools ---
    lazydocker # Terminal UI for Docker
    dockerfile-language-server # Language server for Dockerfiles
    hadolint # Dockerfile linter (best practices)
  ];

  # WHY disabled: Monitoring/observability stack not currently needed
  # services.prometheus.enable = false;
  # services.grafana.enable = false;
}
