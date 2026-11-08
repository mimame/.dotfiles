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
    # 1. ZERO passphrase prompts per boot once keys are enrolled in the
    #    keyring/Keychain (NixOS: GNOME login keyring, unlocked by the login
    #    password at greetd; macOS: Apple Keychain). Fallback stays one-time
    #    per session if a key is unenrolled or the keyring is locked.
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
    # - Passphrase source: GNOME login keyring via secret-tool + SSH_ASKPASS
    #   (unlocked by the greetd/tuigreet login password -> one password unlocks
    #   keyring AND ssh keys; falls back to the terminal prompt if locked or
    #   a key was never enrolled). The lookup is timeout-guarded: against a
    #   locked collection secret-tool waits on a prompter that may not exist
    #   (tty, headless), which would stall every shell startup.
    #
    # ** Darwin/macOS **
    # - Native agent lifecycle managed via launchd natively
    # - Apple's OpenSSH patch reads/writes passphrases to Apple Keychain
    #   via `UseKeychain yes` in ~/.ssh/config or `ssh-add --apple-use-keychain`
    # - No external agent-wrapper tool needed (Apple Keychain IS the store)
    #
    # --- KEY ORDERING STRATEGY ---
    # Keys are collected in two lists; no-passphrase keys are added first and
    # never go through the secret path (ssh-add on an unencrypted key cannot
    # prompt). Keys with passphrases then get the keyring/Keychain attempt.
    #
    # --- FINGERPRINT CHECKING ---
    # One `ssh-add -l` snapshot per run; before adding a key, its fingerprint
    # is checked against it. This prevents redundant passphrase prompts and
    # shell startup lag (a round-trip per key is avoided).
    # ============================================================================

    # 1. Collect SSH keys to load — auto-discover all private keys in ~/.ssh/
    # A file is considered a private key if a matching .pub companion exists.
    # No-passphrase keys are detected with an empty-passphrase probe via
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

    if test (count $keys_no_pass) -eq 0; and test (count $keys_with_pass) -eq 0
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

        # Single snapshot of what the agent already holds
        set -l loaded (ssh-add -l 2>/dev/null)

        # 2a. No-passphrase keys: nothing to remember, ssh-add never prompts
        for key in $keys_no_pass
            set -l key_fingerprint (string split ' ' -- (ssh-keygen -lf $key 2>/dev/null))[2]
            if test -z "$key_fingerprint"
                echo "Warning: Could not get fingerprint for $key" >&2
                continue
            end
            if not string match -q -- "*$key_fingerprint*" $loaded
                ssh-add $key &>/dev/null
            end
        end

        # Materialise the SSH_ASKPASS helper at runtime instead of shipping
        # a repo file: OpenSSH 10.6 ssh-add has NO stdin passphrase flag
        # (verified against 10.6p1), and SSH_ASKPASS must be an executable
        # path. $XDG_RUNTIME_DIR is user-only (700 on tmpfs); the two-line
        # script is cheap to rewrite per shell and never touches the repo,
        # dotter or .gitignore (the repo-wide 'bin/' ignore would have made
        # a checked-in copy invisible to git without 'add -f').
        set -l askpass "$XDG_RUNTIME_DIR/ssh-keyring-askpass"
        printf '%s\n' '#!/bin/sh' 'printf "%s\n" "$SSH_PASSPHRASE"' >$askpass
        chmod 700 $askpass

        # 2b. Keys with passphrase: feed from the login keyring when enrolled
        for key in $keys_with_pass
            set -l key_fingerprint (string split ' ' -- (ssh-keygen -lf $key 2>/dev/null))[2]
            if test -z "$key_fingerprint"
                echo "Warning: Could not get fingerprint for $key" >&2
                continue
            end
            if string match -q -- "*$key_fingerprint*" $loaded
                continue
            end

            # Keyring path: the passphrase is stored in the login keyring
            # (unlocked at login by greetd/tuigreet -> pam_gnome_keyring).
            # Lookup succeeds silently when unlocked, and ssh-add gets the
            # passphrase through SSH_ASKPASS -> zero prompts per boot.
            # One-time enrollment per key:
            #   secret-tool store --label "ssh passphrase (id_x)" \
            #       service ssh key id_x
            # WHY not gcr-ssh-agent: disabled for its ed25519 re-prompt bug
            # (see nixos/desktops/gnome-services.nix); this reproduces the
            # "keys live in the keyring" UX without inheriting that bug.
            # WHY timeout: a locked collection makes secret-tool wait for a
            # GUI prompter that may not exist here; 5s cap keeps shell
            # startup bounded, then the interactive fallback below runs.
            set -l added 0
            set -l secret (timeout 5 secret-tool lookup service ssh key (path basename $key) 2>/dev/null)
            if test -n "$secret"
                begin
                    set -lx SSH_PASSPHRASE $secret
                    set -lx SSH_ASKPASS $askpass
                    set -lx SSH_ASKPASS_REQUIRE force
                    if ssh-add $key &>/dev/null
                        set added 1
                    end
                end
            end
            # Fallback: interactive prompt (locked keyring, missing or
            # stale secret after a password change)
            if test $added -eq 0
                ssh-add $key 2>/dev/null
            end
        end

    else if $IS_DARWIN
        # --- Darwin/macOS: Use native Apple Keychain & launchd ---
        set -l loaded (ssh-add -l 2>/dev/null)

        for key in $keys_no_pass
            set -l key_fingerprint (string split ' ' -- (ssh-keygen -lf $key 2>/dev/null))[2]
            if test -z "$key_fingerprint"
                echo "Warning: Could not get fingerprint for $key" >&2
                continue
            end
            if not string match -q -- "*$key_fingerprint*" $loaded
                ssh-add $key 2>/dev/null
            end
        end

        for key in $keys_with_pass
            set -l key_fingerprint (string split ' ' -- (ssh-keygen -lf $key 2>/dev/null))[2]
            if test -z "$key_fingerprint"
                echo "Warning: Could not get fingerprint for $key" >&2
                continue
            end
            if not string match -q -- "*$key_fingerprint*" $loaded
                # Load key into agent and retrieve passphrase automatically
                # from Apple Keychain
                ssh-add --apple-use-keychain $key 2>/dev/null
            end
        end
    end

    # 3. Ensure SSH multiplexing directory exists
    if not test -d ~/.ssh/control_sockets
        mkdir -p ~/.ssh/control_sockets
    end
end
