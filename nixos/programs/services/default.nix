# ----------------------------------------------------------------------------
# System Services
#
# Background services: file indexing (locate), LLMs (Ollama), file sync (Syncthing), GPG.
# ----------------------------------------------------------------------------
{ pkgs, username, ... }:
{
  services = {
    # plocate: Fast file indexing and search
    # WHY plocate: Faster than mlocate, lower I/O overhead
    locate = {
      enable = true;
      package = pkgs.unstable.plocate;
    };

    # Syncthing: Continuous file synchronization
    syncthing = {
      enable = true;
      openDefaultPorts = true; # 22000 (sync), 21027 (discovery)
      user = "${username}";
      dataDir = "/home/${username}";
    };
  };

  # GnuPG agent for encryption/signing
  # WHY enableSSHSupport=false: Prevents empty passphrase SSH keys (security)
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
  };

  # Espanso: Text expander (DISABLED - waiting for Wayland fix)
  # FIXME: Enable after https://github.com/NixOS/nixpkgs/pull/316519 is merged
  # services.espanso = {
  #   enable = true;
  #   package = pkgs.unstable.espanso-wayland;
  # };
}
