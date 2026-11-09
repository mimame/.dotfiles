{ ... }:
{
  imports = [
    ./ci-cd.nix
    ./databases.nix
    ./development/default.nix
    ./development/prek-hooks.nix
    ./devops.nix
    ./documents/default.nix
    ./editors/default.nix
    ./file-management/default.nix
    ./git/default.nix
    ./media/default.nix
    ./misc/default.nix
    ./networking/default.nix
    ./services/default.nix
    ./security/default.nix
    ./shells/default.nix
    ./system-tools/default.nix
    ./terminals/default.nix
    ./virtualisation-containers.nix
    # VMs (libvirt, VirtualBox, virt-manager): opt-in by uncommenting.
    # WHY commented (2026-11-09): libvirtd inactive, VBox unused (last VM log
    # 2024-08), and vboxnet0 costs ~800ms of boot. The module declares its own
    # libvirtd/vboxusers group memberships, so this import is the single toggle.
    # ./virtualisation-vm.nix
    ./borgmatic-backup.nix
    ./ai-tools.nix
    # ./ai.nix intentionally NOT imported here: the llama-swap/open-webui stack
    # is host-specific (heavyweight, rebuilds on every channel update). Hosts
    # opt in via hosts/<hostname>/programs/ai.nix, which imports the shared
    # module itself — the import is the single toggle, infra and models can
    # never diverge.
  ];
}
