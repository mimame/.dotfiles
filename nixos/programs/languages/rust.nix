# This module defines packages for Rust development and tooling.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    rustup # The Rust toolchain installer
    lldb # A next-generation, high-performance debugger
    vscode-extensions.vadimcn.vscode-lldb # VS Code CodeLLDB extension
  ];
}
