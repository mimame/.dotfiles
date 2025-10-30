{ pkgs, ... }:
{
  environment.systemPackages =
    with pkgs;
    (with pkgs.unstable; [
      papers
      pdfarranger
      pdfsam-basic
      pdftk
      poppler-utils
      tdf
      xournalpp
      zathura
    ]);
}
