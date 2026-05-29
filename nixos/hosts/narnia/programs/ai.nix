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
# ----------------------------------------------------------------------------
{ llama-cpp-pkg, modelDir, ... }:
{
  services.llama-swap.settings.models = {
    # "Cohete" (Speed): Mistral 7B v0.3
    # WHY: Tiny and efficient. Perfect for simple chat or fast boilerplate.
    # Offloads all layers (32) to 6GB VRAM for max performance (>30 t/s).
    "mistral-7b" = {
      cmd = "${llama-cpp-pkg}/bin/llama-server --port $\{PORT} -m ${modelDir}/Mistral-7B-Instruct-v0.3-Q4_K_M.gguf -ngl 32 --ctx-size 4096 --flash-attn";
      aliases = [ "mistral" ];
    };
    # Balanced: Gemma 2 9B
    # WHY: The "sweet spot". Google's high-quality reasoning in a size
    # that fits mostly in VRAM while providing superior logic to 7B.
    "gemma-9b" = {
      cmd = "${llama-cpp-pkg}/bin/llama-server --port $\{PORT} -m ${modelDir}/gemma-2-9b-it-Q4_K_M.gguf -ngl 26 --ctx-size 4096 --flash-attn";
      aliases = [ "gemma" ];
    };
    # "Cerebro" (Logic/Code): Mistral Small 24B
    # WHY: Elite intelligence for complex software architecture and logic.
    # Slower on 1060, but prevents "dumb" code hallucinations.
    "mistral-24b" = {
      cmd = "${llama-cpp-pkg}/bin/llama-server --port $\{PORT} -m ${modelDir}/Mistral-Small-24B-Instruct-2501-Q4_K_M.gguf -ngl 12 --ctx-size 8192 --flash-attn";
      aliases = [ "mistral-small" ];
    };
    # Reasoning Nativo: GPT-OSS 20B
    # WHY: Specialized Open Source focused model. Uses optimized mxfp4
    # to squeeze higher intelligence into lower memory footprints.
    "gpt-oss-20b" = {
      cmd = "${llama-cpp-pkg}/bin/llama-server --port $\{PORT} -m ${modelDir}/gpt-oss-20b-mxfp4.gguf -ngl 12 --ctx-size 4096 --flash-attn";
      aliases = [ "gpt-oss" ];
    };
  };
}
