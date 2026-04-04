# ----------------------------------------------------------------------------
# Development Tools
#
# Core development utilities, build systems, code analysis, and general-purpose dev tools.
# Language-specific tools are in programs/languages/*.nix
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  environment.systemPackages =
    with pkgs;
    [
      # --- Core Libraries ---
      fakeroot # Fake root privileges for packaging
      openssl # Cryptography library
      pkg-config # Library metadata helper
      strace # System call tracer
    ]
    ++ (with pkgs.unstable; [
      # --- General Dev Tools ---
      comma # Run software without installing (nix-shell shortcut)
      entr # Run commands when files change
      gcc # GNU Compiler Collection
      hyperfine # Command-line benchmarking
      just # Command runner (Make alternative)
      mise # Polyglot version manager (asdf alternative)
      ninja # Fast build system
      opencode # AI coding agent for terminal
      qwen-code # Qwen code model
      scc # Fast code counter
      tokei # Code statistics
      watchexec # Execute commands on file changes
      zlib-ng # Zlib replacement (faster)

      # --- Code Analysis & Linting ---
      actionlint # GitHub Actions workflow linter
      ast-grep # AST-based code search
      codespell # Spell checker for code
      ltex-ls # Language server for LaTeX/Markdown
      typos # Fast source code spell checker
      typos-lsp # LSP for typos

      # --- Build Systems ---
      autoconf # GNU build system generator
      automake # GNU build automation
      bazelisk # Bazel version manager
      bison # Parser generator
      gnumake # GNU Make
      gnupatch # GNU Patch
      llvm # LLVM compiler infrastructure
      meson # Modern build system
      nextflow # Scientific workflow manager
      pcre2 # Perl-compatible regex library
      treefmt # Tree-wide code formatter
      universal-ctags # Code indexing

      # --- Miscellaneous ---
      exercism # Programming exercise platform CLI
    ]);
}
