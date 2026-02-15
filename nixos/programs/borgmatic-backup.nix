_: {
  # To use this backup service, the borg repository must be initialized first.
  # This is a one-time setup step for a new backup drive/location.
  #
  # 1. Make sure the backup drive is mounted at:
  #    /run/media/${vars.username}/TOSHIBA_EXT
  #
  # 2. Run the following command to initialize the repository.
  #    Using "repokey-blake2" is recommended for good performance and security.
  #    BORG_PASSPHRASE=mimame borgmatic repo-create --encryption=repokey-blake2 /run/media/${vars.username}/TOSHIBA_EXT/backups/borg-narnia-backups
  services.borgmatic = {
    enable = true;
  };

}
