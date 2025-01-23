{ pkgs, ... }:
{

  programs.java = {
    enable = true;
    package = pkgs.unstable.jdk21;
  };

  environment.systemPackages =
    with pkgs;
    [

    ]
    ++ (with pkgs.unstable; [
      # Asciidoc
      asciidoc-full
      asciidoctor
    ])
    ++ (with pkgs.unstable; [
      # Bash
      shellcheck
      shfmt
    ])
    ++ (with pkgs.unstable; [
      # Clojure
      clojure
      leiningen
    ])
    ++ (with pkgs.unstable; [
      # Crystal
      ameba
      crystal
      shards
    ])
    ++ (with pkgs.unstable; [
      # Dart
      flutter # dart included
    ])
    ++ (with pkgs.unstable; [
      # Elixir
      elixir
      elixir-ls
    ])
    ++ (with pkgs.unstable; [
      # Go
      go
      golangci-lint
      gopls
    ])
    ++ (with pkgs.unstable; [
      # Inko
      inko
      ivm
    ])
    ++ (with pkgs.unstable; [
      # Janet
      janet
      jpm
    ])
    ++ (with pkgs.unstable; [
      # JavaScript/TypeScript
      yarn
    ])
    ++ (with pkgs.unstable; [
      # Json
      nodePackages.vscode-json-languageserver
      jsonfmt
    ])
    ++ (with pkgs.unstable; [
      # Julia
      julia-bin
    ])
    ++ (with pkgs.unstable; [
      # Latex
      tectonic
      texlab
      texlive.combined.scheme-medium
    ])
    ++ (with pkgs.unstable; [
      # Lua
      # lua
      # Lua 5.1 required by all the neovim setups
      lua51Packages.jsregexp
      lua51Packages.lua
      lua51Packages.luarocks
      lua-language-server
      # luarocks
      stylua
    ])
    ++ (with pkgs.unstable; [
      # Markdown
      frogmouth
      inlyne
      markdownlint-cli2
      marksman
      mdbook
      mdl
    ])
    ++ (with pkgs.unstable; [
      # Nix
      nil
      nixfmt-rfc-style
      nixpkgs-review
    ])
    ++ (with pkgs.unstable; [
      # Nim
      nim
    ])
    ++ (with pkgs.unstable; [
      # Protocol Buffers
      buf
      protobuf
    ])
    ++ (with pkgs.unstable; [
      # Python
      # hatch
      jupyter-all
      poetry
      python3Packages.ipython
      python3Packages.ptpython
      python3Packages.pylsp-mypy
      python3Packages.pylsp-rope
      python3Packages.python-lsp-ruff
      python3Packages.python-lsp-server
      python3Packages.radian
      ruff
      uv
    ])
    ++ (with pkgs.unstable; [
      # Ruby
      bundler
      ruby-lsp
      rubyPackages.pry
      rubyPackages.railties
      solargraph
    ])
    ++ (with pkgs.unstable; [
      # Rust
      rustup
    ])
    # ++ (with pkgs.unstable; [
    #   # Scala
    #   ammonite
    #   bloop
    #   coursier
    #   metals
    #   mill
    #   sbt-with-scala-native
    #   scala_3
    #   scala-cli
    #   scalafix
    #   scalafmt
    # ])
    ++ (with pkgs.unstable; [
      # Shell
      nushell
      xonsh
      zsh
    ])
    ++ (with pkgs.unstable; [
      # Static HTML
      hugo
      jekyll
      zola
    ])
    ++ (with pkgs.unstable; [
      # TypeScript/Node.js
      biome
      nodejs
      nodePackages.bash-language-server
      nodePackages.npm
      nodePackages.svelte-language-server
      nodePackages.typescript
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      typescript
    ])
    ++ (with pkgs.unstable; [
      # Typst
      tinymist
      typst
      typstyle
    ])
    ++ (with pkgs.unstable; [
      # Yaml
      yaml-language-server
      yamlfmt
    ])
    ++ (with pkgs.unstable; [
      # Zig
      zig
      zls
    ])
    ++ (with pkgs.unstable; [
      # Miscellaneous
      ansible
      ast-grep
      autoconf
      automake
      bazelisk
      bison
      buf
      codespell
      coreutils
      devenv
      exercism
      gitleaks
      gnumake
      gnupatch
      graphviz
      hunspell
      hunspellDicts.en-us-large
      hunspellDicts.es-es
      hunspellDicts.fr-moderne
      hyphen
      languagetool
      lldb
      llvm
      ltex-ls
      meson
      mise
      nextflow
      pandoc
      pcre2
      plantuml
      ripsecrets
      taplo
      treefmt
      typos
      typos-lsp
      universal-ctags
    ]);
}
