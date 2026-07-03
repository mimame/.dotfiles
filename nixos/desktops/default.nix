# ----------------------------------------------------------------------------
# Desktop Environment Dispatcher
#
# Selects desktop imports based on `vars.desktop`.
# To switch desktops, change `desktop` in variables.nix.
# Valid values: "niri" | "gnome" | "cosmic"
# ----------------------------------------------------------------------------
_:
let
  vars = import ../variables.nix;
  desktopModules = {
    niri = [
      ./niri
      ./dms-shell
      ./gnome-services.nix
    ];
    gnome = [ ./gnome ];
    cosmic = [ ./cosmic ];
  };
in
assert builtins.elem vars.desktop (builtins.attrNames desktopModules);
{
  imports = [ ./base.nix ] ++ desktopModules.${vars.desktop};
}
