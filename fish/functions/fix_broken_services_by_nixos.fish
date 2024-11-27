# Reinstall systemd user services broken by NixOS updates
function fix_broken_services_by_nixos
    # Retrieve all systemd user services in ~/.config/systemd/user/
    set services (fd '.service' ~/.config/systemd/user/)

    # If no services are found, use a predefined list of service names
    if test (count $services) -eq 0
        set -l names gammastep swayidle xdg-desktop-portal-rewrite-launchers
        for name in $names
            set services $services ~/.config/systemd/user/$name.service
        end
    end

    # Repair each broken service
    for service_path in $services
        set -l nix_path (realpath --canonicalize-missing $service_path)

        # Check if service path is broken (missing target)
        if test -L $service_path -a ! -e $nix_path
            set_color --bold red
            echo "Fixing (basename $service_path) broken by a NixOS update..."
            set_color normal

            # Remove broken symlink and re-enable the service
            rm $service_path 2>/dev/null
            systemctl enable --user (basename $service_path) 2>/dev/null
            systemctl restart --user (basename $service_path) 2>/dev/null
        end
    end
end
