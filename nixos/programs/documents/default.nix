{ pkgs, ... }:
{
  environment.systemPackages =
    with pkgs;
    (with pkgs.unstable; [
      # PDF tools
      pdfarranger # Rearrange PDF pages
      pdfsam-basic # Split and merge PDF files
      pdftk # PDF toolkit
      pdfchain # GUI for pdftk
      poppler-utils # PDF utilities (e.g., pdftotext, pdfimages)
      qpdf # Structural PDF transformation
      zathura # PDF viewer
      xournalpp # PDF annotation

      # Office suites and document processing
      # NOTE: ONLYOFFICE is used instead of LibreOffice due to its superior
      # compatibility with Microsoft XML formats (.docx, .xlsx, .pptx).
      # This addresses the primary issue with document fidelity on Linux.
      onlyoffice-desktopeditors # Office suite that combines text, spreadsheet and presentation editors
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
