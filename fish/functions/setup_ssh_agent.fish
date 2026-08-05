function setup_ssh_agent --description "Initialize SSH agent and load keys"
    # ============================================================================
    # SSH AGENT ARCHITECTURE & RATIONALE
    # ============================================================================
    #
    # This function provides cross-platform SSH agent management for NixOS and
    # Darwin (macOS), with different strategies due to platform differences.
    #
    # --- PROBLEM STATEMENT ---
    # Git commit signing (gpg.format = ssh, commit.gpgSign = true) requires SSH
    # keys to be loaded in ssh-agent. Without persistent agent management, users
    # must re-enter passphrases for every commit, which is both annoying and
    # potentially insecure.
    #
    # --- GOALS ---
    # 1. Enter passphrase ONCE per login/boot session (security + convenience)
    # 2. Keys persist across all shell sessions (zellij, new terminals, etc.)
    # 3. Support both passphrase-protected and no-passphrase keys
    # 4. Cross-platform consistency (NixOS + Darwin/macOS)
    #
    # --- PLATFORM-SPECIFIC IMPLEMENTATIONS ---
    #
    # ** NixOS (programs.ssh.startAgent = true) **
    # - Systemd manages ssh-agent as a user service
    # - Socket location: /run/user/$UID/ssh-agent (stable across sessions)
    # - Agent lifetime: From login to logout/reboot
    # - Directly use SSH_AUTH_SOCK and add keys with ssh-add
    #
    # ** Darwin/macOS **
    # - Native agent lifecycle managed via launchd natively
    # - Apple's OpenSSH patch reads/writes passphrases to Apple Keychain
    #   via `UseKeychain yes` in ~/.ssh/config or `ssh-add --apple-use-keychain`
    # - No external keychain tool dependency needed
    #
    # --- KEY ORDERING STRATEGY ---
    # Keys are loaded in this order:
    #   1. id_ed25519_no_passphrase (no prompt, always succeeds)
    #   2. id_ed25519 (requires passphrase on first load)
    #
    # --- FINGERPRINT CHECKING ---
    # Before adding a key, check if its fingerprint is already in the agent.
    # This prevents redundant passphrase prompts and shell startup lag.
    # ============================================================================

    # 1. Collect SSH keys to load — auto-discover all private keys in ~/.ssh/
    # A file is considered a private key if a matching .pub companion exists.
    # No-passphrase keys are loaded first: probe with an empty passphrase via
    # ssh-keygen -y; success means no passphrase required.
    set -l keys_no_pass
    set -l keys_with_pass
    for key in $HOME/.ssh/id_*
        # Skip .pub files and anything without a .pub companion
        string match -q '*.pub' $key; and continue
        test -f "$key.pub"; or continue

        if ssh-keygen -y -P '' -f $key &>/dev/null
            set -a keys_no_pass $key
        else
            set -a keys_with_pass $key
        end
    end

    set -l ssh_keys $keys_no_pass $keys_with_pass

    if test (count $ssh_keys) -eq 0
        return
    end

    # 2. Platform-specific agent setup
    if $IS_NIXOS
        # --- NixOS: Use system-wide ssh-agent service ---
        # The socket is created by: programs.ssh.startAgent = true
        set -l nixos_agent_sock /run/user/(id -u)/ssh-agent

        if test -S "$nixos_agent_sock"
            # Export SSH_AUTH_SOCK so ssh-add and git can find the agent
            set -gx SSH_AUTH_SOCK "$nixos_agent_sock"
        else
            echo "Warning: NixOS ssh-agent socket not found at $nixos_agent_sock" >&2
            return 1
        end

        # Add keys only if not already loaded (prevents duplicate prompts)
        for key in $ssh_keys
            # Extract SHA256 fingerprint from private key
            set -l key_fingerprint (string split ' ' -- (ssh-keygen -lf $key 2>/dev/null))[2]

            if test -z "$key_fingerprint"
                echo "Warning: Could not get fingerprint for $key" >&2
                continue
            end

            # Check if this specific key is already in the agent
            if not string match -q -- "*$key_fingerprint*" (ssh-add -l 2>/dev/null)
                ssh-add $key 2>/dev/null
            end
        end

    else if $IS_DARWIN
        # --- Darwin/macOS: Use native Apple Keychain & launchd ---
        for key in $ssh_keys
            # Extract SHA256 fingerprint from private key
            set -l key_fingerprint (string split ' ' -- (ssh-keygen -lf $key 2>/dev/null))[2]

            if test -z "$key_fingerprint"
                echo "Warning: Could not get fingerprint for $key" >&2
                continue
            end

            # Check if this specific key is loaded in macOS ssh-agent
            if not string match -q -- "*$key_fingerprint*" (ssh-add -l 2>/dev/null)
                # Load key into agent and retrieve passphrase automatically from Apple Keychain
                ssh-add --apple-use-keychain $key 2>/dev/null
            end
        end
    end

    # 3. Ensure SSH multiplexing directory exists
    if not test -d ~/.ssh/control_sockets
        mkdir -p ~/.ssh/control_sockets
    end
end
