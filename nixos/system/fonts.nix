# ----------------------------------------------------------------------------
# Font Configuration
#
# Configures font rendering, emoji support, and Nerd Fonts for terminal/IDE.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;

    # Font packages: Nerd Fonts + emoji + sans/serif
    packages = with pkgs.unstable; [
      # Maple Mono (No Ligatures, Nerd Font):
      # WHY: Soft, rounded design reduces visual fatigue during long coding sessions.
      # The unique character shapes help combat terminal monotony and maintain focus.
      maple-mono.NL-NF
      nerd-fonts.jetbrains-mono # Fallback for better legibility

      # Serif: Merriweather
      # WHY: More contemporary and warm than Noto Serif, optimized for screen readability
      merriweather

      # Sans-Serif: Roboto
      # WHY: Modern geometric sans-serif with excellent readability
      roboto

      # Source Sans 3 (formerly Source Sans Pro)
      # WHY: Adobe's versatile UI font
      # See: https://github.com/adobe-fonts/source-sans/issues/192
      source-sans

      # Icons & Emoji
      font-awesome
      noto-fonts
      noto-fonts-color-emoji
    ];

    # Fontconfig: Rendering and fallback rules
    # See: https://www.freedesktop.org/software/fontconfig/fontconfig-user.html
    fontconfig = {
      enable = true;
      antialias = true; # Smooth edges
      hinting = {
        enable = true;
        style = "slight"; # Light hinting (best for high-DPI screens)
      };
      subpixel = {
        rgba = "rgb"; # Subpixel order for LCD screens
        lcdfilter = "default"; # Reduce color fringing
      };

      # Default fonts by family
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        serif = [
          "Merriweather"
          "Noto Color Emoji"
        ];
        sansSerif = [
          "Roboto"
          "Noto Color Emoji"
        ];
        monospace = [
          "Maple Mono NL NF"
          "JetBrainsMonoNL Nerd Font Mono"
          "Noto Color Emoji"
        ];
      };
    };
  };
}
