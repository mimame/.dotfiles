{ pkgs, ... }: {
  environment.systemPackages = with pkgs;
    [

      nixfmt
      nixpkgs-review
      rustup
      stylua

    ] ++ (with pkgs.unstable; [

      ameba
      ansible
      asciidoc-full
      asciidoctor
      autoconf
      automake
      bison
      cmake
      hyphen
      graphviz
      coreutils
      crystal
      elixir
      gnumake
      gnupatch
      # clang # breaks the lvim treesitter compilation
      go
      gopls
      (hiPrio fish) # collition warnings: needed for programs.fish.enable
      hugo
      hunspellDicts.en-us-large
      hunspellDicts.es-es
      hunspellDicts.fr-moderne
      jekyll
      julia-bin
      just
      lldb
      llvm
      lua
      lua-language-server
      marksman
      meson
      nextflow
      nil
      nim
      nodePackages.bash-language-server
      nodePackages.typescript
      nodePackages.typescript-language-server
      nodePackages.vscode-css-languageserver-bin
      nodePackages.vscode-html-languageserver-bin
      nodePackages.vscode-json-languageserver
      nodePackages.yaml-language-server
      nuspell
      pandoc
      pcre2
      plantuml
      python3Full
      python3Packages.cython
      python3Packages.ipython
      python3Packages.ptpython
      python3Packages.pylsp-mypy
      python3Packages.pylsp-rope
      python3Packages.python-lsp-ruff
      python3Packages.python-lsp-server
      python3Packages.radian
      R
      rnix-lsp
      ruby_3_2
      shards
      shellcheck
      shfmt
      taplo
      tectonic
      texlab
      typos
      universal-ctags
      vagrant
      xonsh
      zig
      zola

    ]);
}
