{ pkgs, ... }:
{

  # services.xserver = {
  #   enable = true;
  #   displayManager.gdm.enable = true;
  #   desktopManager.gnome.enable = true;
  # }

  # GNOME Keyring daemon
  services.gnome.gnome-keyring.enable = true;
  # Enable GNOME settings
  services.gnome.gnome-settings-daemon.enable = true;
  # Enable GNOME online accounts
  services.gnome.gnome-online-accounts.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = {
    seahorse.enable = true;
  };

  # ensure gnome-settings-daemon udev rules are enabled
  services.udev.packages = with pkgs; [ gnome-settings-daemon ];

  # Trash support, SFTP, SMB, HTTP, DAV, and many others URIs for gnome
  services.gvfs.enable = true;

  # Fix dconf-WARNING from GNOME applications
  programs.dconf.enable = true;

  environment.systemPackages =
    with pkgs;
    [
    ]
    ++ (with pkgs.unstable; [

      sweet
      baobab
      eog
      file-roller
      geary
      gnome-control-center
      gparted
      glib # gsettings
      (hiPrio beauty-line-icon-theme) # avoid default gnome icon themes
      meld
      nautilus
    ]);
}
