{ pkgs, ... }:

{
  environment.systemPackages =
    with pkgs;
    [
      # Core utilities
      at # Execute commands at a specified time
      bc # Arbitrary precision calculator language
      parallel # Build and execute shell commands in parallel
      pv # Pipe Viewer - monitor the progress of data through a pipeline
      pwgen # Generate pronounceable passwords
      libqalculate # Calculator library
      tailspin # Log file analyzer
      time # Measure program resource use

      # python3Packages.howdoi
      # (buku.override { withServer = true; })
    ]
    ++ (with pkgs.unstable; [
      # Text processing and viewing
      bat # A cat clone with wings
      choose # A human-friendly alternative to cut and (sometimes) awk
      dos2unix # Convert text files between DOS, Mac and Unix formats
      fend # A command-line calculator
      file # Determine file type
      fx # A command-line JSON viewer
      gawk # GNU Awk
      glow # Markdown renderer
      grex # A command-line tool for generating regular expressions from user-provided test cases
      gron # Make JSON greppable
      hexyl # A command-line hex viewer
      jaq # A jq clone written in Rust
      jc # Convert command output to JSON
      jless # A command-line JSON viewer
      jnv # A jq-like tool for JSON
      lnav # Log file navigator
      moor # A command-line tool for viewing and manipulating JSON
      ov # A terminal pager
      qsv # CSV toolkit
      sd # A sed alternative
      translate-shell # Command-line translator
      visidata # A terminal spreadsheet multitool
      xan # A command-line XML viewer

      # Archiving and compression
      brotli # Brotli compressor/decompressor
      bzip2 # Bzip2 compressor/decompressor
      bzip3 # Bzip3 compressor/decompressor
      gzip # GNU zip compressor/decompressor
      libarchive # Multi-format archive and compression library
      pbzip2 # Parallel bzip2
      pigz # Parallel gzip
      pixz # Parallel xz
      unar # Unarchiver
      unrar # Unrar
      unzip # Unzip
      zip # Zip
      zstd # Zstandard compressor/decompressor

      # Miscellaneous utilities
      gemini-cli # Gemini CLI
      glow # Markdown renderer
      halp # A command-line help tool
      newsboat # RSS/Atom feed reader
      ouch # A command-line tool for archiving and compression
      pastel # A command-line tool for colors
      pay-respects # A command-line tool for paying respects
      poop # A command-line tool for deleting files
      progress # Show progress for cp, mv, dd, tar, gzip, bzip2, cat and other commands
      pueue # Command-line task queue
      rlwrap # Readline wrapper
      ruplacer # Find and replace text in files
      spacer # A command-line tool for adding spaces
      tz # A command-line tool for timezones
      vivid # A ls colorizer
    ]);
}
