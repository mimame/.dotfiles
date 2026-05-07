function lrg --description "Search all system logs (dmesg + journalctl/macOS log + /var/log) with ripgrep"
    # WHY four sources: system issues rarely live in just one log. Kernel panics land in dmesg,
    # service failures in journalctl, GUI/app crashes in the macOS unified log, and legacy
    # daemons (nginx, postgres, cron) still write to /var/log. A single command avoids
    # manually checking each source in sequence when debugging an unknown problem.

    if test (count $argv) -eq 0
        echo "Usage: lrg <pattern> [rg options]"
        return 1
    end

    # WHY dmesg first: kernel messages are the lowest-level source — hardware errors, driver
    # failures, OOM kills. Seeing them first gives immediate context for higher-level failures.
    echo "=== kernel (dmesg) ==="
    sudo dmesg | rg $argv

    # WHY -b (current boot only): avoids flooding output with logs from previous boots.
    # For cross-boot searches use: journalctl | rg <pattern>
    if command -q journalctl
        echo "=== journal (current boot) ==="
        journalctl -b | rg $argv
    end

    # WHY --last 1h: macOS unified log is extremely verbose (millions of entries per day).
    # Without a time bound, `log show` dumps gigabytes and takes minutes. 1h covers most
    # active debugging sessions; for wider searches run: log show --last 24h | rg <pattern>
    if test (uname) = Darwin
        echo "=== macOS unified log (last hour) ==="
        log show --last 1h 2>/dev/null | rg $argv
    end

    # WHY /var/log: traditional daemons (nginx, postgres, cron, auth) still write plain log
    # files here on both Linux and macOS, outside journald/unified log.
    # WHY sudo rg: some files (auth.log, secure) are root-readable only.
    # WHY 2>/dev/null: silently skips permission-denied and binary files.
    if test -d /var/log
        echo "=== /var/log ==="
        sudo rg $argv /var/log --glob="*.log" --glob="*.log.*" 2>/dev/null
    end
end
