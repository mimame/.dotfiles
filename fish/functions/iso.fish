function iso --description "Burn image files to USB drives safely (Cross-platform)"
    if test (count $argv) -lt 2
        echo "Usage: iso <image_file> <target_device>"
        echo "Example (Linux): iso ubuntu.iso /dev/sdb"
        echo "Example (macOS): iso ubuntu.iso /dev/disk4"
        return 1
    end

    set -l img "$argv[1]"
    set -l dev "$argv[2]"
    set -l os (uname -s)

    # 1. Basic validation
    if not test -f "$img"
        echo "Error: Image file '$img' not found." >&2
        return 1
    end

    if not test -e "$dev"
        echo "Error: Target device '$dev' not found." >&2
        return 1
    end

    # 2. Display device info and confirm
    echo "⚠️  WARNING: This will ERASE ALL DATA on $dev"
    echo "Image:  $img ($(du -h "$img" | cut -f1))"

    if test "$os" = Darwin
        if not command -q diskutil
            echo "Error: diskutil not found." >&2
            return 1
        end
        diskutil info "$dev" | grep -E "Device Identifier|Device / Media Name|Total Size"
    else
        if command -q lsblk
            lsblk -dp -o NAME,MODEL,SIZE,FSTYPE,MOUNTPOINT "$dev"
        else
            echo "Target: $dev"
        end
    end

    read -l -P "Are you sure you want to continue? [y/N] " confirm
    if not string match -qi y -- "$confirm"
        echo "Operation cancelled."
        return 1
    end

    # 3. Platform-specific prep and unmount
    if test "$os" = Darwin
        # On macOS, using /dev/rdisk is significantly faster than /dev/disk
        set dev (string replace "/dev/disk" "/dev/rdisk" "$dev")
        echo "Unmounting $dev..."
        sudo diskutil unmountDisk "$dev"
    else
        # On Linux, ensure all partitions are unmounted
        echo "Unmounting all partitions of $dev..."
        if command -q lsblk
            for mp in (lsblk -no MOUNTPOINT "$dev" | grep .)
                sudo umount "$mp"
            end
        else
            # Fallback for systems without lsblk
            set -l base (string replace -r '[0-9]+$' '' "$dev")
            mount | grep "^$base" | cut -d' ' -f1 | xargs -I{} sudo umount {}
        end
    end

    # 4. Execute write
    echo "Writing image to $dev... (This may take a while)"

    set -l dd_cmd sudo dd if="$img" of="$dev" bs=4m
    if test "$os" = Linux
        # GNU dd supports progress and fdatasync
        set dd_cmd $dd_cmd status=progress conv=fdatasync
    end

    if not $dd_cmd
        echo "Error: dd failed." >&2
        return 1
    end

    # 5. Finalize
    echo "Syncing..."
    sync

    if test "$os" = Darwin
        sudo diskutil eject "$dev" 2>/dev/null
    end

    echo "✅ Success: Image written to $dev"
end
