function setup_ssh_agent --description "Initialize SSH agent and load keys"
    # ARCHITECTURE:
    # We use 'keychain' as our primary agent manager. It provides a robust
    # mechanism to share a single agent across all shells and sessions,
    # correctly handling environment variable propagation.

    set -l ssh_keys
    for key in id_ed25519 id_ed25519_no_passphrase
        set -l key_path $HOME/.ssh/$key
        if test -f $key_path
            set -a ssh_keys $key_path
        end
    end

    if test -n "$ssh_keys"
        # On NixOS, we already have a systemd-managed agent.
        # Keychain will find it via SSH_AUTH_SOCK or we can let it manage its own.
        # The key is that keychain creates a file (~/.keychain/$HOSTNAME-fish)
        # that we can source in every shell to get the correct environment.
        if command -q keychain
            # --eval: Generate shell commands to set variables.
            # $ssh_keys: The keys we want keychain to manage/add.
            # We don't use --noinherit so keychain can reuse the NixOS systemd agent.
            keychain --eval --quiet $ssh_keys | source
        else
            # Minimal fallback if keychain is missing.
            if not ssh-add -l >/dev/null 2>&1
                ssh-add $ssh_keys
            end
        end
    end

    # Ensure control sockets directory exists for multiplexing (see ~/.ssh/config).
    if not test -d ~/.ssh/control_sockets
        mkdir -p ~/.ssh/control_sockets
    end
end
