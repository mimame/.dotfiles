# Dotfiles for NixOS: Productive, Modular, and Declarative

## Table of Contents
- [Goals](#goals)
- [Configuration Philosophy](#configuration-philosophy)
- [Setup](#setup)
- [Essential Tools](#essential-tools)
  - [Terminals](#terminals)
  - [Shells](#shells)
  - [Editors](#editors)
  - [Productivity & Automation](#productivity--automation)
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
- **Modularity:** Each tool's configuration is isolated and easy to update.
- **Consistency:** Theming and formatting are unified across editors, shells, and productivity tools.
- **Automation:** Scripts and tools automate repetitive tasks and system maintenance.

# Setup

- Operating System: [NixOS](https://nixos.org/): A flexible, declarative Linux distribution that enables reproducible system and user environments.
- Dotfiles Manager: [Dotter](https://github.com/SuperCuber/dotter): (Optional) Manage your configuration files across machines for easy onboarding and migration.

# Essential Tools

This curated selection empowers a focused, efficient, and enjoyable workflow. All tools are configured declaratively and integrated for consistency across the environment.

## Terminals

- [kitty](https://sw.kovidgoyal.net/kitty/): Fast, feature-rich, GPU-based terminal emulator with advanced features and theming support.
- [wezterm](https://wezfurlong.org/wezterm/index.html): GPU-accelerated terminal emulator for a smooth, modern experience.
- [ghostty](https://ghostty.app/): Fast, minimal, GPU-accelerated terminal emulator with modern features and configuration flexibility.

## Shells

- [fish](https://fishshell.com/): User-friendly, smart, and interactive shell with powerful autosuggestions, syntax highlighting, and a modern scripting language.

## Editors

- [helix](https://helix-editor.com/): Powerful, modal code editor with tree-sitter support and fast navigation.
- [lazyvim](https://www.lazyvim.org): Feature-rich Neovim configuration built for productivity and extensibility.
- [zellij](https://zellij.dev/): Terminal multiplexer for managing multiple terminal sessions efficiently, with workspace and layout support.

## Productivity & Automation

- [bat](https://github.com/topics/batcat): Fast, colorful alternative to cat with syntax highlighting and git integration.
- [broot](https://dystroy.org/broot/): Tree-based file browser for easy navigation and file management.
- [btop](https://github.com/topics/monitor-performance): Modern, interactive resource monitor for system performance.
- [delta](https://github.com/dandavison/delta): Visually appealing alternative to git diff for better code review.
- [fd](https://github.com/sharkdp/fd): Lightning-fast file searcher for quickly locating files.
- [handlr](https://github.com/topics/handle): Smarter alternative to xdg-open for handling file types and URLs.
- [lazygit](https://github.com/jesseduffield/lazygit): User-friendly terminal UI for Git, making version control more accessible.
- [logseq](https://logseq.com/): Zettelkasten-inspired note-taking app for organizing thoughts and knowledge.
- [ripgrep](https://github.com/BurntSushi/ripgrep): Blazing-fast tool for searching text content within your codebase or files.
- [starship](https://starship.rs/): Modern, informative shell prompt that enhances the terminal experience and integrates with multiple shells.
- [tealdeer](https://github.com/tealdeer-rs/tealdeer): Provides concise TL;DR explanations for popular command-line tools.
- [topgrade](https://github.com/topgrade-rs/topgrade): Unified system upgrade tool for NixOS packages and more, keeping your system up-to-date.

## Windows Management

- [niri](https://github.com/YaLTeR/niri): Modern, tiling Wayland window manager focused on simplicity, ergonomics, and declarative configuration.
- [rofi](https://www.rofi.com/): Customizable application launcher for quick access to apps and scripts.
- [walker](https://github.com/abenz1267/walker): Minimal, fast Wayland application launcher for quickly finding and launching apps (alternative to rofi/dmenu).

## Files Management

- [clifm](https://github.com/leo-arch/clifm): Shell-like, command-line terminal file manager for fast navigation.
- [yazi](https://yazi-rs.github.io): Blazing-fast terminal file manager written in Rust, based on async I/O, with modern features.

# Themes

- [Catppuccin](https://catppuccin.com): Community-driven pastel theme for a cohesive, visually pleasing environment across tools.
- [Tokyo Night](https://github.com/folke/tokyonight.nvim): Clean, vibrant theme inspired by the lights of downtown Tokyo at night.

# Conclusion

I'm constantly exploring new tools and refining my workflow. Feel free to reach out if you have any questions, suggestions, or want to discuss NixOS and productivity setups!
