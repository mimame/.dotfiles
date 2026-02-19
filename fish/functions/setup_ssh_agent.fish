function setup_ssh_agent --description "Initialize SSH agent and load keys (NixOS-native or keychain fallback)"
    # Proactively load specific keys.
    #
    # ARCHITECTURE:
    # 1. NixOS: Uses the system-wide 'ssh-agent' (via programs.ssh.startAgent).
    #    This is the most robust approach as it's managed by systemd.
    # 2. Fallback (macOS/Other Linux): Uses 'keychain' to manage a shared agent.
    # 3. Environment: We ALWAYS export SSH_AUTH_SOCK as a global variable to ensure
    #    inheritance for child processes (Git, etc.), avoiding 'Universal Variable' scope issues.

    set -l ssh_keys
    for key in id_ed25519 id_ed25519_passphrase
        set -l key_path $HOME/.ssh/$key
        if test -f $key_path
            set -a ssh_keys $key_path
        end
    end

    if test -n "$ssh_keys"
        if $IS_NIXOS
            # --- NixOS Strategy ---
            # 1. Cleanup rogue agents that might conflict with the system one.
            set -l agent_path /run/user/(id -u)/ssh-agent
            set -l system_agent_pids (pgrep -u $USER -f $agent_path)

            if test -n "$system_agent_pids"
                for pid in (pgrep -u $USER ssh-agent)
                    if not contains $pid $system_agent_pids
                        kill -9 $pid >/dev/null 2>&1
                    end
                end
            end

            # 2. Load keys if the agent is empty.
            if not ssh-add -l >/dev/null 2>&1
                ssh-add $ssh_keys
            end
        else if command -q keychain
            # --- Fallback Strategy (macOS/Other Linux) ---
            # We use keychain but explicitly export the variables to avoid
            # Fish universal variable scope issues.
            keychain --eval --quiet --noinherit $ssh_keys | source
            # Ensure the socket is exported to the global environment for child processes.
            set -gx SSH_AUTH_SOCK $SSH_AUTH_SOCK
            set -gx SSH_AGENT_PID $SSH_AGENT_PID
        end
    end

    # Ensure control sockets directory exists for multiplexing (see ~/.ssh/config).
    if not test -d ~/.ssh/control_sockets
        mkdir -p ~/.ssh/control_sockets
    end
end
