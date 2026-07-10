# Dotfiles for NixOS: Productive, Modular, and Declarative

## Table of Contents
- [Goals](#goals)
- [Configuration Philosophy](#configuration-philosophy)
- [Setup](#setup)
- [Essential Tools](#essential-tools)
  - [Terminals](#terminals)
  - [Shells](#shells)
  - [Editors](#editors)
  - [Utilities & Automation](#utilities--automation)
  - [Windows Management](#windows-management)
  - [Files Management](#files-management)
- [Themes](#themes)
- [Conclusion](#conclusion)

# Goals

- Deepen my understanding of NixOS and its ecosystem through hands-on, declarative configuration.
- Enhance my productivity by streamlining daily tasks with thoughtfully chosen tools and automation.

## Configuration Philosophy

All configurations are managed declaratively, leveraging NixOS modules and per-tool config files. This ensures:
- **Reproducibility:** The environment can be rebuilt or migrated easily.
- **Modularity:** Each tool's configuration is isolated and easy to update. Host-specific and user-specific logic is decoupled.
- **Consistency:** Theming and formatting are unified across editors, shells, and productivity tools.
- **Automation:** Integrated `pre-commit` hooks (via `prek`) and CI workflows ensure code quality with `statix`, `treefmt`, and secret scanning.

# Setup

- Operating System: [NixOS](https://nixos.org/): A flexible, declarative Linux distribution that enables reproducible system and user environments.
- Dotfiles Manager: [Dotter](https://github.com/SuperCuber/dotter): (Optional) Manage your configuration files across machines for easy onboarding and migration.

# Essential Tools

This curated selection empowers a focused, efficient, and enjoyable workflow. All tools are configured declaratively and integrated for consistency across the environment.

## Terminals

- [ghostty](https://ghostty.app/): Fast, modern, and hackable GPU-accelerated terminal emulator with superior shell integration.
- [kitty](https://sw.kovidgoyal.net/kitty/): Feature-rich, GPU-based terminal emulator used as a robust secondary option.

## Shells

- [fish](https://fishshell.com/): User-friendly, smart, and interactive shell with powerful autosuggestions, syntax highlighting, and optimized startup performance.
- [nushell](https://www.nushell.sh/): A new type of shell that treats everything as data.

## Editors

- [VSCode](https://code.visualstudio.com/): Work IDE — extensions ecosystem, remote dev, team tooling, and debuggers.
- [Zed](https://zed.dev/): General-purpose editor — fast, Claude-native, modal editing via Helix mode.
- [Helix](https://helix-editor.com/): Terminal editor — SSH sessions, minimal environments, no plugins needed.

## Utilities & Automation

- [atuin](https://atuin.sh/): Magical shell history that replaces your default history with a SQLite database.
- [bat](https://github.com/sharkdp/bat): A cat clone with syntax highlighting and Git integration.
- [borgmatic](https://torsion.org/borgmatic/): Simple, configuration-driven backup software for Borg Backup.
- [btop](https://github.com/aristocratos/btop): Modern, interactive resource monitor showing CPU, memory, and network usage.
- [delta](https://github.com/dandavison/delta): A syntax-highlighting pager for Git, diff, and grep output.
- [fd](https://github.com/sharkdp/fd): A simple, fast and user-friendly alternative to 'find'.
- [jujutsu (jj)](https://martinvonz.github.io/jj/): A Git-compatible DVCS that is simple, powerful, and safe.
- [lazygit](https://github.com/jesseduffield/lazygit): Simple terminal UI for git commands.
- [mise](https://mise.jdx.dev/): Polyglot tool manager, replacing `asdf` for development environment management.
- [ripgrep (rg)](https://github.com/BurntSushi/ripgrep): Extremely fast line-oriented search tool.
- [starship](https://starship.rs/): Minimal, blazing-fast, and infinitely customizable prompt for any shell.
- [television](https://github.com/alexpasmantier/television): Any-input fuzzy finder for the terminal.
- [tmux](https://github.com/tmux/tmux): Terminal multiplexer for session persistence, SSH, and remote work.
- [topgrade](https://github.com/topgrade-rs/topgrade): Upgrade everything at once.
- [zellij](https://zellij.dev/): Terminal workspace multiplexer with a focus on ergonomics and ease of use.

## Windows Management

- [niri](https://github.com/YaLTeR/niri): A scrollable-tiling Wayland compositor focused on ergonomics.
- [dms (DankMaterialShell)](https://github.com/DankMaterialShell/dms): Integrated bar, launcher, and system controls for a modern desktop experience.

## Files Management

- [yazi](https://yazi-rs.github.io): Blazing-fast terminal file manager written in Rust, based on async I/O.
- [clifm](https://github.com/leo-arch/clifm): The shell-like, command-line terminal file manager.
- [broot](https://dystroy.org/broot/): A new way to navigate directory trees.

## MIME Management

This repository employs a sophisticated, declarative system for managing XDG MIME associations:
- **Source of Truth:** `mimeapps/defaults.yaml` defines preferred handlers, including wildcard support (e.g., `text/*`).
- **Generator:** `bin/update-mimeapps.rb` (Ruby) scans the Nix store and standard XDG paths to generate a deterministic `~/.config/mimeapps.list`.
- **Verifier:** `bin/check-mimeapps` (Fish) uses native parallelism and `gio mime` to verify associations in under 3 seconds.
- **Preferred Opener:** `gio open` is prioritized over `xdg-open` across all tools (`o` function, yazi, broot, clifm) for its superior performance and reliable Wayland portal integration.

# Themes

- [Dracula](https://draculatheme.com): The primary dark theme applied across all supported applications, always in dark mode.

Dracula was chosen for contrast and breadth of support. Its background (`#282a36`) paired with its foreground (`#f8f8f2`) produces a contrast ratio of ~12:1, well above the WCAG AAA threshold of 7:1. Catppuccin Mocha has a *darker* background (`#1e1e2e`) but a muted, desaturated foreground (`#cdd6f4`) — intentional in its design — which is why it *feels* lower contrast despite the darker BG. Dracula also has official ports for 300+ applications, making consistent theming across the entire environment practical.


# Conclusion

I'm constantly exploring new tools and refining my workflow. Feel free to reach out if you have any questions, suggestions, or want to discuss NixOS and productivity setups!
