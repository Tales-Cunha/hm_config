# Minimal Home Manager Configuration

A minimal, reproducible Home Manager configuration that works on any Linux system (non-NixOS).

## Features

- **Multi-architecture support**: x86_64 and ARM64
- **Multi-user support**: Works for any username
- **Minimal dependencies**: Only essential tools
- **Terminal-focused**: Modern CLI tools and workflow

## Quick Start

### One-command setup (recommended):

```bash
curl -sSL https://raw.githubusercontent.com/Tales-Cunha/hm_config/main/bootstrap.sh | bash
```

### Manual setup:

1. **Install Nix** (if not already installed):
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
   ```

2. **Clone and apply configuration**:
   ```bash
   git clone https://github.com/Tales-Cunha/hm_config.git ~/.config/home-manager
   cd ~/.config/home-manager
   
   # Customize for your username (replace 'yourusername')
   sed -i 's/"template"/"yourusername"/g' flake.nix
   
   # Apply configuration
   nix run home-manager/master -- switch --flake ".#yourusername"
   ```

3. **Personalize** (optional):
   ```bash
   ./setup.sh  # Updates Git name/email
   ```

## What's Included

### Core Tools
- `bat` (better cat), `eza` (better ls), `fd` (better find)
- `ripgrep` (better grep), `zoxide` (smart cd)
- `fzf` (fuzzy finder), `starship` (prompt)

### Development
- `neovim` with LazyVim configuration
- `tmux` with vim integration
- `git` with delta (better diffs)
- `lazygit` (terminal git UI)

### Languages & Tools
- Node.js, Python, Go, Rust
- Docker support
- JSON/YAML processors (`jq`, `yq`)

## Usage

- **Start project session**: `tms` (tmux sessionizer)
- **File operations**: `ll` (eza), `cat` (bat), `z <dir>` (zoxide)
- **Search**: `rg <pattern>`, `fd <filename>`
- **Git workflow**: `gst`, `gaa`, `gc "message"`, `gp`

## Customization

### Add packages
Edit `modules/` files:
- `core.nix` - Essential system tools
- `cli-tools.nix` - Modern CLI replacements
- `development.nix` - Programming tools
- `productivity.nix` - Additional apps

### Modify programs
Edit files in `programs/`:
- `git.nix` - Git configuration
- `zsh.nix` - Shell aliases and functions
- `tmux.nix` - Terminal multiplexer
- `neovim.nix` - Editor configuration

## Architecture Support

- **x86_64-linux**: Standard Intel/AMD 64-bit
- **aarch64-linux**: ARM64 (Apple M1/M2, Raspberry Pi 4+)

Automatic detection during bootstrap.

## Troubleshooting

### Common issues:

1. **Nix not in PATH**: Restart terminal or run:
   ```bash
   source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
   ```

2. **Permission errors**: Ensure your user is in `nix-users` group

3. **Configuration errors**: Test with:
   ```bash
   nix flake check
   ```

### Update configuration:
```bash
cd ~/.config/home-manager
git pull
home-manager switch --flake ".#$(whoami)"
```

## Testing

To test this configuration on a clean system, see [`TESTING.md`](TESTING.md) for comprehensive testing instructions.

**Quick test**: Use the removal script (⚠️ **WARNING**: removes all Nix data!):
```bash
./scripts/remove-nix.sh  # Clean removal
./bootstrap.sh           # Test fresh install
```

## Requirements

- Linux system (non-NixOS)
- Curl and Git
- Sudo access for Nix installation
- 1GB+ free space

---

**Note**: This configuration prioritizes simplicity and reproducibility. It includes only essential tools for a productive terminal workflow.
