# ----------------------------------------------------------------------------
# Sound and Audio Configuration (PipeWire)
#
# This file configures the system's audio stack using PipeWire, a modern
# server for handling audio and video streams.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  # Enable RealtimeKit to grant audio processes real-time scheduling priority.
  # This is crucial for achieving low-latency audio, which is important for
  # professional audio work and reducing audio crackling.
  security.rtkit.enable = true;

  # Enable the PipeWire audio server.
  services.pipewire = {
    enable = true;
    # Enable ALSA integration, allowing PipeWire to manage ALSA clients.
    alsa.enable = true;
    alsa.support32Bit = true;
    # Enable PulseAudio emulation, allowing PulseAudio clients to work seamlessly.
    pulse.enable = true;
    # JACK emulation can be enabled for professional audio applications.
    # jack.enable = true;
  };

  # Enable NoiseTorch for real-time microphone noise suppression.
  programs.noisetorch.enable = true;

  # Install system-wide audio-related packages.
  environment.systemPackages =
    with pkgs;
    [
      # A volume control utility for PipeWire.
      pwvucontrol
    ]
    ++ (with pkgs.unstable; [
      # A music library manager and tagger.
      beets
      # A console-based music player.
      cmus
    ]);
}
