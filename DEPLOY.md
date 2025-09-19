# Quick Deployment Guide

This guide shows how to deploy this Home Manager configuration to a new machine.

## Method 1: One-Command Bootstrap (Easiest)

Run this on the target machine:

```bash
bash <(curl -sSL https://raw.githubusercontent.com/Tales-Cunha/hm_config/main/bootstrap.sh)
```

This will:
1. Install Nix (if needed)
2. Clone this repository
3. Configure for your username
4. Apply the Home Manager configuration

## Method 2: Manual Steps

### 1. Install Nix
```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### 2. Enable flakes
```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
```

### 3. Clone and customize
```bash
git clone https://github.com/Tales-Cunha/hm_config.git ~/.config/home-manager
cd ~/.config/home-manager

# Replace 'template' with your username
sed -i "s/\"template\"/\"$(whoami)\"/g" flake.nix
```

### 4. Test and apply
```bash
# Test configuration
nix flake check

# Apply configuration  
nix run home-manager/master -- switch --flake ".#$(whoami)"
```

### 5. Personalize (optional)
```bash
./setup.sh  # Set your Git name and email
```

## Post-Installation

1. **Restart your shell** or source your shell config:
   ```bash
   source ~/.zshrc  # or ~/.bashrc
   ```

2. **Test key features**:
   ```bash
   tms          # tmux sessionizer
   ll           # modern ls (eza)
   bat --help   # syntax-highlighted cat
   z <dir>      # smart cd (zoxide)
   ```

3. **Update Git info** (if you didn't run setup.sh):
   ```bash
   # Edit programs/git.nix with your name/email
   home-manager switch --flake ".#$(whoami)"
   ```

## Supported Systems

- **x86_64-linux**: Intel/AMD 64-bit Linux
- **aarch64-linux**: ARM64 Linux (Apple Silicon, Raspberry Pi)
- **Non-NixOS**: Ubuntu, Fedora, Arch, etc.

## Troubleshooting

- **Command not found**: Restart terminal or source shell config
- **Permission denied**: Make sure scripts are executable (`chmod +x *.sh`)
- **Build errors**: Run `nix flake check` to see syntax issues
- **Update needed**: `cd ~/.config/home-manager && git pull && home-manager switch`

---

**That's it!** Your minimal, reproducible development environment is ready.
