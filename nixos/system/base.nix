{ pkgs, username, ... }:
{

  # Enable zRAM swap to provide a compressed RAM-based swap device.
  # This improves system responsiveness under memory pressure by avoiding disk I/O.
  zramSwap = {
    enable = true;
    # Percentage of total RAM used to define the maximum size of the zram device.
    # Note: Setting this to 100% does not "reserve" that RAM; it only sets the
    # capacity. Because the data is compressed (typically 2:1 or 3:1), this
    # effectively increases the available memory for development workloads.
    memoryPercent = 100;
    # Priority of the zram swap device (higher values take precedence).
    # Setting this to 100 ensures the kernel exhausts the fast, compressed RAM
    # swap before falling back to slower disk-based swap partitions.
    priority = 100;
  };

  # Enable systemd-oomd. It monitors Pressure Stall Information (PSI) to
  # identify and terminate processes causing extreme memory pressure
  # (e.g., memory leaks) before the kernel locks up.
  systemd.oomd.enable = true;

  # Optimize shutdown responsiveness.
  # Reduces the default 90s "stop job" timeout to 10s. This prevents the
  # system from hanging for extended periods during shutdown/reboot when
  # services (like VMs or containers) fail to terminate immediately, while
  # still providing a safe 10s window for data flushing.
  systemd.settings.Manager.DefaultTimeoutStopSec = "10s";

  # ----------------------------------------------------------------------------
  # Proactive System Maintenance: Systemd User Service Self-Healing
  # ----------------------------------------------------------------------------

  # This script solves the "broken symlink" issue common in NixOS.
  #
  # THE PROBLEM:
  # Systemd user services can be enabled in two ways:
  # 1. Declarative (The NixOS Way): Defined in Nix config with 'wantedBy'.
  #    Links are created in /etc/systemd/user/. These are ALWAYS correct and
  #    updated automatically by NixOS.
  # 2. Imperative (The Manual Way): Running 'systemctl --user enable'.
  #    Links are created in ~/.config/systemd/user/. These point to a specific
  #    Nix store path at the moment of execution.
  #
  # WHY IT BREAKS:
  # Manual links (~/.config/...) "shadow" NixOS links (/etc/...). When you
  # update and run garbage collection, the manual link becomes a "dangling"
  # pointer to a deleted store path. Systemd sees the broken link first and
  # fails to start the service, even if the NixOS-managed link is fine.
  #
  # THE SOLUTION:
  # This activation script runs during every 'nh os switch'. It:
  # 1. Prunes: Deletes any broken symlinks in user home directories (~/.config/systemd/user).
  # 2. Heals: By removing the broken manual link, Systemd is forced to fall back
  #    to the correct, declarative link provided by NixOS in /etc/systemd/user/.
  # 3. Refreshes: Triggers 'daemon-reload' for active sessions to apply changes
  #    without requiring a logout.
  system.activationScripts.systemd-user-self-healing = {

    deps = [
      "users"
      "groups"
      "specialfs"
    ];
    text = ''
      echo "🛠️  Running Systemd User Service Self-Healing..."

      for home in /home/*; do
        [ -d "$home" ] || continue
        username=$(basename "$home")
        user_id=$(id -u "$username" 2>/dev/null)
        [ -n "$user_id" ] || continue

        # 1. Prune broken symlinks in the user's systemd config directory.
        if [ -d "$home/.config/systemd/user" ]; then
          ${pkgs.findutils}/bin/find "$home/.config/systemd/user" -xtype l -delete -print | while read -r link; do
            echo "  [ $username ] Removed broken unit link: $link"
          done
        fi

        # 2. If the user has an active systemd manager (is logged in),
        # trigger a daemon-reload so they pick up updated units immediately.
        if [ -S "/run/user/$user_id/systemd/private" ]; then
          echo "  [ $username ] Refreshing active user session..."
          ${pkgs.systemd}/bin/systemctl --machine="$username@.host" --user daemon-reload 2>/dev/null || true
        fi
      done
    '';
  };

  services = {
    # Enable periodic SSD TRIM to maintain SSD performance
    fstrim.enable = true;

    # Enable power management support via UPower
    upower.enable = true;

    # Aims to provide high performance and reliability,
    # while keeping compatibility to the D-Bus reference implementation
    dbus.implementation = "broker";

    # Configure X11 keymap with US layout and AltGr international variant
    xserver = {
      xkb = {
        layout = "us";
        variant = "altgr-intl";
      };
      exportConfiguration = true;
    };

    # Enable UDisks2 for storage device management
    udisks2.enable = true;

    # Enable and configure keyd for advanced, ergonomic key remapping.
    # This setup applies to all keyboards and introduces two main features:
    # 1. Dual-function Caps Lock: Acts as Control when held, and Escape when tapped.
    # 2. Oneshot Modifiers: Ctrl, Alt, Meta, and Shift can be tapped once to modify
    #    the next key press, reducing the need to hold them down for shortcuts.
    keyd = {
      enable = true;
      keyboards = {
        default = {
          ids = [ "*" ];
          settings = {
            main = {
              capslock = "overload(control, esc)";
              # Oneshot modifiers can be dangerous. For example, the meta key can
              # block the tiling manager and other apps that expect key combinations.
              # While it's more natural to not have to hold down the keys, it can
              # be difficult to get used to.
              # control = "oneshot(control)";
              # leftalt = "oneshot(alt)";
              # meta = "oneshot(meta)";
              # rightalt = "oneshot(altgr)";
              # shift = "oneshot(shift)";
            };
          };
        };
      };
    };

    # 3200-2000-1200-800DPI
    # ls -l /dev/input/by-id/*
    # mouse-dpi-tool /dev/input/event27
    # mouse:usb:v1bcfp0053:name:USB Optical Mouse  Mouse:
    #  MOUSE_DPI=2000@145
    udev.extraHwdb = ''
      mouse:usb:*
       MOUSE_DPI=3200@145
    '';

    kmscon = {
      enable = true;
      extraConfig = ''
        font-name=Maple Mono NL NF
        font-size=16
        xkb-layout=us
        xkb-variant=altgr-intl
      '';
      extraOptions = "--term xterm-ghostty";
      hwRender = true;
    };
  };

  # Configure console keymap to US layout
  console.keyMap = "us";

  # Enable uinput support for user-level input handling
  hardware.uinput.enable = true;

  # Set default locale to US English with UTF-8 encoding
  i18n.defaultLocale = "en_US.UTF-8";

  # Always enable the shell system-wide
  # Otherwise it won't source the necessary files
  # Use completion files provided by other packages
  # Source configuration snippets provided by other packages
  # Autoload fish functions provided by other packages
  programs.fish = {
    enable = true;
    package = pkgs.fish;
  };

  # Many programs look at /etc/shells to determine
  # if a user is a "normal" user and not a "system" user
  environment.shells = [ pkgs.fish ];

  security = {
    # Policy that allows unprivileged processes to speak to privileged processes
    polkit.enable = true;

    # Security
    sudo-rs = {
      # Only ask sudo password one time for all tty
      # Ask sudo password each 2h instead 5 minutes
      package = pkgs.unstable.sudo-rs;
    };

    # FIXME: sudo-rs doesn't write to /etc/sudoers file the extraConfig and extraRules
    sudo = {
      extraConfig = ''
        Defaults !tty_tickets
        Defaults timestamp_timeout=120
      '';
      extraRules = [
        {
          users = [ "${username}" ];
          commands = [
            {
              command = "/run/current-system/sw/bin/systemctl restart geoclue.service";
              options = [ "NOPASSWD" ];
            }
            {
              command = "/run/current-system/sw/bin/podman";
              options = [ "NOPASSWD" ];
            }
            {
              command = "/run/current-system/sw/bin/lxc";
              options = [ "NOPASSWD" ];
            }
            {
              command = "/run/current-system/sw/bin/lxd";
              options = [ "NOPASSWD" ];
            }
          ];
        }
      ];
    };
  };

  # Enable apropos(1) and the -k option of man(1)
  documentation.man.generateCaches = true;

  environment.systemPackages =
    with pkgs;
    [

      exfatprogs # exfat format support
      interception-tools
      libevdev # mouse-dpi-tool
      libnotify

    ]
    ++ (with pkgs.unstable; [

    ]);
}
