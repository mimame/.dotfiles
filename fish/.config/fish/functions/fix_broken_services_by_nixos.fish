# Reinstall systemd user services broken by NixOS updates
function fix_broken_services_by_nixos
    set services $(fd service ~/.config/systemd/user/)
    if test $(count $services) -eq 0
        # Hardcoded services in case they were deleted
        set names gammastep swayidle xdg-desktop-portal-rewrite-launchers
        set services
        for name in $names
            set services $services ~/.config/systemd/user/$name.service
        end
    end
    for service_path in $services
        set -l nix_path $(realpath $service_path)
        if not test -e $nix_path
            set_color --bold red
            echo "Fixing $(basename $service_path) broken by a NixOS update..."
            set_color normal
            if test -e $service_path
                rm $service_path 2>/dev/null
            end
            systemctl enable --user $(basename $service_path) 2>/dev/null
            systemctl restart --user $(basename $service_path) 2>/dev/null
        else
            break # All broken at the same time
        end
    end
end
