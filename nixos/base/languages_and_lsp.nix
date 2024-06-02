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
      # JavaScript/TypeScript
      yarn
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
      lua
      luajitPackages.luarocks
      lua-language-server
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
      buf-language-server
      protobuf
    ])
    ++ (with pkgs.unstable; [
      # Python
      # hatch
      jupyter-all
      poetry
      pre-commit
      python3Packages.ipython
      python3Packages.ptpython
      python3Packages.pylsp-mypy
      python3Packages.pylsp-rope
      python3Packages.python-lsp-ruff
      python3Packages.python-lsp-server
      python3Packages.radian
      ruff
      rye
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
    ++ (with pkgs.unstable; [
      # Scala
      ammonite
      bloop
      coursier
      metals
      mill
      sbt-with-scala-native
      scala_3
      scala-cli
      scalafix
      scalafmt
    ])
    ++ (with pkgs.unstable; [
      # Shell
      nushellFull
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
      nodejs
      nodePackages.bash-language-server
      nodePackages.npm
      nodePackages.svelte-language-server
      nodePackages.typescript
      typescript
      nodePackages.typescript-language-server
      nodePackages.vscode-css-languageserver-bin
      nodePackages.vscode-html-languageserver-bin
      nodePackages.vscode-json-languageserver
      nodePackages.yaml-language-server
    ])
    ++ (with pkgs.unstable; [
      # Typst
      typst
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
      gnumake
      gnupatch
      graphviz
      hunspell
      hunspellDicts.en-us-large
      hunspellDicts.es-es
      hunspellDicts.fr-moderne
      hyphen
      lldb
      llvm
      ltex-ls
      meson
      mise
      nextflow
      pandoc
      pcre2
      languagetool
      plantuml
      ripsecrets
      taplo
      terraform-ls
      treefmt
      typos
      universal-ctags
    ]);
}
