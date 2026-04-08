# ----------------------------------------------------------------------------
# AI & Large Language Model Tools
#
# Local LLM inference, AI coding assistants, and hardware capability tools.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  services = {
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
  };

  environment.systemPackages = with pkgs.unstable; [
    # --- AI Coding Assistants ---
    claude-code # Agentic coding tool for the terminal
    opencode # AI coding agent for terminal

    # --- AI Protocols & Clients ---
    gemini-cli # Gemini protocol client

    # --- Hardware Capability Tools ---
    llmfit # Find what runs on your hardware (VRAM estimation)
  ];
}
