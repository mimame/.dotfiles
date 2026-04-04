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

    # Ollama: Local LLM inference with CUDA acceleration
    # WHY CUDA: GTX 1060 GPU accelerates model inference significantly
    ollama = {
      enable = true;
      package = pkgs.unstable.ollama-cuda;
      acceleration = "cuda";
      loadModels = [ "gemma4" ]; # Pre-load gemma4 on service start

      environmentVariables = {
        # WHY OLLAMA_ORIGINS: Allow localhost connections from web UIs
        OLLAMA_ORIGINS = "http://localhost:*,http://127.0.0.1:*";
        # WHY OLLAMA_LLM_LIBRARY: Force CUDA backend (avoid CPU fallback)
        OLLAMA_LLM_LIBRARY = "cuda";
        # WHY OLLAMA_HOST: Explicit localhost binding for security
        OLLAMA_HOST = "127.0.0.1:11434";
      };
    };

    # Ollama Web UI
    nextjs-ollama-llm-ui.enable = true;

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
