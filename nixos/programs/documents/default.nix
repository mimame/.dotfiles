{ pkgs, ... }:
{
  environment.systemPackages =
    with pkgs;
    (with pkgs.unstable; [
      # PDF tools
      pdfarranger # Rearrange PDF pages
      pdfsam-basic # Split and merge PDF files
      pdftk # PDF toolkit
      poppler-utils # PDF utilities (e.g., pdftotext, pdfimages)
      zathura # PDF viewer
      xournalpp # PDF annotation

      # Office suites and document processing
      libreoffice # Full office suite
      papers # Academic paper management
      pandoc # Universal document converter
      tdf # The Document Foundation tools

      # Diagramming and visualization
      graphviz # Graph visualization software
      mermaid-cli # Diagramming tool
      plantuml # UML diagramming tool

      # Spell and grammar checking
      hunspell # Spell checker
      hunspellDicts.en-us-large # English dictionary
      hunspellDicts.es-es # Spanish dictionary
      hunspellDicts.fr-moderne # French dictionary
      hyphen # Hyphenation engine
      languagetool # Grammar and style checker

      # Other document utilities
      ghostscript # PostScript and PDF interpreter
      tesseract5 # OCR engine
    ]);
}
