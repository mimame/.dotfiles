# This module defines packages for various programming languages that do not yet have
# enough tools to warrant their own dedicated module.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    # Miscellaneous language-related tools
    llvm # Low Level Virtual Machine compiler infrastructure
  ];
}
