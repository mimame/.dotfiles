# # Burn image files to USB
function iso
    sudo umount "$argv[2]" 2>/dev/null
    sudo dd bs=4M if="$argv[1]" of="$argv[2]" status=progress conv=fdatasync
end
