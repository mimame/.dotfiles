function iso --description "Burn image files to USB drives safely"
    if test (count $argv) -lt 2
        echo "Usage: iso <image_file> <target_device>"
        echo "Example: iso ubuntu.iso /dev/sdb"
        return 1
    end

    # Check if files/devices exist
    if not test -f "$argv[1]"
        echo "Error: Image file '$argv[1]' not found" >&2
        return 1
    end

    if not test -e "$argv[2]"
        echo "Error: Target device '$argv[2]' not found" >&2
        return 1
    end

    # Confirm with user before proceeding
    echo "WARNING: This will ERASE ALL DATA on $argv[2]"
    echo "Image: $argv[1]"
    echo "Target: $argv[2]"
    read -l -P "Are you sure you want to continue? [y/N] " confirm

    if test "$confirm" != y -a "$confirm" != Y
        echo "Operation cancelled"
        return 1
    end

    # Unmount all partitions of the target device
    echo "Unmounting all partitions of $argv[2]..."
    set device_base (string replace -r '[0-9]+$' '' "$argv[2]")
    for mount in (mount | grep "^$device_base" | cut -d' ' -f1)
        echo "Unmounting $mount..."
        sudo umount "$mount" 2>/dev/null
    end

    # Write image with progress
    echo "Writing image to device..."
    sudo dd bs=4M if="$argv[1]" of="$argv[2]" status=progress conv=fdatasync

    # Sync to ensure all data is written
    echo "Syncing file system..."
    sync

    echo "Image successfully written to $argv[2]"
end
