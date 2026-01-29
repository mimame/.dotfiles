function setup_ssh_agent
    set -l ssh_keys
    for key in id_ed25519 id_ed25519_passphrase
        if test -f $HOME/.ssh/$key
            set -a ssh_keys $HOME/.ssh/$key
        end
    end

    if test -n "$ssh_keys"; and command -q keychain
        keychain --eval --quiet $ssh_keys | source
    end

    # Ensure control sockets directory exists
    if not test -d ~/.ssh/control_sockets
        mkdir -p ~/.ssh/control_sockets
    end
end
