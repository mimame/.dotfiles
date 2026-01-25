# This module defines packages for Node.js development and tooling.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    nodejs # Node.js runtime
    yarn # Fast, reliable, and secure dependency management
    vscode-js-debug # JavaScript debugger
    nodePackages.vscode-langservers-extracted # HTML, CSS, JSON, ESLint LSPs
    nodePackages.typescript-language-server # TypeScript language server
    biome # Fast formatter and linter (Rust-based)
    vtsls # Faster TypeScript language server
  ];
}
