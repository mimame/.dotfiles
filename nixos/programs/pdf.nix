{ pkgs, ... }:
{
  environment.systemPackages =
    with pkgs;
    (with pkgs.unstable; [
      papers
      pdfarranger
      pdfsam-basic
      pdftk
      poppler_utils
      tdf
      xournalpp
      zathura
    ]);
}
