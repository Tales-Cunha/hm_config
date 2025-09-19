# Home Manager Configuration - Deployment Overview

## ✅ Complete Reproducible Setup

This Home Manager configuration is now **fully reproducible** and ready for deployment on any Linux hardware.

## 🚀 Quick Deployment Options

### Option 1: Local Bootstrap (from this directory)
```bash
./bootstrap.sh
```

### Option 2: Remote Bootstrap (when pushed to GitHub)
```bash
curl -sSL https://raw.githubusercontent.com/Tales-Cunha/hm_config/main/bootstrap.sh | bash
```

### Option 3: Manual Steps
See [`DEPLOY.md`](DEPLOY.md) for detailed manual installation steps.

## 📁 What's Included

### Core Files
- **`flake.nix`**: Multi-user, multi-architecture Nix flake
- **`home.nix`**: Main Home Manager configuration  
- **`bootstrap.sh`**: One-command installation script
- **`setup.sh`**: Personalization script (Git name/email)
- **`test.sh`**: Configuration validation script

### Modular Configuration
- **`modules/`**: Package management (core, CLI tools, development, productivity)
- **`programs/`**: Program configurations (Git, ZSH, Tmux, Neovim)
- **`scripts/`**: Custom utilities (tmux-sessionizer)

### Documentation
- **`README.md`**: Complete usage guide
- **`DEPLOY.md`**: Step-by-step deployment instructions
- **`docs/`**: Additional documentation and quick reference

## 🏗️ Architecture Support

- ✅ **x86_64-linux**: Intel/AMD 64-bit systems
- ✅ **aarch64-linux**: ARM64 systems (Apple Silicon, Raspberry Pi 4+)
- ✅ **Multi-user**: Works for any username
- ✅ **Non-NixOS**: Ubuntu, Fedora, Arch, Debian, etc.

## 🛠️ What Gets Installed

### Essential CLI Tools
- `bat` (better cat), `eza` (better ls), `fd` (better find)
- `ripgrep` (better grep), `zoxide` (smart cd), `fzf` (fuzzy finder)
- `starship` (modern prompt), `direnv` (environment manager)

### Development Environment
- **Editor**: Neovim with LazyVim configuration
- **Terminal**: Tmux with vim integration and sessionizer
- **Git**: Enhanced with Delta (better diffs) and LazyGit
- **Languages**: Node.js, Python, Go, Rust toolchains
- **Tools**: jq, yq, docker-compose, gh (GitHub CLI)

### System Monitoring
- `btop` (system monitor), `du-dust` (disk usage), `duf` (df alternative)
- `procs` (better ps), `tree` (directory tree)

## 🎯 Deployment Workflow

1. **Run bootstrap script** → Installs Nix, clones config, applies setup
2. **Personalize** (optional) → Run `./setup.sh` to set Git name/email
3. **Use immediately** → Modern CLI tools and development environment ready
4. **Update anytime** → `git pull && home-manager switch`

## 🧪 Quality Assurance

- **Syntax validation**: `nix flake check`
- **Build testing**: Configuration builds without errors  
- **Architecture detection**: Automatic platform support
- **Minimal dependencies**: Only essential packages included

## 📖 Key Features for Reproducibility

1. **Hardware-agnostic**: Works on any Linux system
2. **User-agnostic**: Automatically configures for any username
3. **Architecture-aware**: Supports x86_64 and ARM64
4. **Zero-configuration**: Bootstrap script handles everything
5. **Minimal footprint**: Only essential tools, no bloat
6. **Self-contained**: All dependencies managed by Nix

## 🎮 Post-Installation Usage

```bash
# Start a project session
tms

# Modern file operations
ll              # eza -la --icons
cat file.txt    # bat file.txt  
z projects      # zoxide to projects/
rg "pattern"    # ripgrep search

# Git workflow
gst             # git status
gaa && gc "msg" # add all & commit
lazygit         # terminal git UI

# Development
nvim           # LazyVim-configured editor
tmux           # Terminal multiplexer with vim integration
```

---

**Ready to deploy!** 🎉 This configuration provides a complete, minimal, and reproducible terminal-focused development environment for any Linux system.
