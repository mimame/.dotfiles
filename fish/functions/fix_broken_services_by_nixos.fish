function fix_broken_services_by_nixos --description "Repair systemd user services broken by NixOS updates"
    # Retrieve all systemd user services in ~/.config/systemd/user/
    set -l user_services_dir ~/.config/systemd/user
    set services (fd '.service$' $user_services_dir 2>/dev/null)
    set -l fixed_count 0
    set -l error_count 0

    # echo "🔍 Scanning for broken systemd user services..."

    # If no services are found, use a predefined list of service names
    if test (count $services) -eq 0
        set -l names configure-gtk gammastep swayidle udiskie polkit-gnome-authentication-agent-1
        # echo "No services found in $user_services_dir. Using default list."
        for name in $names
            set services $services $user_services_dir/$name.service
        end
    end

    # echo "Checking "(count $services)" service files..."

    # Repair each broken service
    for service_path in $services
        set -l service_name (basename $service_path)

        # Check if service_path is broken (missing target)
        if not test -L $service_path
            set_color --bold yellow
            echo "⚠️  Found broken service: $service_name → $service_path"
            set_color normal

            echo -n "  Fixing... "

            # Re-enable and restart service
            if systemctl enable --user $service_name >/dev/null 2>&1
                set_color green
                echo "✓ Enabled"
                set_color normal

                echo -n "  Restarting... "
                if systemctl restart --user $service_name >/dev/null 2>&1
                    set_color green
                    echo "✓ Restarted"
                    set_color normal
                    set fixed_count (math $fixed_count + 1)
                else
                    set_color red
                    echo "✗ Failed to restart"
                    set_color normal
                    set error_count (math $error_count + 1)
                end
            else
                set_color red
                echo "✗ Failed to enable"
                set_color normal
                set error_count (math $error_count + 1)
            end
        end
    end

    # Print summary
    echo ""
    if test $fixed_count -gt 0
        set_color green
        echo "✅ Fixed $fixed_count broken service(s)"
        set_color normal
    end

    if test $error_count -gt 0
        set_color red
        echo "❌ Failed to fix $error_count service(s)"
        set_color normal
    end

    # Don't output if there are not broken services
    # if test $fixed_count -eq 0 -a $error_count -eq 0
    #     set_color green
    #     echo "✅ No broken services found!"
    #     set_color normal
    # end

    # Return error code if any errors occurred
    test $error_count -eq 0
end
