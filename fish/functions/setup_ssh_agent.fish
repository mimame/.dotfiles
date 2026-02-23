function setup_ssh_agent --description "Initialize SSH agent and load keys"
    # ARCHITECTURE:
    # We use 'keychain' as our primary agent manager. It provides a robust
    # mechanism to share a single agent across all shells and sessions,
    # correctly handling environment variable propagation.
    #
    # On NixOS, we use the system-wide 'ssh-agent' (programs.ssh.startAgent = true)
    # which sets a stable socket at /run/user/$UID/ssh-agent.
    # Keychain is used to manage the *keys* in that agent and generate the
    # environment files for shell sourcing.

    # 1. Favor the system-wide NixOS agent socket if available.
    set -l nixos_agent_sock /run/user/(id -u)/ssh-agent
    if test -S "$nixos_agent_sock"
        set -gx SSH_AUTH_SOCK "$nixos_agent_sock"
    end

    set -l ssh_keys
    for key in id_ed25519 id_ed25519_no_passphrase
        set -l key_path $HOME/.ssh/$key
        if test -f $key_path
            set -a ssh_keys $key_path
        end
    end

    if test -n "$ssh_keys"
        if command -q keychain
            # --eval: Generate shell commands to set variables.
            # $ssh_keys: The keys we want keychain to manage/add.
            # --noinherit: Ensures keychain identifies the correct agent via our
            # explicitly set SSH_AUTH_SOCK instead of relying on inherited state.
            keychain --eval --quiet --noinherit $ssh_keys | source
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
