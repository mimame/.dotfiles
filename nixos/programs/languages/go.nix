# This module defines packages for Go development.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    go # Go programming language compiler and tools
    golangci-lint # A fast Go linters aggregator
    gopls # Go language server
    delve # Debugger for the Go programming language
    impl # Generate method stubs for implementing an interface
    gomodifytags # Go tool to modify struct field tags
    gofumpt # Enforce a stricter format than gofmt
    gotools # Additional Go tools, including goimports
  ];
}
