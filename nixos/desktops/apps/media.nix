{ pkgs, ... }:
{
  environment.systemPackages = with pkgs.unstable; [
    # Media players and codecs
    ffmpeg-full # Complete FFmpeg suite
    gst_all_1.gst-plugins-bad # GStreamer bad plugins
    gst_all_1.gst-plugins-base # GStreamer base plugins
    gst_all_1.gst-plugins-good # GStreamer good plugins
    gst_all_1.gst-plugins-ugly # GStreamer ugly plugins
    gst_all_1.gstreamer # GStreamer multimedia framework
    spotify # Music streaming service
    vlc # VLC media player
  ];
}
