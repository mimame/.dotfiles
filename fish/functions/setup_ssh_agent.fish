function setup_ssh_agent --description "Initialize SSH agent and load keys via keychain"
    # Proactively load specific keys using keychain.
    #
    # ARCHITECTURE:
    # 1. NixOS provides a single, system-wide 'ssh-agent' (via programs.ssh.startAgent).
    # 2. GNOME's 'gcr-ssh-agent' is disabled to prevent it from intercepting requests
    #    for modern ed25519 keys, which it often fails to handle correctly.
    # 3. 'keychain' manages the system agent, ensuring keys are unlocked only
    #    once per reboot and shared across all terminal sessions.
    set -l ssh_keys
    # id_ed25519: Primary personal/GitHub key.
    # id_ed25519_passphrase: Any additional key with a passphrase.
    for key in id_ed25519 id_ed25519_passphrase
        set -l key_path $HOME/.ssh/$key
        if test -f $key_path
            set -a ssh_keys $key_path
        end
    end

    if test -n "$ssh_keys"; and command -q keychain
        # Use the standard NixOS system-wide SSH agent socket.
        # This ensures all shells and child processes point to the same agent.
        set -gx SSH_AUTH_SOCK /run/user/1000/ssh-agent

        # keychain handles key management for this system agent.
        # --eval outputs shell code to set variables, but we source it to
        # refresh key identities without creating new agent processes.
        keychain --eval --quiet $ssh_keys | source
    end

    # Ensure control sockets directory exists for multiplexing (see ~/.ssh/config).
    if not test -d ~/.ssh/control_sockets
        mkdir -p ~/.ssh/control_sockets
    end
end
