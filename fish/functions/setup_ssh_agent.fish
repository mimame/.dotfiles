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
    # potentially insecure (users might disable signing or remove passphrases).
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
    # - No need for keychain: systemd provides equivalent functionality
    #
    # ** Darwin/macOS **
    # - No system-wide ssh-agent service by default
    # - Each shell traditionally spawns its own agent (keys not shared)
    # - Keychain provides agent lifecycle management similar to systemd
    # - Keychain creates ~/.keychain/ with environment variables for reuse
    # - macOS Keychain Integration: Native ssh-add can use macOS keychain,
    #   but use keychain(1) for consistency with Linux workflows
    #
    # --- WHY NOT USE KEYCHAIN ON NIXOS? ---
    # - Redundant: NixOS systemd agent already provides persistence
    # - Simpler: Direct ssh-add to system agent is more transparent
    # - Faster: No additional process management overhead
    # - Fewer moving parts: Less to debug if something breaks
    #
    # --- WHY NOT SKIP KEYCHAIN ON DARWIN? ---
    # - Necessary: No built-in persistent agent mechanism
    # - Cross-session: Ensures zellij, cron, and new shells share the same agent
    # - Established tool: Industry standard for this exact use case
    #
    # --- KEY ORDERING STRATEGY ---
    # Keys are loaded in this order:
    #   1. id_ed25519_no_passphrase (no prompt, always succeeds)
    #   2. id_ed25519 (requires passphrase on first load)
    #
    # Rationale: Load no-passphrase key first so it's available immediately,
    # then prompt for passphrase key. This ensures at least one key works
    # even if the user cancels the passphrase prompt.
    #
    # --- FINGERPRINT CHECKING ---
    # Before adding a key, check if its fingerprint is already in the agent.
    # This prevents:
    # - Redundant passphrase prompts in new shells (keys already loaded)
    # - Agent clutter (duplicate key entries)
    # - Slow shell startup (ssh-add is fast if key is already present)
    #
    # ============================================================================

    # 1. Collect SSH keys to load
    # NOTE: Order matters! No-passphrase keys first for immediate availability.
    set -l ssh_keys
    for key in id_ed25519_no_passphrase id_ed25519
        set -l key_path $HOME/.ssh/$key
        if test -f $key_path
            set -a ssh_keys $key_path
        end
    end

    if test -z "$ssh_keys"
        # No keys found, nothing to do
        return
    end

    # 2. Platform-specific agent setup
    if $IS_NIXOS
        # --- NixOS: Use system-wide ssh-agent service ---
        # The socket is created by: programs.ssh.startAgent = true
        # (see nixos/hardware/networking.nix)
        set -l nixos_agent_sock /run/user/(id -u)/ssh-agent

        if test -S "$nixos_agent_sock"
            # Export SSH_AUTH_SOCK so ssh-add and git can find the agent
            set -gx SSH_AUTH_SOCK "$nixos_agent_sock"
        else
            # Socket missing: systemd service might not be running
            # This shouldn't happen, but is handled gracefully
            echo "Warning: NixOS ssh-agent socket not found at $nixos_agent_sock" >&2
            return 1
        end

        # Add keys only if not already loaded (prevents duplicate prompts)
        for key in $ssh_keys
            # Extract SHA256 fingerprint from private key
            set -l key_fingerprint (ssh-keygen -lf $key 2>/dev/null | awk '{print $2}')

            if test -z "$key_fingerprint"
                echo "Warning: Could not get fingerprint for $key" >&2
                continue
            end

            # Check if this specific key is already in the agent
            if not ssh-add -l 2>/dev/null | grep -q "$key_fingerprint"
                # Key not loaded, add it (will prompt for passphrase if needed)
                # Redirect stderr to /dev/null to suppress "Identity added" messages
                ssh-add $key 2>/dev/null
            end
        end

    else if $IS_DARWIN
        # --- Darwin/macOS: Use keychain for agent persistence ---
        if command -q keychain
            # Keychain manages the agent lifecycle and creates environment files
            # at ~/.keychain/$HOSTNAME-fish which is sourced to get SSH_AUTH_SOCK.
            #
            # Options explained:
            # --eval: Output shell commands (set -x SSH_AUTH_SOCK ...) to stdout
            #         Pipe this to 'source' to apply them to the current shell
            # --quiet: Suppress informational messages like "Found existing ssh-agent"
            # --quick: Skip checking if keys are still valid (faster startup)
            #          Keys are checked on actual use anyway, so this is safe
            #
            # How it works:
            # - First run: Starts ssh-agent, adds keys (prompts for passphrase)
            # - Subsequent runs: Finds existing agent, reuses it (no prompt)
            # - After reboot: Starts new agent, prompts again (expected behavior)
            keychain --eval --quiet --quick $ssh_keys | source

        else
            # Fallback if keychain is not installed (shouldn't happen on Darwin
            # as it's in brew/Brewfile, but is handled defensively)
            echo "Warning: keychain not found, starting ssh-agent manually" >&2

            # Start agent if not already running
            if not set -q SSH_AUTH_SOCK; or not test -S "$SSH_AUTH_SOCK"
                eval (ssh-agent -c) >/dev/null
            end

            # Add keys with fingerprint checking (same logic as NixOS)
            for key in $ssh_keys
                set -l key_fingerprint (ssh-keygen -lf $key 2>/dev/null | awk '{print $2}')
                if test -n "$key_fingerprint"
                    if not ssh-add -l 2>/dev/null | grep -q "$key_fingerprint"
                        ssh-add $key 2>/dev/null
                    end
                end
            end
        end
    end

    # 3. Ensure SSH multiplexing directory exists
    # This is referenced in ~/.ssh/config (ControlPath directive) and allows
    # connection reuse, dramatically speeding up repeated SSH connections.
    # See: ssh_config(5) ControlMaster, ControlPath, ControlPersist
    if not test -d ~/.ssh/control_sockets
        mkdir -p ~/.ssh/control_sockets
    end
end
