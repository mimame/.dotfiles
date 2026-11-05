# ssh - terminal-aware wrapper (Ghostty / Kitty / Rex)
#
# Ghostty >= 1.4 ships `ghostty +ssh`: a drop-in ssh wrapper that installs
# the xterm-ghostty terminfo on the remote and forwards COLORTERM/
# TERM_PROGRAM/TERM_PROGRAM_VERSION before exec'ing the real ssh. It is a
# pure CLI action (Ghostty docs: https://ghostty.org/docs/features/ssh), so
# it works from any terminal - including inside tmux/zellij, where
# Ghostty's own ssh-env/ssh-terminfo shell-integration features are NOT
# injected. That gap is exactly why this file exists.
#
# Kitty's `kitten ssh` is different by design: it transfers setup data as a
# base64 tarball over the TTY using escape sequences plus a one-time
# password handshake that only kitty itself answers (kitty docs:
# https://sw.kovidgoyal.net/kitty/kittens/ssh/). `kitten` is bundled with
# kitty, and the handshake cannot reach the GUI from tmux/zellij unless
# passthrough is explicitly enabled - and even then KITTY_PID/
# KITTY_WINDOW_ID may point at a stale window (the tmux server caches them
# from whatever terminal first launched it). Inside a multiplexer we
# therefore degrade to plain ssh and explain why, once per call, on stderr.
#
# Rex (Superlogical, beta: https://www.superlogical.com/rex/docs) sets
# TERM_PROGRAM=rex and REX_SESSION in every terminal it opens and uses
# TERM=xterm-rex. It is NOT the Ghostty app - running `ghostty +ssh` there
# would push xterm-ghostty terminfo onto remotes that never asked for it.
# Rex solves SSH its own way: `rex terminfo setup` installs xterm-rex and
# an ssh guard in ~/.ssh/config that sends xterm-256color to hosts without
# it. So inside Rex: plain ssh, no wrapper, no warning (by design, not
# degradation). Run `rex terminfo setup` once per account (idempotent).

function ssh --description "Terminal-aware ssh: ghostty +ssh / kitten ssh / plain ssh"
    # Remote session: wrapper binaries are not there, and TERM_PROGRAM may
    # have been forwarded here by a wrapper. Plain ssh, quietly.
    if set -q SSH_CONNECTION
        command ssh $argv
        return $status
    end

    set -l term (set -q TERM_PROGRAM; and echo $TERM_PROGRAM)

    # REX_SESSION is set in every terminal Rex opens and survives into a tmux
    # server started inside one; it is a fresher claim on reality than a
    # TERM_PROGRAM cached by an older server. When both conflict, trust Rex.
    if set -q REX_SESSION
        set term rex
    end

    switch $term
        case ghostty
            if command -q ghostty
                ghostty +ssh -- $argv
                return $status
            end
            echo "ssh: warning: 'ghostty' CLI not found - falling back to plain ssh (no remote terminfo/env setup)" >&2
        case kitty
            # Order matters: multiplexer first (handshake cannot reach the
            # GUI even though kitten is installed), then real kitty.
            set -l mux ''
            if set -q TMUX
                set mux tmux
            else if set -q ZELLIJ
                set mux zellij
            end

            if test -n "$mux"
                echo "ssh: warning: inside $mux, 'kitten ssh' cannot run - its escape-code handshake needs a direct TTY to the kitty GUI - falling back to plain ssh" >&2
            else if command -q kitten
                kitten ssh $argv
                return $status
            else
                echo "ssh: warning: TERM_PROGRAM=kitty but the 'kitten' CLI is missing (kitty normally bundles it) - falling back to plain ssh" >&2
            end
    end

    # Everything else: plain terminals, and Rex (see header - the guard in
    # ~/.ssh/config installed by `rex terminfo setup` is the right tool).
    command ssh $argv
end
