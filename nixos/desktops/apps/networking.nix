{ pkgs, ... }:
{
  environment.systemPackages = with pkgs.unstable; [
    # File synchronization and transfer
    dropbox # Cloud storage service
    filezilla # FTP, FTPS and SFTP client
  ];
}
