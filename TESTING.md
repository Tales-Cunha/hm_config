# Testing the Reproducible Setup

This guide explains how to test the Home Manager configuration on a clean system.

## ⚠️ Testing on Current System

### Step 1: Remove Nix (CAREFUL!)

**### Reset Home Manager
```bash
rm -rf ~/.config/home-manager
# Re-clone your config
git clone https://github.com/Tales-Cunha/hm_config.git ~/.config/home-manager
```

### Docker/Container Issues

If you get systemd errors in Docker:
```bash
# The bootstrap script now handles this automatically, but you can also run:
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install linux --init none
```

**Note**: In containers without systemd, you'll need to manually source Nix:
```bash
source ~/.nix-profile/etc/profile.d/nix.sh
```G**: This will completely remove Nix and all packages from your system!

```bash
# Review the script first
cat scripts/remove-nix.sh

# Run the removal script
./scripts/remove-nix.sh

# Restart your terminal
exit  # and open a new terminal
```

### Step 2: Verify Clean State

```bash
# These should return nothing or "not found"
which nix
which home-manager
ls /nix  # should not exist
echo $PATH | grep nix  # should be empty
```

### Step 3: Test Bootstrap

```bash
# Test the bootstrap script
./bootstrap.sh

# Or with force reinstall (if you get installation conflicts)
./bootstrap.sh --force

# Quick cleanup for testing (alternative to remove-nix.sh)
./scripts/cleanup-nix.sh

# Or test from GitHub (if pushed)
# curl -sSL https://raw.githubusercontent.com/Tales-Cunha/hm_config/main/bootstrap.sh | bash
```

### Step 4: Verify Installation

```bash
# Test key tools are available
which nvim
which tmux  
which bat
which eza
ll  # should work with icons
bat --version

# Test Home Manager
home-manager --version

# Test tmux sessionizer
tms
```

## 🐳 Testing with Docker

For safer testing, use a Docker container:

### Ubuntu Test
```bash
# Create test container
docker run -it --rm ubuntu:22.04 bash

# Inside container:
apt update && apt install -y curl git sudo
adduser testuser --disabled-password --gecos ""
echo "testuser:testuser" | chpasswd
usermod -aG sudo testuser
su testuser
cd /home/testuser

# Clone and test
git clone https://github.com/Tales-Cunha/hm_config.git
cd hm_config
./bootstrap.sh
```

### Fedora Test
```bash
docker run -it --rm fedora:38 bash

# Inside container:
dnf install -y curl git sudo
useradd -m testuser
echo "testuser:testuser" | chpasswd
usermod -aG wheel testuser
su testuser
cd /home/testuser

# Clone and test
git clone https://github.com/Tales-Cunha/hm_config.git
cd hm_config
./bootstrap.sh
```

## 🏗️ Virtual Machine Testing

For complete hardware testing:

1. **Create VM** with fresh Linux install (Ubuntu, Fedora, etc.)
2. **Install minimal requirements**:
   ```bash
   # Ubuntu/Debian
   sudo apt update && sudo apt install -y curl git
   
   # Fedora/RHEL
   sudo dnf install -y curl git
   
   # Arch
   sudo pacman -S curl git
   ```
3. **Clone and bootstrap**:
   ```bash
   git clone https://github.com/Tales-Cunha/hm_config.git ~/.config/home-manager
   cd ~/.config/home-manager
   ./bootstrap.sh
   ```

## 🧪 Automated Testing

### Test Script Validation
```bash
# Run the built-in test
./test.sh

# Manual validation
nix flake check
nix build .#homeConfigurations.$(whoami).activationPackage --no-link
```

### Multi-Architecture Testing

**x86_64 (Intel/AMD)**:
- Standard desktop/laptop
- Most cloud instances

**aarch64 (ARM64)**:
- Apple Silicon Macs with Linux
- Raspberry Pi 4+ with 64-bit OS
- ARM-based cloud instances

## 🔍 What to Verify

### Essential Tools Work
- [ ] `ll` shows files with icons
- [ ] `bat file.txt` shows syntax highlighting
- [ ] `z directory` for smart navigation
- [ ] `rg pattern` for fast search
- [ ] `fd filename` for file finding

### Development Environment
- [ ] `nvim` opens with LazyVim
- [ ] `tmux` starts with custom config
- [ ] `tms` opens project sessionizer
- [ ] Git commands work with delta diffs
- [ ] `lazygit` opens terminal git UI

### Programming Languages
- [ ] `node --version`
- [ ] `python3 --version` 
- [ ] `go version`
- [ ] `rustc --version`

### System Integration
- [ ] ZSH with starship prompt
- [ ] Tmux + Neovim navigation works
- [ ] Custom aliases and functions available
- [ ] Scripts in `~/.local/bin/` are executable

## 🚨 Recovery

If something goes wrong during testing:

### Restore Nix (if removed)
```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### Restore Shell Config
```bash
# Your configs were backed up with timestamps
ls ~/.bashrc.bak.* ~/.zshrc.bak.*
# Restore if needed:
# cp ~/.zshrc.bak.TIMESTAMP ~/.zshrc
```

### Reset Home Manager
```bash
rm -rf ~/.config/home-manager
# Re-clone your config
git clone https://github.com/Tales-Cunha/hm_config.git ~/.config/home-manager
```

---

**Remember**: Always test in a VM or container first before testing on your main system!
