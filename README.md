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

- [evil-helix](https://github.com/ma-m/evil-helix): A modal code editor inspired by Neovim and Kakoune, optimized for speed.
- [lazyvim](https://www.lazyvim.org): Feature-rich Neovim configuration built for productivity and extensibility.
- [zed](https://zed.dev/): High-performance, collaborative code editor with native Nix support.
- [fresh-editor](https://github.com/fresh-editor/fresh): Terminal-based text editor with LSP support.

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
- [topgrade](https://github.com/topgrade-rs/topgrade): Upgrade everything at once.
- [zellij](https://zellij.dev/): Terminal workspace multiplexer with a focus on ergonomics and ease of use.

## Windows Management

- [niri](https://github.com/YaLTeR/niri): A scrollable-tiling Wayland compositor focused on ergonomics.
- [dms (DankMaterialShell)](https://github.com/DankMaterialShell/dms): Integrated bar, launcher, and system controls for a modern desktop experience.

## Files Management

- [yazi](https://yazi-rs.github.io): Blazing-fast terminal file manager written in Rust, based on async I/O.
- [clifm](https://github.com/leo-arch/clifm): The shell-like, command-line terminal file manager.
- [broot](https://dystroy.org/broot/): A new way to navigate directory trees.

# Themes

- [Dracula](https://draculatheme.com): The primary dark theme applied across all supported applications.


# Conclusion

I'm constantly exploring new tools and refining my workflow. Feel free to reach out if you have any questions, suggestions, or want to discuss NixOS and productivity setups!
