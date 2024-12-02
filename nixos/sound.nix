{ pkgs, ... }:
{

  security.rtkit.enable = true;
  # Enable sound with pipewire.
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    # media-session.enable = true;
  };

  # Real-time microphone noise suppression
  programs.noisetorch.enable = true;

  environment.systemPackages =
    with pkgs;
    [

      pwvucontrol
    ]
    ++ (with pkgs.unstable; [

      beets
      cmus
    ]);
}
