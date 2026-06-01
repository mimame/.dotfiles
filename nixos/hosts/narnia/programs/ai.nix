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
# │ Obsidian / Creative     │ gemma-9b          │ Best reasoning and prose for knowledge synthesis. │
# │ Coding (opencode)       │ mistral-24b       │ Highest logic ceiling for complex architecture.   │
# │ Fast Chat / Boilerplate │ mistral-7b        │ Instant responses for trivial tasks.              │
# │ Complex Reasoning       │ gpt-oss-20b       │ Deep reasoning MOE alternative.                   │
# └─────────────────────────┴───────────────────┴───────────────────────────────────────────────────┘
#
# --- DOWNLOAD REFERENCE ---
# 1. Mistral 7B v0.3:
#    hf download bartowski/Mistral-7B-Instruct-v0.3-GGUF --include "Mistral-7B-Instruct-v0.3-Q4_K_M.gguf" --local-dir .
# 2. Gemma 2 9B:
#    hf download bartowski/gemma-2-9b-it-GGUF --include "gemma-2-9b-it-Q4_K_M.gguf" --local-dir .
# 3. Mistral Small 24B (2501):
#    hf download bartowski/Mistral-Small-24B-Instruct-2501-GGUF --include "Mistral-Small-24B-Instruct-2501-Q4_K_M.gguf" --local-dir .
# 4. GPT-OSS 20B:
#    hf download ggml-org/gpt-oss-20b-GGUF --include "gpt-oss-20b-mxfp4.gguf" --local-dir .
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
    # "Cohete" (Speed): Mistral 7B v0.3
    # WHY: Tiny and efficient. Perfect for simple chat or fast boilerplate.
    # --- PARAMETERS ---
    # -ngl 12: Reduced to 12 for quiet operation and safe VRAM headroom (~4GB total).
    # -c 8192: Context size. 8k is enough for most code files and long chats.
    # -np 1: Only 1 slot. Saves VRAM by preventing parallel request overhead.
    "mistral-7b" = {
      cmd = "${narnia-llama-cpp}/bin/llama-server --port ${"$"}{PORT} -m ${modelDir}/Mistral-7B-Instruct-v0.3-Q4_K_M.gguf -ngl 12 -c 8192 -np 1";
      aliases = [ "mistral" ];
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

    # Reasoning Nativo: GPT-OSS 20B
    # WHY: Specialized MOE model. Uses optimized mxfp4 for efficiency.
    # --- PARAMETERS ---
    # -ngl 8: Conservative offloading for a 20B model to ensure stability.
    # -c 8192: Standard high-productivity context size.
    # -np 1: Single user slot.
    "gpt-oss-20b" = {
      cmd = "${narnia-llama-cpp}/bin/llama-server --port ${"$"}{PORT} -m ${modelDir}/gpt-oss-20b-mxfp4.gguf -ngl 8 -c 8192 -np 1";
      aliases = [ "gpt-oss" ];
    };
  };
}
