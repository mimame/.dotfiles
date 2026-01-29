# Repair systemd user services that may be broken after a NixOS update.
#
# NixOS manages systemd services via symbolic links. After an update, these
# symlinks can sometimes point to non-existent paths in the Nix store,
# effectively "breaking" the service.
#
# This function identifies such broken services (either broken symlinks or
# completely missing files) and attempts to repair them by re-enabling and
# restarting them via `systemctl`.
function fix_broken_services_by_nixos --description "Repair systemd user services broken by NixOS updates"
    # Optimization: Only run if the system generation has changed.
    set -l current_gen (readlink /run/current-system)
    set -l stamp_file ~/.config/fish/cache/last_service_fix_gen
    if test -f $stamp_file; and test (cat $stamp_file) = "$current_gen"
        return
    end

    # Define the directory where user-specific systemd services are stored.
    set -l user_services_dir ~/.config/systemd/user

    # Find all files ending in `.service` that are symbolic links (`-t l`).
    # We specifically target symlinks because that's how NixOS manages services.
    # This is more precise than finding any file with that extension.
    set -l service_paths (fd -t l '.service$' $user_services_dir 2>/dev/null)
    set -l fixed_count 0
    set -l error_count 0

    # echo "🔍 Scanning for broken systemd user services..."

    # If `fd` finds no symbolic links, it might be because they are all missing.
    # In this case, we fall back to a predefined list of common services that
    # are expected to exist.
    if test (count $service_paths) -eq 0
        set -l default_service_names udiskie polkit-gnome-authentication-agent-1 # espanso configure-gtk
        # echo "No services found in $user_services_dir. Using default list."
        for name in $default_service_names
            set -a service_paths "$user_services_dir/$name.service"
        end
    end

    # echo "Checking "(count $service_paths)" service files..."

    # Iterate over each potential service path to check its status.
    for service_path in $service_paths
        # Extract the service name (e.g., "udiskie.service") from the full path.
        # This is the name we'll pass to `systemctl`.
        set -l service_name (basename $service_path)

        # Check if the service is broken.
        # `test -e` returns false if the file does not exist. For a symbolic link,
        # it checks if the *target* of the link exists.
        # This condition is true for both completely missing files and for
        # symbolic links that point to a non-existent location (broken links).
        if not test -e "$service_path"
            set_color --bold yellow
            echo "⚠️  Found broken service: $service_name → $service_path"
            set_color normal

            echo -n "  Fixing... "

            # Attempt to repair the service by re-enabling it.
            # `systemctl enable` recreates the symbolic link to point to the correct
            # unit file in the current Nix store.
            # We use --force to overwrite the existing broken symlink.
            set -l enable_output (systemctl enable --force --user $service_name 2>&1)

            if test $status -eq 0
                set_color green
                echo "✓ Enabled"
                set_color normal

                # After re-enabling, restart the service to ensure it's running.
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

                # Print the error message from systemctl for debugging
                echo "    Error: $enable_output"

                set error_count (math $error_count + 1)
            end
        end
    end

    # Print a summary of the actions taken.
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

    # Record completion to skip subsequent runs on this generation
    echo "$current_gen" >$stamp_file

    # Return a non-zero exit code if any errors occurred.
    test $error_count -eq 0
end
