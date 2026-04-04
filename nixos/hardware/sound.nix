# ----------------------------------------------------------------------------
# Sound Configuration (PipeWire)
#
# Modern audio server with ALSA, PulseAudio, and optional JACK emulation.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  # RealtimeKit for low-latency audio
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    # jack.enable = true;
  };

  # Real-time microphone noise suppression
  programs.noisetorch.enable = true;

  environment.systemPackages =
    with pkgs;
    [
      pwvucontrol # PipeWire volume control
    ]
    ++ (with pkgs.unstable; [
      beets # Music library manager
      cmus # Console music player
    ]);
}
