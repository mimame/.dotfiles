# ----------------------------------------------------------------------------
# AI Tools (always installed)
#
# Lightweight AI CLIs kept separate from the host-gated ./ai.nix service
# stack: these are fast to build, host-agnostic, and work against any
# OpenAI-compatible endpoint (local llama-swap when present, remote
# otherwise). Neither "clients" nor "agents" covers the whole set: it mixes
# agents (opencode), API clients/downloaders (antigravity-cli, hf) and
# hardware tooling (llmfit).
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  # OPENCODE env vars intentionally omitted — opencode.jsonc defines the
  # llama-swap provider and model list. Keeping env vars and config in sync
  # is error-prone; config is the single source of truth.
  environment.systemPackages = with pkgs.unstable; [
    # --- AI Coding Assistants ---
    # claude-code # Agentic coding tool for the terminal
    # github-copilot-cli # GitHub Copilot CLI
    opencode # AI coding agent for terminal. Configured via OPENCODE_* env vars.

    # --- AI Protocols & Clients ---
    antigravity-cli # Antigravity protocol client
    python3Packages.huggingface-hub # CLI for downloading models from HuggingFace (hf)

    # --- Hardware Capability Tools ---
    llmfit # Find what runs on your hardware (VRAM estimation)
  ];
}
