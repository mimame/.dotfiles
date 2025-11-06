# This module defines packages for Protocol Buffers.
{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    buf # A new way of working with Protocol Buffers
    protobuf # Protocol Buffers compiler and libraries
  ];
}
