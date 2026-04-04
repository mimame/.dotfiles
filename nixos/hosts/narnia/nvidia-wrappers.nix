# ----------------------------------------------------------------------------
# NVIDIA-Accelerated Applications for Narnia
#
# Wraps specific applications to always run on the NVIDIA GPU via PRIME Offload.
# This approach allows selective GPU usage while keeping most of the system
# on the Intel iGPU for better battery life.
#
# Applications wrapped here benefit significantly from GPU acceleration:
# - Code editors: GPU-accelerated rendering and scrolling
# - Browsers: Hardware video decode, WebGL, smooth scrolling
# - Media players: Hardware-accelerated video playback
# ----------------------------------------------------------------------------
{ pkgs, ... }:
let
  # Wrap a package to run with NVIDIA GPU via PRIME Offload environment variables.
  # This sets the environment variables that force rendering on the discrete GPU.
  wrapNvidia =
    pkg: binary:
    pkgs.symlinkJoin {
      name = "${pkg.name}-nvidia";
      paths = [ pkg ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/${binary} \
          --set __NV_PRIME_RENDER_OFFLOAD 1 \
          --set __NV_PRIME_RENDER_OFFLOAD_PROVIDER NVIDIA-G0 \
          --set __GLX_VENDOR_LIBRARY_NAME nvidia \
          --set __VK_LAYER_NV_optimus NVIDIA_only
      '';
    };
in
{
  environment.systemPackages = [
    # Development tools - GPU acceleration improves editor responsiveness.
    (wrapNvidia pkgs.unstable.vscode "code")
    (wrapNvidia pkgs.unstable.zed-editor "zeditor")

    # Media player - hardware video decode reduces CPU usage.
    (wrapNvidia pkgs.unstable.vlc "vlc")

    # Web browsers - GPU acceleration for rendering, video, and WebGL.
    (wrapNvidia (pkgs.wrapFirefox (pkgs.firefox-unwrapped.override {
      ffmpegSupport = true;
      pipewireSupport = true;
    }) { }) "firefox")
    (wrapNvidia pkgs.unstable.google-chrome "google-chrome-stable")
    (wrapNvidia (pkgs.unstable.vivaldi.override {
      proprietaryCodecs = true;
      enableWidevine = true;
    }) "vivaldi")
  ];
}
