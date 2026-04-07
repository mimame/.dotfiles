# ----------------------------------------------------------------------------
# Miscellaneous Utilities
#
# Text processing, archiving/compression, calculators, and general-purpose CLI tools.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  environment.systemPackages =
    with pkgs;
    [
      # --- Core Utilities ---
      at # Schedule commands at specific time
      bc # Arbitrary precision calculator
      parallel # Execute commands in parallel
      pv # Pipe Viewer (monitor data progress)
      pwgen # Generate pronounceable passwords
      libqalculate # Advanced calculator library
      tailspin # Log file analyzer
      time # Measure program resource use
    ]
    ++ (with pkgs.unstable; [
      # --- Text Processing & Viewing ---
      bat # cat with syntax highlighting
      choose # Human-friendly cut/awk alternative
      dos2unix # Convert text file formats
      fend # Command-line calculator
      file # Determine file type
      fx # Command-line JSON viewer
      gawk # GNU Awk
      glow # Markdown renderer
      grex # Generate regex from test cases
      gron # Make JSON greppable
      hexyl # Command-line hex viewer
      jaq # jq clone in Rust
      jc # Convert command output to JSON
      jless # JSON viewer
      jnv # jq-like JSON tool
      lnav # Log file navigator
      moor # JSON viewer/manipulator
      ov # Terminal pager
      qsv # CSV toolkit
      sd # sed alternative
      translate-shell # Command-line translator
      visidata # Terminal spreadsheet multitool
      xan # XML viewer

      # --- Archiving & Compression ---
      _7zz # 7-Zip (modern version)
      brotli # Brotli compression
      bzip2 # Bzip2 compression
      bzip3 # Bzip3 compression (newer)
      gzip # GNU zip
      libarchive # Multi-format archive library
      pbzip2 # Parallel bzip2
      pigz # Parallel gzip
      pixz # Parallel xz
      unar # Universal unarchiver
      unrar # RAR extraction
      unzip # ZIP extraction
      zip # ZIP compression
      zstd # Zstandard compression

      # --- Miscellaneous ---
      halp # Command-line help tool
      newsboat # RSS/Atom feed reader
      ouch # Archive tool (auto-detects format)
      pastel # Color manipulation tool
      pay-respects # F to pay respects
      poop # Benchmark command output
      progress # Show progress for cp/mv/dd/etc
      pueue # Command-line task queue
      rlwrap # Readline wrapper
      ruplacer # Find and replace in files
      spacer # Add spaces to output
      tz # Timezone tool
      vivid # ls colorizer (generate LS_COLORS)
    ]);
}
