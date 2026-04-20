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
      # WHY:
      # - Terminal: The soft, rounded design and clear glyphs reduce visual
      #   fatigue, while its distinct character shapes maintain high legibility.
      # - UI Avoidance: While excellent for code, monospaced fonts (like Maple Mono)
      #   are less efficient for dense UI text (like system menus/dialogs) because
      #   the fixed character width makes proportional text look "gapped" and
      #   disrupts reading flow. We use a proportional font like Inter for the UI
      #   to ensure natural spacing and superior reading ergonomics.
      maple-mono.NL-NF
      nerd-fonts.jetbrains-mono # Fallback for better legibility

      # Serif: Merriweather
      # WHY: More contemporary and warm than Noto Serif, optimized for screen readability
      merriweather

      # Sans-Serif: Inter
      # WHY: Industry standard for UI, optimized for readability
      inter

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
          "Inter"
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
