# ----------------------------------------------------------------------------
# Host-Specific AI Models: narnia
#
# Hardware: NVIDIA GTX 1060 (6GB VRAM)
# This module defines the hardware-tuned model list for this host.
# Infrastructure (llama-swap service, package overrides) is defined in
# the shared programs/ai.nix file.
#
# --- MODEL USAGE GUIDE ---
# ┌─────────────────────────┬───────────────────┬───────────────────────────────────────────────────┐
# │ Task                    │ Recommended Model │ Rationale                                         │
# ├─────────────────────────┼───────────────────┼───────────────────────────────────────────────────┤
# │ Coding (Instant/Fluid)  │ qwen-coder-3b     │ Elite 3B code model. 100% GPU (~62 tok/s), Q8_0.  │
# │ Fast Chat / Boilerplate │ llama-3b          │ Ultra-fast responses for daily tasks, Q8_0.       │
# │ Obsidian / Creative     │ gemma-9b          │ High-quality prose/synthesis. Hybrid GPU/CPU.    │
# │ Complex Logic (Slow)    │ mistral-24b       │ Maximum reasoning ceiling. Mostly CPU execution.  │
# └─────────────────────────┴───────────────────┴───────────────────────────────────────────────────┘
#
# --- DOWNLOAD REFERENCE ---
# 1. Qwen 2.5 Coder 3B Instruct:
#    hf download bartowski/Qwen2.5-Coder-3B-Instruct-GGUF --include "Qwen2.5-Coder-3B-Instruct-Q8_0.gguf" --local-dir .
# 2. Llama 3.2 3B Instruct:
#    hf download bartowski/Llama-3.2-3B-Instruct-GGUF --include "Llama-3.2-3B-Instruct-Q8_0.gguf" --local-dir .
# 3. Gemma 2 9B:
#    hf download bartowski/gemma-2-9b-it-GGUF --include "gemma-2-9b-it-Q4_K_M.gguf" --local-dir .
# 4. Mistral Small 24B (2501):
#    hf download bartowski/Mistral-Small-24B-Instruct-2501-GGUF --include "Mistral-Small-24B-Instruct-2501-Q4_K_M.gguf" --local-dir .
# ----------------------------------------------------------------------------
{
  lib,
  llama-cpp-pkg,
  modelDir,
  ...
}:
let
  # Override the shared llama-cpp package with host-specific CUDA architecture.
  # WHY: The GTX 1060 (Pascal) requires compute capability 6.1 ("61").
  # Without this, llama-server crashes with "no kernel image available".
  # We use overrideAttrs to directly inject the CMake flag for Pascal.
  narnia-llama-cpp = llama-cpp-pkg.overrideAttrs (old: {
    cmakeFlags = (old.cmakeFlags or [ ]) ++ [ "-DCMAKE_CUDA_ARCHITECTURES=61" ];
  });
in
{
  services.llama-swap.settings.models = {
    # "Cohete Código" (Speed/Context): Qwen 2.5 Coder 3B
    # WHY: Blazing fast coding assistant that fits entirely in 6GB VRAM at high quantization.
    # --- PARAMETERS ---
    # -ngl 99: Force all layers into GPU for maximum performance.
    # -c 16384: Generous 16k context window for managing mid-sized code files.
    # -np 1: Single user slot to avoid memory overhead.
    "qwen-coder-3b" = {
      cmd = "${narnia-llama-cpp}/bin/llama-server --port ${"$"}{PORT} -m ${modelDir}/Qwen2.5-Coder-3B-Instruct-Q8_0.gguf -ngl 99 -c 16384 -np 1";
      aliases = [
        "coder"
        "code-fast"
      ];
    };

    # "Cohete Chat" (Speed/General): Llama 3.2 3B
    # WHY: Lightweight general assistant from llmfit specs. Perfect for instant terminal interactions.
    # --- PARAMETERS ---
    # -ngl 99: 100% GPU offloading.
    # -c 8192: Standard 8k context window.
    # -np 1: Single user slot.
    "llama-3b" = {
      cmd = "${narnia-llama-cpp}/bin/llama-server --port ${"$"}{PORT} -m ${modelDir}/Llama-3.2-3B-Instruct-Q8_0.gguf -ngl 99 -c 8192 -np 1";
      aliases = [
        "llama"
        "chat-fast"
      ];
    };

    # Balanced: Gemma 2 9B
    # WHY: High-quality reasoning in a size that fits mostly in VRAM.
    # --- PARAMETERS ---
    # -ngl 12: Conservative setting to ensure stability with 8k context window.
    # -c 8192: 8k context window.
    # -np 1: Number of parallel slots.
    "gemma-9b" = {
      cmd = "${narnia-llama-cpp}/bin/llama-server --port ${"$"}{PORT} -m ${modelDir}/gemma-2-9b-it-Q4_K_M.gguf -ngl 12 -c 8192 -np 1";
      aliases = [ "gemma" ];
    };

    # "Cerebro" (Logic/Code): Mistral Small 24B
    # WHY: Elite intelligence for complex software architecture and logic.
    # --- PARAMETERS ---
    # -ngl 4: Only 4 layers in GPU to keep VRAM usage under 6GB for this 24B giant.
    # -c 8192: Reduced context (from native 128k) to prevent OOM.
    # -np 1: Single user slot.
    "mistral-24b" = {
      cmd = "${narnia-llama-cpp}/bin/llama-server --port ${"$"}{PORT} -m ${modelDir}/Mistral-Small-24B-Instruct-2501-Q4_K_M.gguf -ngl 4 -c 8192 -np 1";
      aliases = [ "mistral-small" ];
    };
  };
}
