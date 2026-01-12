{ pkgs, ... }:

{
  environment.systemPackages =
    with pkgs;
    [
      # Core development utilities
      fakeroot
      openssl
      pkg-config
      strace
    ]
    ++ (with pkgs.unstable; [
      # General development tools
      comma # Runs software without installing it
      entr # Run arbitrary commands when files change
      gcc # GNU Compiler Collection
      hyperfine # Benchmarking tool
      just # Command runner
      ninja # Build system
      qwen-code # Qwen code model
      scc # Code counter
      tokei # Code counter
      watchexec # Execute commands when files change
      zlib-ng # Zlib replacement

      # Code analysis and linting
      actionlint # Static checker for GitHub Actions workflow files
      ast-grep # AST-based grep
      codespell # Spell checker for code
      ltex-ls # Language server for LaTeX
      typos # Source code spell checker
      typos-lsp # LSP for typos

      # Build system tools
      autoconf # Autoconf
      automake # Automake
      bazelisk # Bazel version manager
      bison # Parser generator
      gnumake # GNU Make
      gnupatch # GNU Patch
      llvm # LLVM compiler infrastructure
      meson # Build system
      nextflow # Workflow manager
      pcre2 # Perl Compatible Regular Expressions
      treefmt # Tree-wide formatter
      universal-ctags # Tag generator

      # Miscellaneous development tools
      exercism # Exercism CLI
      mise # Polyglot development tool
    ]);
}
