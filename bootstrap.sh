#!/bin/bash
# Minimal Home Manager Bootstrap Script
# Works on any Linux distribution (non-NixOS)

set -euo pipefail

# Parse arguments
FORCE_REINSTALL=false
if [[ "${1:-}" == "--force" ]] || [[ "${1:-}" == "-f" ]]; then
    FORCE_REINSTALL=true
    info "Force reinstall mode enabled"
fi

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }
warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }

info "Home Manager Bootstrap - Minimal Installation"
echo "=============================================="
echo "Usage: $0 [--force|-f]"
echo "  --force, -f    Force reinstall Nix even if already present"
echo ""

# Get user info
USER=${USER:-$(whoami)}
info "Setting up for user: $USER"

# Detect architecture
ARCH=$(uname -m)
case $ARCH in
  x86_64) SYSTEM="x86_64-linux" ;;
  aarch64|arm64) SYSTEM="aarch64-linux" ;;
  *) error "Unsupported architecture: $ARCH"; exit 1 ;;
esac
info "Detected system: $SYSTEM"

# Install Nix if not present or force reinstall
if ! command -v nix &> /dev/null || [ "$FORCE_REINSTALL" = true ]; then
  if [ "$FORCE_REINSTALL" = true ] && command -v nix &> /dev/null; then
    info "Force reinstall requested, removing existing Nix installation..."
  else
    info "Installing Nix..."
  fi
  
  # Check for existing installation receipt and handle it
  if [ -f "/nix/receipt.json" ]; then
    info "Found existing Nix installation receipt, attempting to uninstall cleanly..."
    if command -v /nix/nix-installer &> /dev/null; then
      /nix/nix-installer uninstall || {
        warning "Automatic uninstall failed, trying alternative cleanup..."
        # If the uninstaller fails, we'll try to proceed anyway
        # The new installer might be able to handle the existing installation
      }
    else
      warning "Nix installer not found, proceeding with installation (installer may handle existing setup)..."
    fi
  fi
  
  # Check if we're in a container or system without systemd
  if ! systemctl is-system-running &>/dev/null && ! pgrep systemd &>/dev/null; then
    info "Detected container/non-systemd environment, using no-daemon installer..."
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install linux --init none
  else
    info "Using standard systemd installer..."
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
  fi
  
  # Source nix after installation
  if [ -f "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
    . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
  elif [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
    . "$HOME/.nix-profile/etc/profile.d/nix.sh"
  fi
  
  # Verify Nix is now available
  if ! command -v nix &> /dev/null; then
    error "Nix installation failed - command not found after sourcing"
    info "Try manually running: source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
    exit 1
  fi
  
  # Enable flakes
  mkdir -p ~/.config/nix
  echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
else
  success "Nix already installed"
  # Still need to source it for the current session
  if [ -f "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then
    . "/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
  elif [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
    . "$HOME/.nix-profile/etc/profile.d/nix.sh"
  fi
fi

# Setup config directory
CONFIG_DIR="$HOME/.config/home-manager"
if [ ! -d "$CONFIG_DIR" ]; then
  info "Cloning configuration..."
  # Clone from current directory if local, otherwise from GitHub
  if [ -f "$(dirname "$0")/flake.nix" ]; then
    cp -r "$(dirname "$0")" "$CONFIG_DIR"
  else
    git clone https://github.com/Tales-Cunha/hm_config.git "$CONFIG_DIR"
  fi
else
  info "Configuration directory exists, updating..."
  cd "$CONFIG_DIR" && git pull 2>/dev/null || info "Using local configuration"
fi

cd "$CONFIG_DIR"

# Customize flake for current user
info "Customizing configuration for $USER..."
sed -i "s/\"template\"/\"$USER\"/g" flake.nix
sed -i "s/template/$USER/g" flake.nix

# Test configuration
info "Testing configuration..."
if nix flake check; then
  success "Configuration is valid"
else
  error "Configuration has errors"
  exit 1
fi

# Apply configuration
info "Applying Home Manager configuration..."
nix run home-manager/master -- switch --flake ".#$USER"

success "Home Manager setup complete!"
info "Remember to:"
echo "  1. Edit programs/git.nix with your name/email"
echo "  2. Restart your shell or run: source ~/.bashrc (or ~/.zshrc)"
echo "  3. Run 'tms' to start using tmux sessions"
