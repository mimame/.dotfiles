{ pkgs, ... }:
{
  environment.systemPackages = with pkgs.unstable; [
    # Web browsers
    (pkgs.wrapFirefox (pkgs.firefox-unwrapped.override {
      ffmpegSupport = true;
      pipewireSupport = true;
    }) { }) # Firefox with multimedia support
    google-chrome # Google Chrome web browser
    nyxt # Keyboard-driven web browser
    qutebrowser # Keyboard-driven, vim-like browser
    (vivaldi.override {
      proprietaryCodecs = true;
      enableWidevine = true;
    }) # Vivaldi web browser
  ];
}
