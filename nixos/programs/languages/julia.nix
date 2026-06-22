# Julia package with LD_LIBRARY_PATH wrapper for JLL binary artifact support.
#
# WHY: nixpkgs' Julia builds deps from source (USE_BINARYBUILDER=0) and does NOT
# wrap the binary with LD_LIBRARY_PATH — it assumes Julia's own build system
# handles all library linkage. However, `Pkg.add()` installs JLL (Julia
# Low-Level) binary artifacts that call dlopen() at runtime for system libs
# (e.g., libquadmath via OpenSpecFun_jll). These prebuilt .so files have no Nix
# RPATH, so the dynamic linker can't find them without LD_LIBRARY_PATH.
#
# We wrap Julia to prepend gcc.cc.lib (libquadmath, etc.) to LD_LIBRARY_PATH.
{
  pkgs,
  ...
}:

let
  unwrapped = pkgs.unstable.julia;
  julia =
    pkgs.runCommand "julia-wrapped-${unwrapped.version}"
      {
        nativeBuildInputs = [ pkgs.makeWrapper ];
      }
      ''
        mkdir -p $out/bin
        makeWrapper ${unwrapped}/bin/julia $out/bin/julia \
          --prefix LD_LIBRARY_PATH : "${pkgs.gcc.cc.lib}/lib"
      '';
in
{
  environment.systemPackages = [ julia ];
}
