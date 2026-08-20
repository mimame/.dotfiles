{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    just # Command runner (Make alternative)
    just-lsp # Language server for just
  ];
}
