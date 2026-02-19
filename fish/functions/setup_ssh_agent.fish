function setup_ssh_agent --description "Initialize SSH agent and load keys"
    # ARCHITECTURE:
    # 1. NixOS: We use the systemd-managed 'ssh-agent' (via programs.ssh.startAgent).
    #    This is global across the desktop session.
    # 2. Fallback (macOS/Other Linux): We use 'keychain' as a shared agent manager.

    set -l ssh_keys
    for key in id_ed25519 id_ed25519_no_passphrase
        set -l key_path $HOME/.ssh/$key
        if test -f $key_path
            set -a ssh_keys $key_path
        end
    end

    if test -n "$ssh_keys"
        if $IS_NIXOS
            # NixOS Strategy: Use the systemd agent path.
            # Variables.fish already exports SSH_AUTH_SOCK, so we just use it.
            if test -S "$SSH_AUTH_SOCK"
                for key in $ssh_keys
                    set -l pub_key $key.pub
                    if test -f "$pub_key"
                        # Check if the key's fingerprint is already in the agent.
                        set -l finger (ssh-keygen -lf "$pub_key" | awk '{print $2}')
                        if not ssh-add -l | grep -q "$finger"
                            # If not in agent, load it. We ONLY prompt if the shell
                            # is interactive to avoid blocking non-interactive tools.
                            if status is-interactive
                                ssh-add "$key"
                            end
                        end
                    end
                end
            end
        else if command -q keychain
            # Fallback Strategy (macOS/Other Linux)
            # Keychain manages its own agent or inherits one.
            keychain --eval --quiet --noinherit $ssh_keys | source
            # Explicitly export as global to child processes.
            set -gx SSH_AUTH_SOCK $SSH_AUTH_SOCK
            set -gx SSH_AGENT_PID $SSH_AGENT_PID
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
