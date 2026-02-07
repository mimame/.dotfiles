{ pkgs, ... }:
{

  # Primary font configuration
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs.unstable; [
      # Maple Mono (No Ligatures, Nerd Font):
      # - Soft, rounded, and aesthetic design that reduces visual fatigue during long sessions.
      # - The unique character shapes help combat terminal monotony and maintain focus.
      # - JetBrains Mono remains as a high-legibility secondary fallback.
      maple-mono.NL-NF
      nerd-fonts.jetbrains-mono

      # Merriweather:
      # - A serif font that is more contemporary and warm compared to Noto Serif.
      # - Optimized for screen readability, making it suitable for both body text and headlines.
      merriweather

      # Roboto:
      # - A modern, geometric sans-serif font known for its high readability.
      # - Preferred over Noto Sans for its clean and versatile design.
      roboto

      # Source Sans:
      # - Adobe's "Source Sans Pro" was renamed to "Source Sans 3" (https://github.com/adobe-fonts/source-sans/issues/192).
      # - Nixpkgs subsequently renamed `source-sans-pro` to `source-sans`.
      source-sans

      # Icons & Symbols
      font-awesome
      noto-fonts
      noto-fonts-color-emoji
    ];

    fontconfig = {
      enable = true;
      antialias = true;
      hinting = {
        enable = true;
        style = "slight"; # Best balance for modern high-DPI screens
      };
      subpixel = {
        rgba = "rgb";
        lcdfilter = "default";
      };

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
