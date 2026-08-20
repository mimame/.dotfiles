{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs.unstable; [
    odin # The Odin programming language
    ols # Odin Language Server
  ];
}
