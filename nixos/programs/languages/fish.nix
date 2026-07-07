{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    fish-lsp # LSP implementation for the fish shell language
  ];
}
