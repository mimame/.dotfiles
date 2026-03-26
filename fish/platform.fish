# platform.fish
# This file is dynamically sourced by config.fish based on the detected OS.

if set -q IS_NIXOS; and test "$IS_NIXOS" = true
    # NixOS specific shell integrations
    source_transient any-nix-shell "any-nix-shell fish --info-right" $__fish_config_dir/config.fish

    # Systemd Shortcuts
    # System
    abbr scd 'sudo systemctl disable'
    abbr sce 'sudo systemctl enable'
    abbr scr 'sudo systemctl restart'
    abbr scs 'sudo systemctl start'
    abbr sct 'sudo systemctl status'
    abbr sck 'sudo systemctl stop'
    abbr se sudoedit
    abbr sv sudoedit

    # User
    abbr scud 'systemctl --user disable'
    abbr scue 'systemctl --user enable'
    abbr scur 'systemctl --user restart'
    abbr scus 'systemctl --user start'
    abbr scut 'systemctl --user status'
    abbr scuk 'systemctl --user stop'
end

if set -q IS_DARWIN; and test "$IS_DARWIN" = true
    # macOS specific shell integrations
end
