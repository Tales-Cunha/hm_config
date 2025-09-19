# Repository Structure

This document explains the organization of this Home Manager configuration.

## Core Files
```
├── flake.nix           # Multi-user/architecture Nix flake
├── home.nix            # Main Home Manager configuration
├── bootstrap.sh        # One-command installation script
├── setup.sh            # Personalization script
├── test.sh             # Configuration validation
└── .gitignore          # Git ignore patterns
```

## Configuration Modules
```
modules/
├── packages.nix        # Module coordinator (imports others)
├── core.nix           # Essential system utilities
├── cli-tools.nix      # Modern CLI replacements
├── development.nix    # Programming tools and languages
├── productivity.nix   # Minimal productivity apps
└── fonts.nix          # Font configuration
```

## Program Configurations
```
programs/
├── git.nix            # Git with delta, aliases, ignores
├── zsh.nix            # ZSH with starship, aliases, functions
├── tmux.nix           # Tmux with vim integration
└── neovim.nix         # Neovim with LazyVim setup
```

## Scripts and Utilities
```
scripts/
└── tmux-sessionizer.sh # Project session manager
```

## Neovim Configuration
```
nvim/
├── init.lua           # LazyVim initialization
├── lazy-lock.json     # Plugin lockfile
├── lazyvim.json       # LazyVim configuration
└── lua/
    ├── config/
    │   ├── autocmds.lua   # Auto commands
    │   ├── keymaps.lua    # Key mappings
    │   └── options.lua    # Editor options
    └── plugins/
        ├── colorscheme.lua
        ├── copilot.lua
        └── tmux-integration.lua
```

## Documentation
```
docs/
├── README.md          # Architecture and design documentation
└── quick-reference.md # Keyboard shortcuts and commands

# Root documentation
├── README.md          # Main usage guide
├── DEPLOY.md          # Deployment instructions
├── OVERVIEW.md        # Complete feature overview
└── STRUCTURE.md       # This file
```

## Design Principles

### Modularity (SOLID)
- **Single Responsibility**: Each module handles one aspect
- **Open/Closed**: Easy to extend without modifying existing code
- **Dependency Inversion**: Clear separation of concerns

### Reproducibility
- Hardware-agnostic configuration
- User-agnostic setup (works for any username)
- Architecture detection (x86_64, ARM64)
- Minimal dependencies

### Simplicity
- One app per purpose (no redundant tools)
- Clear configuration structure
- Comprehensive documentation
- Zero-configuration bootstrap

## Customization Points

### For New Users
1. Run `./bootstrap.sh` - handles everything automatically
2. Run `./setup.sh` - personalizes Git configuration
3. Edit `programs/git.nix` manually if needed

### For Developers
1. Add packages to appropriate `modules/*.nix` files
2. Create new program configs in `programs/`
3. Add custom scripts to `scripts/`
4. Update documentation as needed

### Architecture
The flake automatically detects and supports:
- `x86_64-linux` (Intel/AMD)
- `aarch64-linux` (ARM64)

---

This structure ensures the configuration is maintainable, extensible, and reproducible across different environments.
