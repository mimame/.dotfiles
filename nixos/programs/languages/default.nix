{
  imports = [
    # Toolchains moved to per-project shell.nix (work on both NixOS and macOS):
    # ./asciidoc.nix
    # ./dart.nix
    # ./elixir.nix
    # ./go.nix
    # ./julia.nix
    # ./jvm.nix
    # ./lisp.nix
    # ./lua.nix
    # ./nim.nix
    # ./node.nix
    # ./r.nix
    # ./rust.nix
    # ./zig.nix
    ./bash.nix
    ./crystal.nix
    ./fish.nix
    ./json.nix
    ./just.nix
    ./markdown.nix
    ./nix.nix
    ./protobuf.nix
    ./python.nix
    ./roc.nix
    ./ruby.nix
    ./static-site.nix
    ./toml.nix
    ./typst.nix
    ./yaml.nix
  ];
}
