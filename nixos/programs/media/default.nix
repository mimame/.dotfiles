# ----------------------------------------------------------------------------
# Media Tools
#
# Image/video viewers, converters, and media information tools.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs.unstable; [
    # --- Image Tools ---
    artem # Modern terminal image viewer
    chafa # Convert images to ANSI/Unicode art
    imagemagick # Image creation, editing, composition
    jp2a # Convert JPEG to ASCII
    ueberzugpp # Image viewer using Kitty graphics protocol

    # --- Video/Audio ---
    mpv # GPU-accelerated media player (for yazi preview)
    mediainfo # Show media file metadata (for yazi)
  ];
}
