# This module defines packages for Rust development and tooling.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    rustup # The Rust toolchain installer
  ];
}
