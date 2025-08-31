# Home Manager Configuration Documentation

This is a modular home-manager configuration designed for Pop!_OS 24.04 LTS with Cosmic DE, following SOLID design principles and focusing on essential terminal-based productivity tools.

## Architecture

The configuration is organized into focused, single-responsibility modules:

### Core Structure

```
├── home.nix                 # Main configuration entry point
├── flake.nix               # Nix flake configuration
├── modules/                # Package modules (SOLID design)
│   ├── packages.nix        # Module coordinator (imports others)
│   ├── core.nix           # Essential system utilities
│   ├── cli-tools.nix      # Modern CLI replacements
│   ├── development.nix    # Development tools and languages
│   ├── productivity.nix   # Productivity applications
│   └── fonts.nix          # Font configuration
├── programs/              # Program-specific configurations
│   ├── git.nix           # Git configuration with delta
│   ├── zsh.nix           # ZSH with starship, aliases, functions
│   ├── tmux.nix          # Tmux configuration
│   └── neovim.nix        # Neovim with LazyVim and tmux integration
└── scripts/              # Custom scripts
    └── tmux-sessionizer.sh # Project session management
```

## Design Principles

### SOLID Compliance

1. **Single Responsibility**: Each module handles one aspect of the system
2. **Open/Closed**: Easy to extend by adding new modules without modifying existing ones
3. **Liskov Substitution**: Modules can be swapped or disabled independently
4. **Interface Segregation**: Clear, minimal interfaces between modules
5. **Dependency Inversion**: High-level modules don't depend on low-level details

### One App Per Purpose Rule

- **System Monitor**: `btop` (not htop)
- **File Manager**: `eza` (not ls)
- **Search**: `ripgrep` (not grep)
- **Find**: `fd` (not find)
- **Git UI**: `lazygit` (single interface)
- **Editor**: `neovim` (terminal-focused)
- **Shell**: `zsh` with `starship` prompt
- **Terminal Multiplexer**: `tmux`

## Module Responsibilities

### Core (`modules/core.nix`)
Essential system utilities that every system needs:
- File operations (curl, wget, unzip, rsync)
- System monitoring (btop)
- File management (tree, du-dust, duf)
- Network tools (dig)
- Archive handling (p7zip)

### CLI Tools (`modules/cli-tools.nix`)
Modern replacements for traditional UNIX tools:
- bat (cat), fd (find), ripgrep (grep), eza (ls)
- zoxide (smart cd), delta (git diff), procs (ps)
- Shell essentials (starship, fzf, direnv)

### Development (`modules/development.nix`)
Programming languages and development tools:
- Version control (lazygit, gh)
- Languages (Node.js, Rust, Python, Go)
- Data processing (jq, yq)
- Containers (docker-compose)

### Productivity (`modules/productivity.nix`)
Minimal set of productivity applications:
- System info (neofetch)
- Cloud sync (rclone)
- Document processing (pandoc)

## Integration Features

### Tmux + Neovim Integration
- Seamless pane navigation with `vim-tmux-navigator`
- Command execution in tmux with `vimux`
- Shared clipboard between tmux and neovim
- Project-based session management

### ZSH Enhancements
- Smart aliases that integrate with tmux workflow
- Functions that auto-suggest tmux sessions for projects
- Modern tool replacements with familiar interfaces
- Starship prompt with git integration

### Project Workflow
1. Use `tmux-sessionizer` (bound to `tms`) to find and switch to projects
2. Automatic tmux session creation for project directories
3. Neovim configured for seamless tmux integration
4. Git workflow optimized with delta and lazygit

## Quick Start

```bash
# Switch to new configuration
home-manager switch

# Start a project session
tms

# Quick git workflow
gst              # git status
gaa && gc "msg"  # add all and commit
gp               # push

# File operations with modern tools
ll               # eza -la --icons
cat file.txt     # bat file.txt
z project        # zoxide to project directory
```

## Customization

### Adding New Packages
1. Determine the appropriate module (core, cli-tools, development, productivity)
2. Add the package to the relevant module
3. Follow the "one app per purpose" rule
4. Update this documentation

### Adding New Programs
1. Create a new file in `programs/`
2. Add the import to `home.nix`
3. Configure the program following the existing patterns

### Environment Variables
All essential environment variables are configured in:
- `programs/zsh.nix` for shell environment
- Individual program files for program-specific variables

## Compatibility

Designed and tested for:
- **OS**: Pop!_OS 24.04 LTS
- **Desktop**: Cosmic DE (Rust-based)
- **Architecture**: x86_64-linux
- **Nix Version**: Compatible with nixpkgs unstable

## Philosophy

This configuration prioritizes:
1. **Terminal-first workflow** - Everything accessible via keyboard and terminal
2. **Minimal but complete** - Essential tools only, no bloat
3. **Consistent interfaces** - Similar commands across different tools
4. **Integration over isolation** - Tools work together seamlessly
5. **Productivity over features** - Focus on getting work done efficiently

The goal is a cohesive, efficient development environment that stays out of your way while providing powerful capabilities when needed.
