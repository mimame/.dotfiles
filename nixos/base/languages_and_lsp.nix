{ pkgs, ... }: {
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
      bundler
      # clang # breaks the lvim treesitter compilation
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
      gopls
      graphviz
      (hiPrio fish) # collition warnings: needed for programs.fish.enable
      hugo
      hunspell
      hunspellDicts.en-us-large
      hunspellDicts.es-es
      hunspellDicts.fr-moderne
      hyphen
      jekyll
      julia-bin
      just
      languagetool
      lldb
      llvm
      ltex-ls
      lua
      luajitPackages.luarocks
      lua-language-server
      marksman
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
      plantuml
      pipx
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
      rnix-lsp
      rtx
      ruby-lsp
      rubyPackages.pry
      rubyPackages.railties
      rustup
      rye
      sbt-with-scala-native # scala
      scala_3
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
      typos
      universal-ctags
      xonsh
      yarn
      zig
      zola

    ]);
}
