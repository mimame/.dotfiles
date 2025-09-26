{ pkgs, ... }:
{
  environment.systemPackages = with pkgs.unstable; [
    pdftk
    tdf
    poppler_utils
    papers
    pdfarranger
    pdfsam-basic
    xournalpp
    zathura
  ];
}
