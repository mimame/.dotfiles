function setup_ssh_agent --description "Initialize SSH agent and load keys via keychain"
    # Proactively load specific keys using keychain.
    #
    # WHY: System agents (like GNOME's GCR) often fail to prompt for passphrases
    # for ed25519 keys or specific identities. Running keychain unconditionally
    # ensures these keys are unlocked and available for Git operations.
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
