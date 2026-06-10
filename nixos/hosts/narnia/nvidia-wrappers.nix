# ----------------------------------------------------------------------------
# NVIDIA-Accelerated Applications for Narnia
#
# Wraps specific applications to always run on the NVIDIA GPU via PRIME Offload.
# This approach allows selective GPU usage while keeping most of the system
# on the Intel iGPU for better battery life.
#
# WHY wrap these apps:
# - Code editors: GPU-accelerated rendering provides smoother scrolling
# - Browsers: Hardware video decode, WebGL performance, smooth scrolling
# - Media players: Hardware-accelerated video playback reduces CPU usage
#
# TRADE-OFF: Always-plugged-in laptop, so battery impact is acceptable
# for the performance benefits.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
let
  # Wrap a package to run with NVIDIA GPU via PRIME Offload environment variables.
  # Forces rendering on the discrete GPU instead of the integrated Intel GPU.
  #
  # extraEnv: additional wrapProgram flags for app-specific Wayland backends.
  # WHY split: MOZ_ENABLE_WAYLAND is Mozilla-only; NIXOS_OZONE_WL/ELECTRON_*
  # are Electron/Chromium-only. Applying all vars to all apps is semantically
  # wrong and can confuse runtime backend detection.
  wrapNvidia =
    pkg: binary: extraEnv:
    pkgs.symlinkJoin {
      name = "${pkg.name}-nvidia";
      paths = [ pkg ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/${binary} \
          --set __NV_PRIME_RENDER_OFFLOAD 1 \
          --set __NV_PRIME_RENDER_OFFLOAD_PROVIDER NVIDIA-G0 \
          --set __GLX_VENDOR_LIBRARY_NAME nvidia \
          --set __VK_LAYER_NV_optimus NVIDIA_only \
          ${extraEnv}
      '';
    };

  # Wayland backend flags per runtime type.
  # WHY: Prevents the unreliable XWayland-to-Wayland clipboard bridge and
  # avoids 'stuck' selections common in hybrid GPU setups.
  mozWayland = "--set MOZ_ENABLE_WAYLAND 1";
  electronWayland = "--set NIXOS_OZONE_WL 1 --set ELECTRON_OZONE_PLATFORM_HINT auto";
in
{
  environment.systemPackages = [
    # Development tools — Electron-based, use Ozone Wayland backend
    # WHY: GPU acceleration improves editor responsiveness, especially for
    # large files and syntax highlighting
    (wrapNvidia pkgs.unstable.vscode "code" electronWayland)
    (wrapNvidia pkgs.unstable.zed-editor "zeditor" electronWayland)

    # Media player — native Wayland support, no extra env needed
    # WHY: Hardware video decode reduces CPU usage and heat during playback
    (wrapNvidia pkgs.unstable.vlc "vlc" "")

    # Web browsers
    # WHY: GPU acceleration provides:
    # - Hardware video decode (lower CPU, better battery despite GPU use)
    # - Faster WebGL rendering for web apps
    # - Smoother scrolling on complex pages
    (wrapNvidia (pkgs.wrapFirefox (pkgs.firefox-unwrapped.override {
      ffmpegSupport = true; # Enable FFmpeg for video codec support
      pipewireSupport = true; # Enable screen sharing via PipeWire
    }) { }) "firefox" mozWayland)
    (wrapNvidia pkgs.unstable.google-chrome "google-chrome-stable" electronWayland)
    (wrapNvidia (pkgs.unstable.vivaldi.override {
      proprietaryCodecs = true; # H.264, AAC support
      enableWidevine = true; # DRM for Netflix, Spotify, etc.
    }) "vivaldi" electronWayland)
  ];
}
