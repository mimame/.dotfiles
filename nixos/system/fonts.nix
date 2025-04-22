{ pkgs, ... }:
{

  # Primary font paths
  fonts = {
    fontDir.enable = true;
    enableDefaultPackages = true;
    packages = with pkgs.unstable; [
      # Comparing JetBrainsMono (No Ligatures) and Hack:
      # - Hack is a monospaced font, but has visual inconsistencies with characters of variable width
      #   (e.g., parenthesis, brackets, and characters with different styles, like ||).
      # - JetBrains Mono focuses on consistent spacing and legibility, making it a preferred choice for coding.
      # Referenced issue for context: https://github.com/freeCodeCamp/freeCodeCamp/issues/49174

      # Merriweather:
      # - A serif font that is more contemporary and warm compared to Noto Serif.
      # - Optimized for screen readability, making it suitable for both body text and headlines.

      # Roboto:
      # - A modern, geometric sans-serif font known for its high readability.
      # - Preferred over Noto Sans for its clean and versatile design.
      nerd-fonts.jetbrains-mono
      nerd-fonts.hack
      font-awesome
      merriweather
      noto-fonts
      noto-fonts-color-emoji
      roboto
      source-sans-pro
    ];
    fontconfig = {
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        serif = [
          "Merriweather"
          # "Noto Serif"
          "Noto Color Emoji"
        ];
        sansSerif = [
          "Roboto"
          # "Noto Sans"
          "Noto Color Emoji"
        ];
        monospace = [
          "JetBrainsMonoNL Nerd Font Mono"
          "Noto Color Emoji"
          # "Hack"
        ];
      };
    };
  };
}
