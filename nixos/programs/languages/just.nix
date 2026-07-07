{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    just-lsp # Language server for just
  ];
}
