{ pkgs, ... }:

{
  environment.systemPackages =
    with pkgs;
    [

    ]
    ++ (with pkgs.unstable; [
      artem # A modern image viewer for the terminal
      chafa # Command-line tool to convert images to ANSI/Unicode character art
      imagemagick # Software suite to create, edit, and compose bitmap images
      jp2a # Convert JPEG images to ASCII
      spotify-player # A Spotify client for the terminal
      ueberzugpp # A command-line image viewer that uses Kitty graphics protocol
    ]);
}
