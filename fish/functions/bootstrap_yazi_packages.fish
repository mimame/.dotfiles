function bootstrap_yazi_packages --description "Self-install Yazi plugins and flavors declared in package.toml"
    # WHY: dotter only symlinks top-level yazi config files; plugins/flavors are
    # fetched by `ya pkg`. On a fresh deploy the missing plugins/ dir crashes yazi
    # with "Lua runtime failed" in init.lua. This syncs installs from package.toml.
    command -q ya
    or return 0

    set -l yazi_cfg (path normalize "$__fish_config_dir/../yazi")
    test -f "$yazi_cfg/package.toml"
    or return 0

    # Declared deps: one per `use = "..."` line in package.toml
    set -l req (count (string match --regex '^use\s*=' <$yazi_cfg/package.toml))

    # Installed packages: *.yazi dirs under plugins/ and flavors/
    set -l dirs
    test -d "$yazi_cfg/plugins"
    and set -a dirs "$yazi_cfg/plugins"
    test -d "$yazi_cfg/flavors"
    and set -a dirs "$yazi_cfg/flavors"

    set -l inst 0
    if test (count $dirs) -gt 0
        set inst (count (find $dirs -maxdepth 1 -mindepth 1 -type d -name '*.yazi' 2>/dev/null))
    end

    if test "$inst" -lt "$req"
        echo "📦 Bootstrapping Yazi packages ($inst/$req)..."
        ya pkg install
    end
end
