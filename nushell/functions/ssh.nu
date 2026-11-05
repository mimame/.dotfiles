# ssh - terminal-aware wrapper (Ghostty / Kitty / Rex), mirrors fish/functions/ssh.fish
#
# - `ghostty +ssh` (>= 1.4): self-contained CLI that installs xterm-ghostty
#   terminfo remotely and forwards COLORTERM/TERM_PROGRAM; safe inside
#   tmux/zellij (https://ghostty.org/docs/features/ssh).
# - `kitten ssh`: speaks an escape-code OTP handshake to the kitty GUI over
#   the TTY - only kitty can answer it, and tmux/zellij intercept the codes,
#   so inside multiplexers we warn and fall back to plain ssh
#   (https://sw.kovidgoyal.net/kitty/kittens/ssh/).
# - Rex (TERM_PROGRAM=rex, REX_SESSION set): use plain ssh + its own ssh
#   terminfo guard (`rex terminfo setup`), never ghostty +ssh.
# - `def --wrapped` keeps unknown flags (-p, -J, -o ...) passing through
#   to ssh untouched instead of tripping nu's argument parser.

def --wrapped "ssh" [
    ...rest # everything is forwarded untouched to ssh
] {
    # Remote session: degrade quietly, wrappers are not there.
    if ("SSH_CONNECTION" in $env) {
        ^ssh ...$rest
        return
    }

    # REX_SESSION (set by every Rex terminal, survives a tmux server start
    # inside one) beats a possibly stale TERM_PROGRAM cached by tmux.
    let term = if ("REX_SESSION" in $env) { "rex" } else { $env.TERM_PROGRAM? }

    match $term {
        "ghostty" => {
            if (which ghostty | is-not-empty) {
                ^ghostty +ssh -- ...$rest
            } else {
                print --stderr "ssh: warning: 'ghostty' CLI not found - falling back to plain ssh (no remote terminfo/env setup)"
                ^ssh ...$rest
            }
        }
        "kitty" => {
            let mux = if ("TMUX" in $env) {
                "tmux"
            } else if ("ZELLIJ" in $env) {
                "zellij"
            } else {
                ""
            }

            if $mux != "" {
                print --stderr $"ssh: warning: inside ($mux), 'kitten ssh' cannot run - its escape-code handshake needs a direct TTY to the kitty GUI - falling back to plain ssh"
                ^ssh ...$rest
            } else if (which kitten | is-not-empty) {
                ^kitten ssh ...$rest
            } else {
                print --stderr "ssh: warning: TERM_PROGRAM=kitty but the 'kitten' CLI is missing (kitty normally bundles it) - falling back to plain ssh"
                ^ssh ...$rest
            }
        }
        # Plain terminals and Rex: ssh pelado. For Rex this is by design -
        # its `rex terminfo setup` ssh guard handles xterm-rex remotes.
        _ => { ^ssh ...$rest }
    }
}
