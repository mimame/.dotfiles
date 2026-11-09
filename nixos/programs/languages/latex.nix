# This module defines packages for LaTeX authoring support.
# NOT imported by default — uncomment ./latex.nix in default.nix to activate.
# Importing IS the switch: when off, no TeX distribution exists on the system
# (removed in 956ca6f8).
#
# WHY scheme-medium: what this config shipped before (00ae8400). It is the
# practical middle ground — full engines + latexmk/latexindent without the
# multi-GB scheme-full. tectonic ships alongside as the modern minimal engine:
# self-contained, fetches packages on demand (needs network on first build).
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    (texlive.combined.scheme-medium.withPackages (
      ps: with ps; [
        latexmk # Build orchestration (the standard .tex → pdf workflow)
        latexindent # Indentation-aware source beautifier
      ]
    ))
    texlab # Structural LSP for LaTeX (completions, hover, build on save)
    ltex-ls-plus # Grammar/style LSP for LaTeX and Markdown files
    tectonic # Minimal LaTeX engine — fetches packages on demand
  ];
}
