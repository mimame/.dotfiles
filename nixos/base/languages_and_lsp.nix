{ pkgs, ... }: {

  programs.java = {
    enable = true;
    package = pkgs.unstable.jdk21;
  };

  environment.systemPackages = with pkgs;
    [

    ] ++ (with pkgs.unstable; [

      ameba
      ammonite # scala
      ansible
      apache-airflow
      asciidoc-full
      asciidoctor
      autoconf
      automake
      bison
      bloop
      buf # protocol buffers
      buf-language-server # protocol buffers
      bundler
      # clang # breaks the lvim treesitter compilation
      clojure
      cmake
      codespell
      coreutils
      coursier # scala
      crystal
      elixir
      elixir-ls
      gnumake
      gnupatch
      go
      golangci-lint
      gopls
      graphviz
      hatch
      (hiPrio fish) # collision warnings: needed for programs.fish.enable
      hugo
      hunspell
      hunspellDicts.en-us-large
      hunspellDicts.es-es
      hunspellDicts.fr-moderne
      hyphen
      inlyne
      jekyll
      julia-bin
      jupyter-all
      just
      languagetool
      leiningen # clojure
      lldb
      llvm
      ltex-ls
      lua
      luajitPackages.luarocks
      lua-language-server
      markdownlint-cli2
      marksman
      mdbook
      mdl
      meson
      metals # scala
      micromamba
      mill # scala
      nextflow
      nil
      nim2
      nixfmt
      nixpkgs-review
      # nls
      nodejs
      nodePackages.bash-language-server
      nodePackages.npm
      nodePackages.svelte-language-server
      nodePackages.typescript
      nodePackages.typescript-language-server
      nodePackages.vscode-css-languageserver-bin
      nodePackages.vscode-html-languageserver-bin
      nodePackages.vscode-json-languageserver
      nodePackages.yaml-language-server
      nushellFull
      nuspell
      pandoc
      pcre2
      pipx
      plantuml
      pre-commit
      protobuf
      python3Full
      python3Packages.cython
      python3Packages.flake8
      python3Packages.ipython
      python3Packages.ptpython
      python3Packages.pylsp-mypy
      python3Packages.pylsp-rope
      python3Packages.python-lsp-ruff
      python3Packages.python-lsp-server
      python3Packages.radian
      R
      ripsecrets
      rnix-lsp
      rtx
      ruby-lsp
      rubyPackages.pry
      rubyPackages.railties
      rustup
      rye
      sbt-with-scala-native # scala
      scala_3
      scala-cli
      scalafix
      scalafmt
      shards
      shellcheck
      shfmt
      solargraph
      stylua
      taplo
      tectonic
      terraform-ls
      texlab
      texlive.combined.scheme-medium
      treefmt
      typos
      typst
      universal-ctags
      xonsh
      yarn
      zig
      zls
      zola

    ]);
}
