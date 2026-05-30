# ----------------------------------------------------------------------------
# AI & Large Language Model Tools (Shared Infrastructure)
#
# Common AI protocols, coding assistants, and hardware analysis tools.
#
# --- MODEL SETUP WORKFLOW ---
# 1. DISCOVER: Run 'llmfit' (included below) to find models suited for your
#    hardware. It estimates VRAM/RAM usage for different quantization levels.
# 2. DOWNLOAD: Get GGUF files from HuggingFace (Bartowski or ggml-org repos):
#    - CLI: 'huggingface-cli download Bartowski/gemma-2-9b-it-GGUF gemma-2-9b-it-Q4_K_M.gguf --local-dir .'
#    - Web: https://huggingface.co/models?search=gguf
#    - Core Recommendations:
#      - Mistral 7B:  Mistral-7B-Instruct-v0.3-Q4_K_M.gguf
#      - Gemma 9B:    gemma-2-9b-it-Q4_K_M.gguf
#      - Mistral 24B: Mistral-Small-24B-Instruct-2501-Q4_K_M.gguf
#      - GPT-OSS 20B: gpt-oss-20b-mxfp4.gguf
# 3. DEPLOY:
#    - Create dir: sudo mkdir -p /var/lib/llama-cpp/models
#    - Move files: sudo mv *.gguf /var/lib/llama-cpp/models/
#    - Permissions: sudo chown -R llama-swap:llama-swap /var/lib/llama-cpp/models/
#
# --- TROUBLESHOOTING ---
# - Logs: journalctl -u llama-swap -f
# - Backend Processes: llama-swap spawns llama-server on-demand.
# - Web UI: http://localhost:8080 (Default login: your email)
#
# NOTE: The host-specific model list must be defined in:
# hosts/<hostname>/programs/ai.nix
# ----------------------------------------------------------------------------
{
  pkgs,
  lib,
  config,
  username,
  ...
}:
let
  # Determine CUDA support based on host hardware configuration
  # WHY: Prevents build failures or unnecessary CUDA dependencies on machines
  # without NVIDIA GPUs (e.g., macOS or Intel-only laptops).
  cudaSupport = config.hardware.nvidia.modesetting.enable or false;

  # Override llama-cpp package based on hardware capabilities
  # WHY unstable: llama.cpp moves extremely fast. Bleeding-edge versions are
  # required for new GGUF features (like mxfp4) and performance optimizations.
  llama-cpp-pkg = pkgs.unstable.llama-cpp.override { inherit cudaSupport; };

  # Path for GGUF model files
  # WHY /var/lib: System services (llama-swap) run as restricted users and
  # cannot read from /home by default due to standard NixOS security hardening.
  modelDir = "/var/lib/llama-cpp/models";
in
{
  # Inject these variables into the module system so host-specific AI configs
  # can use them for their model 'cmd' strings without re-defining them.
  _module.args = {
    inherit llama-cpp-pkg modelDir;
  };

  # Create the model directory with correct permissions for the service
  systemd.tmpfiles.rules = [
    "d ${modelDir} 0755 llama-swap llama-swap -"
    "d /home/${username}/ai 0755 ${username} users -"
    "d /home/${username}/ai/open-webui 0700 ${username} users -"
  ];

  services = {
    # Llama-swap: Transparent OpenAI-compatible proxy for llama.cpp
    # WHY: Enables automatic model swapping and VRAM management. It spawns the
    # backend only when requested and kills it after 5m of inactivity (default),
    # ensuring the 6GB VRAM is available for the desktop environment.
    llama-swap = {
      enable = true;
      port = 11434; # Matches Ollama's port for drop-in compatibility
      package = pkgs.unstable.llama-swap;
    };

    # Open WebUI: Modern ChatGPT-like frontend
    # WHY: Feature-rich assistant UI with RAG support and multi-model switching.
    # It communicates with the host-specific llama-swap proxy.
    open-webui = {
      enable = true;
      port = 8080;
      # Store database and history in user's home for easy backups
      # WHY: Using a dedicated subdirectory to avoid cluttering the 'ai' folder.
      stateDir = "/home/${username}/ai/open-webui";
      environment = {
        # Connect to llama-swap proxy (assumed running on 11434)
        # WHY: llama-swap mimics the Ollama API, allowing Open WebUI to use
        # its native model pulling/listing features while using llama.cpp.
        OLLAMA_BASE_URL = "http://127.0.0.1:11434";
        OPENAI_API_BASE_URL = "http://127.0.0.1:11434/v1";
        OPENAI_API_KEY = "sk-unused";
        ENABLE_OLLAMA = "True";
      };
    };
  };

  # Fix permissions for Open WebUI when using a home-resident stateDir
  # WHY: The NixOS module defaults to DynamicUser=true and User=open-webui,
  # which cannot access /home/mimame due to standard security permissions (700).
  # We also disable sandboxing that prevents access to /home.
  systemd.services.open-webui.serviceConfig = {
    User = lib.mkForce username;
    Group = lib.mkForce "users";
    DynamicUser = lib.mkForce false;
    ProtectHome = lib.mkForce false;
    ProtectSystem = lib.mkForce "full";
    ReadWritePaths = [ "/home/${username}/ai/open-webui" ];
  };

  # Custom environment for AI tools
  environment.variables = {
    # Configure opencode to use local llama-swap proxy for inference
    # This keeps your programming tasks 100% local.
    # TIP: Override via shell if speed is needed:
    #   OPENCODE_MODEL=mistral-7b opencode  (Fast)
    #   OPENCODE_MODEL=gemma-9b opencode    (Balanced)
    OPENCODE_API_BASE_URL = "http://127.0.0.1:11434/v1";
    OPENCODE_MODEL = "mistral-24b"; # Default to the high-intelligence logic model
  };

  environment.systemPackages = with pkgs.unstable; [
    # --- AI Coding Assistants ---
    claude-code # Agentic coding tool for the terminal
    github-copilot-cli # GitHub Copilot CLI
    opencode # AI coding agent for terminal. Configured via OPENCODE_* env vars.

    # --- AI Protocols & Clients ---
    gemini-cli # Gemini protocol client
    python3Packages.huggingface-hub # CLI for downloading models from HuggingFace (huggingface-cli)
    llama-cpp-pkg # Local inference tools (llama-cli, llama-server)

    # --- Hardware Capability Tools ---
    llmfit # Find what runs on your hardware (VRAM estimation)
  ];
}
