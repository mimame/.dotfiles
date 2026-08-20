# ----------------------------------------------------------------------------
# System Services
#
# Background services: file indexing (locate), LLMs (llama.cpp), file sync (Syncthing), GPG.
# ----------------------------------------------------------------------------
{
  lib,
  pkgs,
  username,
  ...
}:
{
  services = {
    # plocate: Fast file indexing and search (disabled — use fd/rg instead)
    locate = {
      enable = false;
      package = pkgs.unstable.plocate;
    };

    # Syncthing: Continuous file synchronization
    syncthing = {
      enable = true;
      openDefaultPorts = true; # 22000 (sync), 21027 (discovery)
      user = "${username}";
      dataDir = "/home/${username}";
    };
  };

  # GnuPG agent for encryption/signing
  # WHY enableSSHSupport=false: Prevents empty passphrase SSH keys (security)
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
  };

  # Espanso: Text expander
  services.espanso = {
    enable = true;
    package = pkgs.unstable.espanso-wayland;
  };

  # WHY: espanso panics with `NoCompositor` (exit 101) if it spawns before
  # niri's Wayland socket exists — an upstream `unwrap()` bug in
  # espanso-detect/src/evdev/sync/wayland.rs. The stock module only binds to
  # graphical-session.target, which does NOT order the unit after the
  # compositor, so every boot it crash-loops until a retry wins the race.
  # Wait for the socket explicitly and lift the restart rate limit.
  systemd.user.services.espanso = {
    after = [ "niri.service" ];
    wants = [ "niri.service" ];
    serviceConfig = {
      ExecStartPre = pkgs.writeShellScript "espanso-wait-wayland" ''
        i=0
        while [ "$i" -lt 60 ]; do
          [ -S "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY" ] && exit 0
          i=$((i + 1))
          sleep 0.5
        done
        echo "Timed out waiting for Wayland socket $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY" >&2
        exit 1
      '';
      RestartSec = 5;
      StartLimitIntervalSec = 0;
    };
  };
}
