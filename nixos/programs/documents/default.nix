# ----------------------------------------------------------------------------
# Document Tools
#
# PDF tools, office suites, diagramming, spell/grammar checking, and OCR.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs.unstable; [
    # --- PDF Tools ---
    pdfarranger # Rearrange PDF pages (GUI)
    pdfsam-basic # Split and merge PDFs
    pdftk # PDF toolkit (CLI)
    pdfchain # GUI frontend for pdftk
    poppler-utils # PDF utilities (pdftotext, pdfimages)
    qpdf # Structural PDF transformation
    zathura # Minimal PDF viewer
    xournalpp # PDF annotation tool

    # --- Office Suites ---
    # WHY ONLYOFFICE: Superior Microsoft Office format compatibility (.docx, .xlsx, .pptx)
    # compared to LibreOffice. Critical for professional document exchange.
    onlyoffice-desktopeditors # Office suite (text, spreadsheet, presentation)
    papers # Academic paper management
    pandoc # Universal document converter
    tdf # The Document Foundation tools

    # --- Diagramming ---
    graphviz # Graph visualization
    mermaid-cli # Diagram generation from text
    plantuml # UML diagramming

    # --- Spell & Grammar Checking ---
    hunspell # Spell checker
    hunspellDicts.en-us-large # English dictionary
    hunspellDicts.es-es # Spanish dictionary
    hunspellDicts.fr-moderne # French dictionary
    hyphen # Hyphenation engine
    languagetool # Grammar and style checker

    # --- Document Utilities ---
    ghostscript # PostScript and PDF interpreter
    tesseract5 # OCR engine
  ];
}
